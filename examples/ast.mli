(* Abstract Syntax Tree (AST) Definitions for a Simple Calculator *)

type operator = Add | Sub | Mul | Div (* Define types of operators *)

type expr =
  | Binop of expr * operator * expr (* Binary operation: expression, operator, expression *)
  | Lit of int                      (* Literal integer value *)

