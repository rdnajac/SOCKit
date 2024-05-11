open Ast
open Sast
module StringMap = Map.Make (String)

let check (globals, functions) =
  let check_binds (kind : string) (binds : bind list) =
    List.fold_left
      (fun acc (ty, name) ->
        if List.mem name (List.map snd acc) then
          raise (Failure ("duplicate " ^ kind ^ " " ^ name))
        else if ty = Void then
          raise (Failure (kind ^ " " ^ name ^ " cannot be of type Void"))
        else (ty, name) :: acc)
      [] (List.rev binds)
  in

  let _ = check_binds "global" globals in

  let built_in_decls =
    [
      {
        rtyp = Void;
        fname = "print";
        formals = [ (Int, "x") ];
        locals = [];
        body = [];
      };
    ]
  in
  let built_in_names = List.map (fun fd -> fd.fname) built_in_decls in

  let add_func map fd =
    if List.mem fd.fname built_in_names then
      raise
        (Failure
           ("function " ^ fd.fname ^ " may not be defined as it is a built-in"))
    else if StringMap.mem fd.fname map then
      raise (Failure ("duplicate function definition: " ^ fd.fname))
    else StringMap.add fd.fname fd map
  in

  let function_decls =
    List.fold_left add_func StringMap.empty (built_in_decls @ functions)
  in

  let find_func s = StringMap.find s function_decls in

  let _ = find_func "main" in

  let check_function func =
    let _ = check_binds "formal" func.formals in
    let _ = check_binds "local" func.locals in

    let check_assign lvaluet rvaluet err =
      if lvaluet = rvaluet then lvaluet else raise (Failure err)
    in

    let symbols =
      List.fold_left
        (fun m (ty, name) -> StringMap.add name ty m)
        StringMap.empty
        (globals @ func.formals @ func.locals)
    in

    let type_of_identifier s =
      try StringMap.find s symbols
      with Not_found -> raise (Failure ("undeclared identifier " ^ s))
    in

    let rec check_expr : expr -> sexpr = function
      | Lit l -> (Int, SLit l)
      | Blit l -> (Bool, SBlit l)
      | Id var -> (type_of_identifier var, SId var)
      | Assign (var, e) as ex ->
          let lt = type_of_identifier var and rt, e' = check_expr e in
          let err =
            "illegal assignment " ^ string_of_typ lt ^ " = " ^ string_of_typ rt
            ^ " in " ^ string_of_expr ex
          in
          (check_assign lt rt err, SAssign (var, (rt, e')))
      | Binop (e1, op, e2) as e ->
          let t1, e1' = check_expr e1 and t2, e2' = check_expr e2 in
          let err =
            "illegal binary operator " ^ string_of_typ t1 ^ " "
            ^ string_of_op op ^ " " ^ string_of_typ t2 ^ " in "
            ^ string_of_expr e
          in
          if t1 = t2 then
            let t =
              match op with
              | (Add | Sub) when t1 = Int -> Int
              | Eq | Neq -> Bool
              | Le when t1 = Int -> Bool
              | (And | Or) when t1 = Bool -> Bool
              | _ -> raise (Failure err)
            in
            (t, SBinop ((t1, e1'), op, (t2, e2')))
          else raise (Failure err)
      | Call (fname, args) as call ->
          let fd = find_func fname in
          let param_length = List.length fd.formals in
          if List.length args != param_length then
            raise
              (Failure
                 ("expecting " ^ string_of_int param_length ^ " arguments in "
                ^ string_of_expr call))
          else
            let check_call (ft, _) e =
              let et, e' = check_expr e in
              let err =
                "illegal argument found " ^ string_of_typ et ^ " expected "
                ^ string_of_typ ft ^ " in " ^ string_of_expr e
              in
              (check_assign ft et err, e')
            in
            let args' = List.map2 check_call fd.formals args in
            (fd.rtyp, SCall (fname, args'))
    in

    let check_bool_expr e =
      let t, e' = check_expr e in
      match t with
      | Bool -> (t, e')
      | _ ->
          raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
    in

    let rec check_stmt_list = function
      | [] -> []
      | Block sl :: sl' -> check_stmt_list (sl @ sl') (* Flatten blocks *)
      | s :: sl -> check_stmt s :: check_stmt_list sl
    (* Return a semantically-checked statement i.e. containing sexprs *)
    and check_stmt = function
      (* A block is correct if each statement is correct and nothing
         follows any Return statement.  Nested blocks are flattened. *)
      | Block sl -> SBlock (check_stmt_list sl)
      | Expr e -> SExpr (check_expr e)
      | If (e, st1, st2) ->
          SIf (check_bool_expr e, check_stmt st1, check_stmt st2)
      | While (e, st) -> SWhile (check_bool_expr e, check_stmt st)
      | Return e ->
          let t, e' = check_expr e in
          if t = func.rtyp then SReturn (t, e')
          else
            raise
              (Failure
                 ("return gives " ^ string_of_typ t ^ " expected "
                ^ string_of_typ func.rtyp ^ " in " ^ string_of_expr e))
    in
    {
      srtyp = func.rtyp;
      sfname = func.fname;
      sformals = func.formals;
      slocals = func.locals;
      sbody = check_stmt_list func.body;
    }
  in
  (globals, List.map check_function functions)
