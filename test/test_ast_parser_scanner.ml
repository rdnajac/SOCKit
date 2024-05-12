(* open Ast *)
(* open Parser *)
(* open Scanner *)
open Mylib

(* Function to create a lexbuf from a string *)
let lexbuf_from_string str =
  Lexing.from_string str

(* Function to parse input and print the AST *)
let parse_and_print str =
  let lexbuf = lexbuf_from_string str in
  try
    let result = Parser.program Scanner.token lexbuf in
    print_endline (Ast.string_of_program result)
  with
  (* general parsing error *)
  | error ->
    print_endline (Printexc.to_string error)

(* Define test cases *)
let test_cases = [
  "int x = 5;";
  "x = x + 1;";
  "if (x > 0) { x = x - 1; } else { x = x + 1; }";
  "while (x < 10) { x = x + 1; }";
  "int main() { return x; }";
  "void foo(int y) { while (y > 0) { y = y - 1; } }";
]

(* Run all test cases *)
let () =
  List.iter (fun case ->
    print_string "Testing: ";
    print_endline case;
    parse_and_print case;
    print_newline ()
  ) test_cases
