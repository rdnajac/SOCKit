open SOCKlib

let _ =
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      let result = Parser.main Lexer.token lexbuf in
      (* Use main instead of expr *)
      let evaluated = eval_expr result in
      (* Make sure Eval.eval_expr matches your evaluation function *)
      match evaluated with
      | IntVal i ->
          print_int i;
          print_newline ()
      | BoolVal b ->
          print_string (if b then "true" else "false");
          print_newline ()
    done
  with Lexer.Eof ->
    (* Ensure Lexer.Eof matches the actual EOF exception in your lexer *)
    exit 0
