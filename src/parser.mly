%{ open Ast %}

%token LPAREN RPAREN LBRACE RBRACE
%token PLUS MINUS TIMES DIVIDE MODULUS ASSIGN
%token EQ NEQ LT GT LE GE AND OR
%token IF ELSE WHILE INT VOID
%token SEMI RETURN COMMA
%token <int> LITERAL
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
%left LT GT LE GE
%left PLUS MINUS
%left TIMES DIVIDE MODULUS

%%

program:
  decls EOF { $1}

decls:
   /* nothing */ { ([], []) }
 | vdecl SEMI decls { (($1 :: fst $3), snd $3) }
 | fdecl decls { (fst $2, ($1 :: snd $2)) }

vdecl_list:
  /*nothing*/ { [] }
  | vdecl SEMI vdecl_list  {  $1 :: $3 }

vdecl:
  typ ID { ($1, $2) }

typ:
    INT   { Int  }
  | VOID  { Void }

fdecl:
  vdecl LPAREN formals_opt RPAREN LBRACE vdecl_list stmt_list RBRACE
  {
    {
      rtyp=fst $1;
      fname=snd $1;
      formals=$3;
      locals=$6;
      body=$7
    }
  }

formals_opt:
  /*nothing*/ { [] }
  | formals_list { $1 }

formals_list:
  vdecl { [$1] }
  | vdecl COMMA formals_list { $1::$3 }

stmt_list:
  /* nothing */ { [] }
  | stmt stmt_list  { $1::$2 }

stmt:
    expr SEMI                               { Expr $1}
  | LBRACE stmt_list RBRACE                 { Block $2 }
  /* if (condition) { block1} else {block2} */
  /* if (condition) stmt else stmt */
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
  | WHILE LPAREN expr RPAREN stmt           { While ($3, $5) }
  /* return */
  | RETURN expr SEMI                        { Return $2 }

expr:
    LITERAL          { Lit($1) }
  | ID               { Id($1) }
  | expr PLUS    expr { Binop($1, Add, $3) }
  | expr MINUS   expr { Binop($1, Sub, $3) }
  | expr TIMES   expr { Binop($1, Mul, $3) }
  | expr DIVIDE  expr { Binop($1, Div, $3) }
  | expr MODULUS expr { Binop($1, Mod, $3) }
  | expr EQ      expr { Binop($1, Eq,  $3) }
  | expr NEQ     expr { Binop($1, Neq, $3) }
  | expr LT      expr { Binop($1, Lt,  $3) }
  | expr GT      expr { Binop($1, Gt,  $3) }
  | expr LE      expr { Binop($1, Le,  $3) }
  | expr GE      expr { Binop($1, Ge,  $3) }
  | expr AND     expr { Binop($1, And, $3) }
  | expr OR      expr { Binop($1, Or,  $3) }
  | ID ASSIGN    expr { Assign($1,     $3) }
  | LPAREN expr RPAREN { $2 }
  /* call */
  | ID LPAREN args_opt RPAREN { Call ($1, $3)  }

/* args_opt*/
args_opt:
  /*nothing*/ { [] }
  | args { $1 }

args:
  expr  { [$1] }
  | expr COMMA args { $1::$3 }
