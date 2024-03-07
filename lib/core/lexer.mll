(* lexer.mll *)
{
    open Parser
}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let alphanumeric = alpha | digit
let whitespace = [' ' '\t' '\r' '\n']
let id = alpha (alphanumeric | '_')*

rule token = parse
  | eof                     { EOF }
  (* Single and multi-line comments *)
  | "//"                    { comment_line lexbuf }
  | "/*"                    { comment_block 0 lexbuf }  (* Modified for nested comments *)
  | whitespace+             { token lexbuf }
  | digit+ as lxm           { LITERAL(int_of_string lxm) }
  | alpha (alphanumeric | '_')* as lxm { ID(lxm) }

  (* binary operators *)
  | '+'         { ADD }
  | '-'         { SUB }
  | '*'         { MUL }
  | '/'         { DIV }
  | '%'         { MOD }
  | '='         { ASS }

   (* Braces *)
  | '('         { LPAREN }
  | ')'         { RPAREN }

  (* Symbols *)
  | ';'         { SEMI }

  (* Types *)
  | "int"       { INT }
  | "bool"      { BOOL }

and comment_block level = parse
  | "*/"        { if level = 0 then token lexbuf else comment_block (level - 1) lexbuf }
  | "/*"        { comment_block (level + 1) lexbuf }
  | _           { comment_block level lexbuf }

and comment_line = parse
  | '\n' | eof  { token lexbuf }
  | _           { comment_line lexbuf }

{
  (* Trailer: auxiliary OCaml functions *)
}

