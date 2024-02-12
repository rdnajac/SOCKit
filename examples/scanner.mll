(* OCaml Lexer Definitions for a Simple Calculator *)

{ open Parser } (* Open the Parser module to connect lexer and parser *)

(* Lexer rules definition *)
rule token = parse
    [ ' ' '\t' '\r' '\n' ] { token lexbuf }     (* Skip whitespace *)
        | '+'                     { PLUS }
        | '-'                     { MINUS }
        | '*'                     { TIMES }
        | '/'                     { DIVIDE }
        | ['0'-'9']+ as lit       { LITERAL (int_of_string lit) }
        | eof                     { EOF }       (* Match end of file and return EOF token *)

