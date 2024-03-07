%{
open Ast
%}

%token <int> LITERAL
%token <string> ID
%token ADD SUB MUL DIV MOD ASS
%token LPAREN RPAREN SEMI
%token EOF
%token INT BOOL

%left ADD SUB
%left MUL DIV MOD
%right ASS

%start program
%type <Ast.program> program

%%

program:
  | declarations statements EOF { { locals = $1; body = $2 } }

declarations:
  | /* empty */ { [] }
  | decl declarations { $1 :: $2 }

decl:
  | INT ID SEMI { (Int, $2) }
  | BOOL ID SEMI { (Bool, $2) }

statements:
  | /* empty */ { [] }
  | statement statements { $1 :: $2 }

statement:
  | expr SEMI { Expr $1 }

expr:
  | LITERAL { Literal $1 }
  | ID { Var $1 }
  | expr ADD expr { BinOp($1, Add, $3) }
  | expr SUB expr { BinOp($1, Sub, $3) }
  | expr MUL expr { BinOp($1, Mul, $3) }
  | expr DIV expr { BinOp($1, Div, $3) }
  | expr MOD expr { BinOp($1, Mod, $3) }
  | ID ASS expr { Assign($1, $3) }
  | LPAREN expr RPAREN { $2 }

