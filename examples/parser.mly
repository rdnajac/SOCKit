(* OCaml Parser Definitions for a Simple Calculator *)

%{ open Ast %} (* Open the Ast module for types *)

(* Token declarations *)
%token PLUS MINUS TIMES DIVIDE EOF
%token <int> LITERAL

(* Operator precedence declarations *)
%left PLUS MINUS
%left TIMES DIVIDE

(* Start symbol and type *)
%start expr
%type <Ast.expr> expr

(* Grammar rules for expressions *)
expr:
  | expr PLUS expr   { Binop ($1, Add, $3) }  (* Addition expression *)
  | expr MINUS expr  { Binop ($1, Sub, $3) }  (* Subtraction expression *)
  | expr TIMES expr  { Binop ($1, Mul, $3) }  (* Multiplication expression *)
  | expr DIVIDE expr { Binop ($1, Div, $3) }  (* Division expression *)
  | LITERAL          { Lit ($1) }             (* Literal integer *)

