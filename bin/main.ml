open Hello
open Mylib

type action = Ast | Sast | Llvm | Interpret | Hello | Help

let action = ref Help
let input_file = ref ""

let speclist = [
  ("-a", Arg.Unit (fun () -> action := Ast), "Print the AST");
  ("-s", Arg.Unit (fun () -> action := Sast), "Print the SAST");
  ("-l", Arg.Unit (fun () -> action := Llvm), "Print the LLVM IR");
  ("-i", Arg.Unit (fun () -> action := Interpret), "Interpret the program");
  ("--hello", Arg.Unit (fun () -> action := Hello), "Say Hello");
  ("-h", Arg.Unit (fun () -> action := Help), "Print this help message");
]

let usage_msg = "Usage: sockit [-a|-s|-l|-c|-i|--hello|-h] [<file>]"
let set_file f = input_file := f

let parse_args () =
  Arg.parse speclist set_file usage_msg;
  !action

let process_action action ast =
  match action with
  | Ast -> print_endline (Ast.string_of_program ast)
  | Sast ->
      let sast = Semant.check ast in
      print_endline (Sast.string_of_sprogram sast)
  | Llvm ->
      (*let sast = Semant.check ast in*)
      let llvm_module = Codegen.translate ast in (*TODO sould this be sast?*)
      print_endline (Llvm.string_of_llmodule llvm_module)
  | Interpret -> Interpreter.run ast
  | _ -> ()

let () =
  let selected_action = parse_args () in
  match selected_action with
  | Hello -> say_hello ()
  | Help -> Arg.usage speclist usage_msg
  | _ ->
      if !input_file = "" then failwith "No input file provided";
      let channel = open_in !input_file in
      let lexbuf = Lexing.from_channel channel in
      let ast = Parser.program Scanner.token lexbuf in
      close_in channel;
      process_action selected_action ast

