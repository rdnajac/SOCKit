{ open Parser }

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let alphanumeric = alpha | digit | '_'
let whitespace = [' ' '\t' '\r' '\n']

rule token = parse
  | whitespace+                   { token lexbuf }
  | "//"                          { comment_line lexbuf }
  | "/*"                          { comment_block 0 lexbuf }
  | eof                           { EOF }

  (* Operators *)
  | '+'                           { PLUS }
  | '-'                           { MINUS }
  | '*'                           { TIMES }
  | '/'                           { DIVIDE }
  | '%'                           { MODULO }
  | '='                           { ASSIGN }
  | "=="                          { EQ }
  | "!="                          { NEQ }
  | '<'                           { LT }
  | "<="                          { LEQ }
  | '>'                           { GT }
  | ">="                          { GEQ }
  | "&&"                          { AND }
  | "||"                          { OR }
  | '!'                           { NOT }

  (* Punctuation *)
  | '('                           { LPAREN }
  | ')'                           { RPAREN }
  | '{'                           { LBRACE }
  | '}'                           { RBRACE }
  | ';'                           { SEMI }
  | ','                           { COMMA }

  (* Keywords *)
  | "if"                          { IF }
  | "else"                        { ELSE }
  | "while"                       { WHILE }
  | "return"                      { RETURN }
  | "int"                         { INT }
  | "bool"                        { BOOL }

  (* Literals and Identifiers *)
  | digit+ as lxm                 { LITERAL(int_of_string lxm) }
  | alpha (alphanumeric)* as lxm  { ID(lxm) }

  | _ as ch                       { raise (Failure ("illegal character " ^ Char.escaped ch)) }

and comment_block level = parse
  | "*/"                          { if level = 0 then token lexbuf else comment_block (level - 1) lexbuf }
  | "/*"                          { comment_block (level + 1) lexbuf }
  | eof                           { raise (Failure "Unclosed comment at EOF") }
  | _                             { comment_block level lexbuf }

and comment_line = parse
  | '\n' | eof                    { token lexbuf }
  | _                             { comment_line lexbuf }

