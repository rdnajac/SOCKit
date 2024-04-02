open Hello
open Mylib

type action = Ast | Bytecode | Compile | Interpret | Hello | Help

let action = ref Help (* Set default action to Help *)

let speclist =
  [
    ("-a", Arg.Unit (fun () -> action := Ast), "Print the AST");
    ("-b", Arg.Unit (fun () -> action := Bytecode), "Print the Bytecode");
    ("-c", Arg.Unit (fun () -> action := Compile), "Compile the program");
    ("-i", Arg.Unit (fun () -> action := Interpret), "Interpret the program");
    ("--hello", Arg.Unit (fun () -> action := Hello), "Say Hello");
  ]

let usage_msg = "Usage: sockit [-a|-b|-c|-i|--hello] [<file>]"
let input_file = ref ""
let set_file f = input_file := f

let parse_args () =
  Arg.parse speclist set_file usage_msg;
  !action

let read_input_file () =
  if !input_file <> "" then (
    let channel = open_in !input_file in
    let lexbuf = Lexing.from_channel channel in
    let ast = Parser.program Scanner.token lexbuf in
    close_in channel;
    ast)
  else failwith "No input file provided"

let () =
  let action = parse_args () in
  match action with
  | Ast ->
      let ast = read_input_file () in
      print_string (Ast.string_of_program ast)
  | Bytecode -> print_string "Bytecode not implemented yet\n"
  | Compile -> print_string "Compile not implemented yet\n"
  | Interpret ->
      let program = read_input_file () in
      Interpreter.run program
  | Hello -> say_hello ()
  | Help -> Arg.usage speclist usage_msg
