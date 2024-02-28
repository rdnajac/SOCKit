open Parser
let _ =
  let lexbuf = Lexing.from_channel stdin in
  let tokenseq = Parser.program Lexer.token lexbuf in
  print_endline (Ast.string_of_program tokenseq)
