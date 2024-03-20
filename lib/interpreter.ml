open Ast

module NameMap = Map.Make(String)

type vsymtab = int NameMap.t

type env = vsymtab * vsymtab

exception ReturnException of int * vsymtab

let bool_to_int (b : bool) : int =
  if b then 1 else 0

(* Evaluate an expression and return its value along with the updated environment *)
let rec eval (env : env) (expr : Ast.expr) : int * env =
  match expr with
  | Lit(i) -> (i, env)
  | Blit(b) -> (bool_to_int b, env)
  | Id(var) ->
      let locals, globals = env in
      if NameMap.mem var locals then
        (NameMap.find var locals), env
      else if NameMap.mem var globals then
        (NameMap.find var globals), env
      else raise (Failure ("undeclared identifier " ^ var))
  | Ass(var, e) ->
      let v, (locals, globals) = eval env e in
      if NameMap.mem var locals then
        v, (NameMap.add var v locals, globals)
      else if NameMap.mem var globals then
        v, (locals, NameMap.add var v globals)
      else raise (Failure ("undeclared identifier " ^ var))
  | Bop(e1, op, e2) ->
      let v1, env = eval env e1 in
      let v2, env = eval env e2 in
      let boolean_to_int i = if i then 1 else 0 in
      (match op with
      | Add -> v1 + v2
      | Sub -> v1 - v2
      | Mul -> v1 * v2
      | Div -> v1 / v2
      | Mod -> v1 mod v2
      | And -> boolean_to_int (v1 != 0 && v2 != 0)
      | Or -> boolean_to_int (v1 != 0 || v2 != 0)
      | Eq -> boolean_to_int (v1 = v2)
      | Neq -> boolean_to_int (v1 != v2)
      | Lt -> boolean_to_int (v1 < v2)
      | Gt -> boolean_to_int (v1 > v2)
      | Leq -> boolean_to_int (v1 <= v2)
      | Geq -> boolean_to_int (v1 >= v2)), env
  | _ -> (0, env) (* For unsupported expressions, return 0 *)

(* Execute a statement and return an updated environment *)
let rec exec (env : env) (stmt : Ast.stmt) : env =
  match stmt with
  | Block(stmts) -> List.fold_left exec env stmts
  | Expr(e) -> let _, env = eval env e in env
  | Return(e) -> let v, (_, globals) = eval env e in raise (ReturnException(v, globals))
  | If(e, s1, s2) ->
      let v, env = eval env e in
      exec env (if v != 0 then s1 else s2)
  | While(e, s) ->
      let rec loop env =
        let v, env = eval env e in
        if v != 0 then loop (exec env s) else env
      in loop env
  | _ -> env (* For unsupported statements, return the environment unchanged *)

(* Main entry point: run a program *)
let rec run ((vars, funcs) : program) : unit =
  let globals : vsymtab = List.fold_left
    (fun globals (_, name) -> NameMap.add name 0 globals)
    NameMap.empty vars
  in
  try
    (* Build a symbol table for function declarations *)
    let func_decls : (func_decl NameMap.t) = List.fold_left
      (fun funcs fdecl -> NameMap.add fdecl.fname fdecl funcs)
      NameMap.empty funcs
    in
    (* Execute the "main" function; discard final state of globals *)
    ignore (call (NameMap.find "main" func_decls) [] globals)
  with Not_found ->
    raise (Failure ("did not find the main() function"))

(* Invoke a function and return an updated global symbol table *)
and call (fdecl : func_decl) (actuals : int list) (globals : vsymtab) : vsymtab =
  let locals : vsymtab =
    try List.fold_left2
      (fun locals (_, name) actual -> NameMap.add name actual locals)
      NameMap.empty fdecl.formals actuals
    with Invalid_argument(_) ->
      raise (Failure ("wrong number of arguments to " ^ fdecl.fname))
  in
  let locals : vsymtab = List.fold_left
    (fun locals (_, name) -> NameMap.add name 0 locals)
    locals fdecl.locals
  in
  (* Execute each statement; return updated global symbol table *)
  snd (List.fold_left exec (locals, globals) fdecl.body)

