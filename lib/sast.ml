(* semantically-checked abstract syntax tree *)
open Ast

type sexpr = typ * sx

and sx =
  | SLit of int
  | SId of string
  | SBop of sexpr * bop * sexpr
  | SUnop of uop * sexpr
  | SAss of string * sexpr
  | SCall of string * sexpr list
  | SNoexpr

type sstmt =
  | SBlock of sstmt list
  | SExpr of sexpr
  | SIf of sexpr * sstmt * sstmt
  | SWhile of sexpr * sstmt
  | SReturn of sexpr

type sfunc_decl = {
  srtyp : typ;
  sfname : string;
  sformals : bind list;
  slocals : bind list;
  sbody : sstmt list;
}

type sprogram = bind list * sfunc_decl list
