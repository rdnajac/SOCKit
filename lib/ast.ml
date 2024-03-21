(* ast.ml: abstract syntax tree *)

type typ = Int
type uop = Neg | Not

type bop =
  | Add
  | Sub
  | Mul
  | Div
  | Mod
  | And
  | Or
  | Eq
  | Neq
  | Lt
  | Gt
  | Leq
  | Geq

type bind = typ * string

type expr =
  | Lit of int
  | Id of string
  | Bop of expr * bop * expr
  | Uop of uop * expr
  | Ass of string * expr
  | Call of string * expr list
  | Noexpr

type stmt =
  | Block of stmt list
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | While of expr * stmt

type func_decl = {
  rtyp : typ;
  fname : string;
  formals : bind list;
  locals : bind list;
  body : stmt list;
}

type program = bind list * func_decl list
