open Ast
module NameMap = Map.Make (String)

type vsymtab = int NameMap.t
type env = vsymtab * vsymtab

exception ReturnException of int * vsymtab

let run ((vars, funcs) : program) : unit =
  let func_decls : fdecl NameMap.t =
    List.fold_left
      (fun funcs fdecl -> NameMap.add fdecl.fname fdecl funcs)
      NameMap.empty funcs
  in

  let rec call (fdecl : fdecl) (actuals : int list) (globals : vsymtab) :
      vsymtab =
    let rec eval (env : env) (exp : expr) : int * env =
      match exp with
      | Lit i -> (i, env)
      | Assign (var, e) ->
          let v, env' = eval env e in
          let locals, globals = env' in
          if NameMap.mem var locals then (v, (NameMap.add var v locals, globals))
          else if NameMap.mem var globals then
            (v, (locals, NameMap.add var v globals))
          else raise (Failure ("undeclared identifier " ^ var))
      | Call ("print ", [ e ]) ->
          let v, env' = eval env e in
          print_endline (string_of_int v);
          print_newline ();
          (0, env')
      | Id var ->
          let locals, globals = env in
          if NameMap.mem var locals then (NameMap.find var locals, env)
          else if NameMap.mem var globals then (NameMap.find var globals, env)
          else raise (Failure ("undeclared identifier " ^ var))
      | Binop (e1, op, e2) ->
          let v1, env' = eval env e1 in
          let v2, env'' = eval env' e2 in
          let result =
            match op with
            | Add -> v1 + v2
            | Sub -> v1 - v2
            | Mul -> v1 * v2
            | Div ->
                if v2 = 0 then raise (Failure "zero-division!") else v1 / v2
            | Mod ->
                if v2 = 0 then raise (Failure "zero-division!") else v1 mod v2
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
      | Call (f, actuals) -> (
          let fdecl =
            try NameMap.find f func_decls
            with Not_found -> raise (Failure ("undefined function " ^ f))
          in
          let ractuals, env' =
            List.fold_left
              (fun (actuals, env) actual ->
                let v, env' = eval env actual in
                (v :: actuals, env))
              ([], env) actuals
          in
          let locals, globals = env' in
          try
            let globals = call fdecl (List.rev ractuals) globals in
            (0, (locals, globals))
          with ReturnException (v, globals) -> (v, (locals, globals)))
    in
    let rec exec (env : env) (stmt : stmt) : env =
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
          let v, (locals, globals) = eval env e in
          raise (ReturnException (v, globals))
    in

    let locals : vsymtab =
      try
        List.fold_left2
          (fun acc (ty, name) actual -> NameMap.add name actual acc)
          NameMap.empty fdecl.formals actuals
      with Invalid_argument _ ->
        raise (Failure ("wrong number of arguments to " ^ fdecl.fname))
    in

    let locals : vsymtab =
      List.fold_left
        (fun acc (ty, name) -> NameMap.add name 0 acc)
        locals fdecl.locals
    in

    snd (List.fold_left exec (locals, globals) fdecl.body)
  in

  let globals : vsymtab =
    List.fold_left
      (fun acc (_, name) -> NameMap.add name 0 acc)
      NameMap.empty vars
  in
  try ignore (call (NameMap.find "main" func_decls) [] globals)
  with Not_found -> raise (Failure "did not find the main() function")
