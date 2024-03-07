(* file.ml *)
open SOCKlib

let execute_file filename =
  let in_channel = open_in filename in
  let lexbuf = Lexing.from_channel in_channel in
  try
    let parsed_program = Parser.program Lexer.token lexbuf in
    print_endline (Tmp.string_of_program parsed_program);
    close_in in_channel
  with e ->
    close_in_noerr in_channel;
    raise e

