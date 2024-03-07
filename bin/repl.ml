(* repl.ml *)
open SOCKlib

let rec loop () =
  print_string "> ";
  flush stdout;
  let lexbuf = Lexing.from_string (read_line ()) in
  try
    let parsed_program = Parser.program Lexer.token lexbuf in
    print_endline (Tmp.string_of_program parsed_program);
    loop ()
  with
  | Lexer.Eof -> ()
  | e ->
    print_endline ("Error: " ^ Printexc.to_string e);
    loop ()

