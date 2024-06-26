open Ast
open Bytecode
module StringMap = Map.Make (String)

(* symbol table: information about all the names in scope *)
type env = {
  function_index : int StringMap.t;
  global_index : int StringMap.t;
  local_index : int StringMap.t;
}

(* enum : int -> 'a list -> (int * 'a) list *)
let rec enum stride n = function
  | [] -> []
  | hd :: tl -> (n, hd) :: enum stride (n + stride) tl

(* string_map_pairs: StringMap 'a -> (int * 'a) list -> StringMap 'a *)
let string_map_pairs map pairs =
  List.fold_left (fun m (i, n) -> StringMap.add n i m) map pairs

(* Translate a program in AST form into a bytecode program.
    Throw an exception if something is wrong *)
let translate (globals, functions) =
  (* Allocate "addresses" for each global variable *)
  let global_indexes = string_map_pairs StringMap.empty (enum 1 0 globals) in

  (* Assign indexes to function names; built-in "print" is special *)
  let built_in_functions = StringMap.add "print" (-1) StringMap.empty in
  let function_indexes =
    string_map_pairs built_in_functions
      (enum 1 1 (List.map (fun f -> f.fname) functions))
  in

  (* Translate an AST function to a list of bytecode statements *)
  let translate env fdecl =
    (* Bookkeeping: FP offsets for locals and arguments *)
    let num_formals = List.length fdecl.formals
    and num_locals = List.length fdecl.locals
    and local_offsets = enum 1 1 fdecl.locals
    and formal_offsets = enum (-1) (-2) fdecl.formals in
    let prepare_for_map pairs =
      List.map (fun (i, (_, name)) -> (i, name)) pairs
    in
    let env =
      {
        env with
        local_index =
          (let adjusted_locals = prepare_for_map local_offsets in
           let adjusted_formals = prepare_for_map formal_offsets in
           string_map_pairs StringMap.empty (adjusted_locals @ adjusted_formals));
      }
    in
    (* Translate an expression *)
    let rec expr : expr -> bstmt list = function
      | Ast.Lit i -> [ Lit i ]
      | Id s -> (
          try [ Lfp (StringMap.find s env.local_index) ]
          with Not_found -> (
            try [ Lod (StringMap.find s env.global_index) ]
            with Not_found -> raise (Failure ("undeclared variable " ^ s))))
      | Binop (e1, op, e2) -> expr e1 @ expr e2 @ [ Bin op ]
      | Assign (s, e) -> (
          expr e
          @
          try [ Sfp (StringMap.find s env.local_index) ]
          with Not_found -> (
            try [ Str (StringMap.find s env.global_index) ]
            with Not_found -> raise (Failure ("undeclared variable " ^ s))))
      | Call (fname, actuals) -> (
          try
            List.concat (List.map expr (List.rev actuals))
            @ [ Jsr (StringMap.find fname env.function_index) ]
          with Not_found -> raise (Failure ("undefined function " ^ fname)))
      (* Translate a statement *)
    in

    let rec stmt = function
      | Block sl -> List.concat (List.map stmt sl)
      | Expr e -> expr e @ [ Drp ] (* Discard result *)
      | Return e -> expr e @ [ Rts num_formals ]
      | If (p, t, f) ->
          let t' = stmt t and f' = stmt f in
          expr p
          @ [ Beq (2 + List.length t') ]
          @ t'
          @ [ Bra (1 + List.length f') ]
          @ f'
      | While (e, b) ->
          let b' = stmt b and e' = expr e in
          [ Bra (1 + List.length b') ]
          @ b' @ e'
          @ [ Bne (-(List.length b' + List.length e')) ]
      (* Translate a whole function *)
    in

    [ Ent num_locals ]
    (* Entry: allocate space for locals *)
    @ stmt (Block fdecl.body)
    @ (* Body *)
    [ Lit 0; Rts num_formals ]
    (* Default = return 0 *)
  in

  let env =
    {
      function_index = function_indexes;
      global_index = global_indexes;
      local_index = StringMap.empty;
    }
  in

  (* Code executed to start the program: Jsr main; halt *)
  let entry_function =
    try [ Jsr (StringMap.find "main" function_indexes); Hlt ]
    with Not_found -> raise (Failure "no \"main\" function")
  in
  (* Compile the functions *)
  let func_bodies = entry_function :: List.map (translate env) functions in
  (* Calculate function entry points by adding their lengths *)
  let fun_offset_list, _ =
    List.fold_left
      (fun (l, i) f -> (i :: l, i + List.length f))
      ([], 0) func_bodies
  in
  let func_offset = Array.of_list (List.rev fun_offset_list) in
  {
    num_globals = List.length globals;
    (* Concatenate the compiled functions and replace the function
       indexes in Jsr statements with PC values *)
    text =
      Array.of_list
        (List.map
           (function Jsr i when i > 0 -> Jsr func_offset.(i) | _ as s -> s)
           (List.concat func_bodies));
  }
