(* OCaml Interpreter for a Simple Calculator *)

open Ast (* Use the AST module for expression types *)

(* Recursive function to evaluate expressions *)
let rec eval = function
  | Lit(x) -> x                             (* Return the literal value *)
  | Binop(e1, op, e2) ->                    (* Evaluate binary operations *)
      let v1 = eval e1 and v2 = eval e2 in  (* Recursively evaluate each expression *)
      match op with             (* Apply the operation to the evaluated expressions *)
      | Add -> v1 + v2
      | Sub -> v1 - v2
      | Mul -> v1 * v2
      | Div -> v1 / v2

let _ =
  let lexbuf = Lexing.from_channel stdin in         (* Create a lexer buffer from standard input *)
  let expr = Parser.expr Scanner.token lexbuf in    (* Parse the input expression *)
  let result = eval expr in                         (* Evaluate the parsed expression *)
  print_endline (string_of_int result)              (* Print the result *)

