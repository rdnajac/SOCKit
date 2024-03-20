open Mylib
open Hello

type action = Ast | Bytecode | Compile | Help | Interpret | Hello

let action = ref None

let speclist = [
  ("-a", Arg.Unit (fun () -> action := Some Ast), "Print the AST");
  ("-b", Arg.Unit (fun () -> action := Some Bytecode), "Print the Bytecode");
  ("-c", Arg.Unit (fun () -> action := Some Compile), "Compile the program (default)");
  ("-h", Arg.Unit (fun () -> action := Some Help), "Print this help");
  ("-i", Arg.Unit (fun () -> action := Some Interpret), "Interpret the program");
  ("--hello", Arg.Unit (fun () -> action := Some Hello), "Say Hello");
]

let usage_msg = "Usage: sockit [-a|-b|-c|-h|-i|--hello] [<file>]"

let input_file = ref ""

let set_file f = input_file := f

let parse_args () =
  Arg.parse speclist set_file usage_msg;
  match !action with
  | Some a -> a
  | None -> failwith "No action provided"

let read_input_file () =
  if !input_file <> "" then
    let channel = open_in !input_file in
    let lexbuf = Lexing.from_channel channel in
    let ast = Parser.program Lexer.token lexbuf in
    ast
  else failwith "No input file provided"

let () =
  let action = parse_args () in
  match action with
  | Ast ->
    let ast = read_input_file () in
    print_string (Prettyprinter.string_of_program ast)
  | Bytecode -> print_string "Bytecode not implemented yet\n"
  | Compile -> print_string "Compile not implemented yet\n"
  | Help -> Arg.usage speclist usage_msg; exit 0
  | Interpret -> let program = read_input_file () in Interpreter.run program
  | Hello -> say_hello ()

