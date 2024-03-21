%{ open Ast %}

%token SEMI COMMA
%token LPAREN RPAREN LBRACE RBRACE (* LBRACK RBRACK *)
%token AND OR EQ NEQ LT LEQ GT GEQ NOT
%token PLUS MINUS TIMES DIVIDE MODULO ASSIGN
%token ASSIGN (* PLUSASS MINUSASS TIMESASS DIVIDEASS MODULOASS *)
%token IF ELSE WHILE RETURN
%token INT BOOL (* TRUE FALSE *) VOID
%token <int> LITERAL
%token <bool> BLIT
%token <string> ID
%token EOF

%start program
%type <Ast.program> program

%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN
%left OR
%left AND
%left EQ NEQ
%left LT LEQ GT GEQ
%left PLUS MINUS
%left TIMES DIVIDE MODULO
%right NOT


%%

program:
    decls EOF { $1 }

decls:
  | /* nothing */ { ([], []) }
  | decls vdecl { (fst $1 @ [$2], snd $1) }
  | decls fdecl { (fst $1, snd $1 @ [$2]) }

fdecl:
    typ ID LPAREN formals_opt RPAREN LBRACE vdecl_list stmt_list RBRACE {
        { typ = $1; fname = $2; formals = List.rev $4;
          locals = List.rev $7; body = List.rev $8 } }

formals_opt:
  | /* nothing */ { [] }
  | formal_list { $1 }

formal_list:
    | typ ID { [($1, $2)] }
    | formal_list COMMA typ ID { ($3,$4) :: $1 }

typ: | INT { Int } | BOOL { Bool } | VOID { Void }

vdecl_list:
  | /* nothing */ { [] }
  | vdecl_list vdecl { $2 :: $1 }

vdecl:
    typ ID SEMI { ($1, $2) }

stmt_list:
  | /* nothing */ { [] }
  | stmt_list stmt { $2 :: $1 }

stmt:
  | expr SEMI { Expr $1 }
  | RETURN expr_opt SEMI { Return $2 }
  | LBRACE stmt_list RBRACE { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt { If($3, $5, $7) }
  | WHILE LPAREN expr RPAREN stmt { While($3, $5) }

expr:
  | LITERAL { Lit($1) }
  | BLIT   { Blit($1) }
  | ID     { Id($1) }
  | expr PLUS expr   { Bop($1, Add, $3) }
  | expr MINUS expr  { Bop($1, Sub, $3) }
  | expr TIMES expr  { Bop($1, Mul, $3) }
  | expr DIVIDE expr { Bop($1, Div, $3) }
  | expr MODULO expr { Bop($1, Mod, $3) }
  | expr EQ expr     { Bop($1, Eq, $3) }
  | expr NEQ expr    { Bop($1, Neq, $3) }
  | expr LT expr     { Bop($1, Lt, $3) }
  | expr LEQ expr     { Bop($1, Leq, $3) }
  | expr GT expr     { Bop($1, Gt, $3) }
  | expr GEQ expr     { Bop($1, Geq, $3) }
  | expr AND expr    { Bop($1, And, $3) }
  | expr OR expr     { Bop($1, Or, $3) }
  | MINUS expr %prec NOT { Uop(Neg, $2) }
  | NOT expr         { Uop(Not, $2) }
  | ID ASSIGN expr   { Ass($1, $3) }
  | ID LPAREN args_opt RPAREN { Call($1, $3) }
  | LPAREN expr RPAREN { $2 }

expr_opt:
  | /* nothing */ { Noexpr }
  | expr { $1 }

args_opt:
  | /* nothing */ { [] }
  | args_list { List.rev $1 }

args_list:
    expr { [$1] }
  | args_list COMMA expr { $3 :: $1 }