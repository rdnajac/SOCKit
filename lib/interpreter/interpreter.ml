open Ast
module NameMap = Map.Make (String)

type vsymtab = int NameMap.t
type env = vsymtab * vsymtab

exception ReturnException of int * vsymtab

let rec eval (env : env) (expr : Ast.expr) : int * env =
  match expr with
  | Noexpr -> (1, env)
  | Lit i -> (i, env)
  | Id var ->
      let locals, globals = env in
      if NameMap.mem var locals then (NameMap.find var locals, env)
      else if NameMap.mem var globals then (NameMap.find var globals, env)
      else raise (Failure ("undeclared identifier " ^ var))
  | Assign (var, e) ->
      let v, env' = eval env e in
      let locals, globals = env' in
      if NameMap.mem var locals then (v, (NameMap.add var v locals, globals))
      else if NameMap.mem var globals then
        (v, (locals, NameMap.add var v globals))
      else raise (Failure ("undeclared identifier " ^ var))
  | Binop (e1, op, e2) ->
      let v1, env' = eval env e1 in
      let v2, env'' = eval env' e2 in
      let result =
        match op with
        | Add -> v1 + v2
        | Sub -> v1 - v2
        | Mul -> v1 * v2
        | Div -> if v2 = 0 then raise (Failure "zero-division!") else v1 / v2
        | Mod -> if v2 = 0 then raise (Failure "zero-division!") else v1 mod v2
        | And -> if v1 != 0 && v2 != 0 then 1 else 0
        | Or -> if v1 != 0 || v2 != 0 then 1 else 0
        | Lt -> if v1 < v2 then 1 else 0
        | Le -> if v1 <= v2 then 1 else 0
        | Gt -> if v1 > v2 then 1 else 0
        | Ge -> if v1 >= v2 then 1 else 0
        | Eq -> if v1 = v2 then 1 else 0
        | Neq -> if v1 != v2 then 1 else 0
      in
      (result, env'')
  | Call (fname, actuals) ->
    let locals, globals = env in
    (* Find the function declaration by name in globals. This assumes
       function declarations are stored in globals, which might not be 
       your intended design. *)
    let func_decl = NameMap.find fname globals in
    (* Evaluate the actual arguments in the current environment *)
    let actuals_evaluated, env' = List.fold_left
        (fun (acc, env) expr ->
            let result, env_updated = eval env expr in
            (result :: acc, env_updated))
        ([], env)
        (List.rev actuals) in
    (* Now, execute the function with the evaluated arguments.
       This requires you to have a function like `execute_function` that
       is responsible for executing the function body. *)
    let globals' = execute_function func_decl actuals_evaluated globals in
    (0, (locals, globals'))

let rec exec (env : env) (stmt : Ast.stmt) : env =
  match stmt with
  | Block stmts -> List.fold_left exec env stmts
  | Expr e ->
      let _, env = eval env e in
      env
  | If (e, s1, s2) ->
      let v, env = eval env e in
      exec env (if v != 0 then s1 else s2)
  | While (e, s) ->
      let rec loop env =
        let v, env = eval env e in
        if v != 0 then loop (exec env s) else env
      in
      loop env
  | Return e ->
      let v, (_, globals) = eval env e in
      raise (ReturnException (v, globals))

(* Main entry point: run a program *)
let rec run ((vars, funcs) : program) : unit =
  let globals : vsymtab =
    List.fold_left
      (fun globals (_, name) -> NameMap.add name 0 globals)
      NameMap.empty vars
  in
  try
    (* Build a symbol table for function declarations *)
    let func_decls : func_decl NameMap.t =
      List.fold_left
        (fun funcs fdecl -> NameMap.add fdecl.fname fdecl funcs)
        NameMap.empty funcs
    in
    (* Execute the "main" function; discard final state of globals *)
    ignore (call (NameMap.find "main" func_decls) [] globals)
  with Not_found -> raise (Failure "did not find the main() function")

(* Invoke a function and return an updated global symbol table *)
and call (fdecl : func_decl) (actuals : int list) (globals : vsymtab) : vsymtab
    =
  let locals : vsymtab =
    try
      List.fold_left2
        (fun locals (_, name) actual -> NameMap.add name actual locals)
        NameMap.empty fdecl.formals actuals
    with Invalid_argument _ ->
      raise (Failure ("wrong number of arguments to " ^ fdecl.fname))
  in
  let locals : vsymtab =
    List.fold_left
      (fun locals (_, name) -> NameMap.add name 0 locals)
      locals fdecl.locals
  in
  (* Execute each statement; return updated global symbol table *)
  snd (List.fold_left exec (locals, globals) fdecl.body)
