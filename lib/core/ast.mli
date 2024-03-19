type binop = Add | Sub | Mul | Div | Mod
type typ = Int | Bool

type expr =
  | Lit of int
  | BoolLit of bool
  | Var of string
  | BinOp of expr * binop * expr
  | IfExpr of expr * expr * expr option
  | Assign of string * expr

type stmt = Expr of expr | If of expr * stmt * stmt option
type bind = typ * string
type program = { locals : bind list; body : stmt list }
