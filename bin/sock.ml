open SOCKlib

let rec loop () =
  let lexbuf = Lexing.from_channel stdin in
  try
    while true do
      let expr = Parser.expr Lexer.token lexbuf in
      (* Parse the input expression *)
      let result = eval_expr expr in
      (* Evaluate the parsed expression *)
      print_endline (string_of_value result);
      (* Print the result *)
      flush stdout (* Ensure output is written out immediately *)
    done
  with
  | Lexer.Eof -> exit 0 (* Exit on EOF *)
  | Some_other_exception ->
      (* Handle other potential exceptions *)
      print_endline "An error occurred.";
      (* Print an error message *)
      loop () (* Optionally, continue the loop *)

let _ = loop ()
