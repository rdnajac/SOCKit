(* called by the main function in main.ml *)
open Symboltable
open Hello
open Argparse
open Corelib.Ast

let rec eval_expr env = function
  | Lit x -> x
  | BinOp (e1, op, e2) -> (
      let v1 = eval_expr env e1 in
      let v2 = eval_expr env e2 in
      match op with
      | Add -> v1 + v2
      | Sub -> v1 - v2
      | Mul -> v1 * v2
      | Div -> v1 / v2
      | Mod -> v1 mod v2)
  | Assign (var, e) ->
      let value = eval_expr env e in
      add_entry env var value;
      value
  | Var var -> (
      match get_value env var with
      | Some v -> v
      | None -> failwith ("Undefined variable: " ^ var))
  | _ -> failwith "Expression type not implemented"

and eval_stmt env = function
  | Expr expr -> eval_expr env expr
  | If (cond, stmt_true, stmt_false_opt) -> (
      let cond_val = eval_expr env cond in
      if cond_val != 0 then eval_stmt env stmt_true
      else
        match stmt_false_opt with
        | Some stmt_false -> eval_stmt env stmt_false
        | None -> 0)

let eval_program { locals; body } =
  let env = init () in
  List.iter
    (fun (typ, name) ->
      match typ with
      | Int -> add_entry env name 0
      | Bool ->
          add_entry env name
            0 (* Placeholder, adjust as needed for boolean values *))
    locals;
  List.iter (fun stmt -> ignore (eval_stmt env stmt)) body

let run () =
  let action, _debug = parse () in
  match action with
  | Some Hello -> say_hello ()
  | Some Repl -> print_endline "Entering REPL mode..."
  | Some Scan -> print_endline "Scanning..."
  | Some (File filename) -> print_endline ("Executing file: " ^ filename)
  | Some Debug -> print_endline "Debug mode enabled."
  | None -> print_endline "No action specified."
