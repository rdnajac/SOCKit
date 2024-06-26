open Ast

type sexpr = typ * sx

and sx =
  | SLit of int
  | SId of string
  | SBinop of sexpr * op * sexpr
  | SAssign of string * sexpr
  | SCall of string * sexpr list
  | SNoexpr

type sstmt =
  | SBlock of sstmt list
  | SExpr of sexpr
  | SIf of sexpr * sstmt * sstmt
  | SWhile of sexpr * sstmt
  | SReturn of sexpr

type sfunc_def = {
  srtyp : typ;
  sfname : string;
  sformals : bind list;
  slocals : bind list;
  sbody : sstmt list;
}

type sprogram = bind list * sfunc_def list

(* pretty-printing *)

let rec string_of_sexpr (t, e) =
  "(" ^ string_of_typ t ^ " : "
  ^ (match e with
    | SLit l -> string_of_int l
    | SId s -> s
    | SNoexpr -> ""
    | SBinop (e1, o, e2) ->
        string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
    | SAssign (v, e) -> v ^ " = " ^ string_of_sexpr e
    | SCall (f, el) ->
        f ^ "(" ^ String.concat ", " (List.map string_of_sexpr el) ^ ")")
  ^ ")"

let rec string_of_sstmt = function
  | SBlock stmts ->
      "{\n" ^ String.concat "" (List.map string_of_sstmt stmts) ^ "}\n"
  | SExpr expr -> string_of_sexpr expr ^ ";\n"
  | SReturn expr -> "return " ^ string_of_sexpr expr ^ ";\n"
  | SIf (e, s1, s2) ->
      "if (" ^ string_of_sexpr e ^ ")\n" ^ string_of_sstmt s1 ^ "else\n"
      ^ string_of_sstmt s2
  | SWhile (e, s) -> "while (" ^ string_of_sexpr e ^ ") " ^ string_of_sstmt s

let string_of_sfdecl fdecl =
  string_of_typ fdecl.srtyp ^ " " ^ fdecl.sfname ^ "("
  ^ String.concat ", " (List.map snd fdecl.sformals)
  ^ ")\n{\n"
  ^ String.concat "" (List.map string_of_vdecl fdecl.slocals)
  ^ String.concat "" (List.map string_of_sstmt fdecl.sbody)
  ^ "}\n"

let string_of_sprogram (vars, funcs) =
  "\n\nSementically checked program: \n\n"
  ^ String.concat "" (List.map string_of_vdecl vars)
  ^ "\n"
  ^ String.concat "\n" (List.map string_of_sfdecl funcs)
