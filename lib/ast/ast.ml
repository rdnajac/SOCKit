(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Mul | Div | Mod | Eq | Neq | And | Or | Lt | Gt | Le | Ge

(* type of expression *)
type typ = Int | Bool | Void

type expr =
  | Lit of int
  | Blit of bool
  | Id of string
  | Binop of expr * op * expr
  | Assign of string * expr
  | Call of string * expr list
  | Noexpr

type stmt =
  | Block of stmt list
  | Expr of expr
  | If of expr * stmt * stmt
  | While of expr * stmt
  | Return of expr

(* int x: name binding *)
type bind = typ * string

(* func_def: ret_typ fname formals locals body *)
type func_def = {
  rtyp : typ;
  fname : string;
  formals : bind list;
  locals : bind list;
  body : stmt list;
}

type program = bind list * func_def list

(* Pretty-printing functions *)
let string_of_op = function
  | Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Eq -> "=="
  | Neq -> "!="
  | And -> "&&"
  | Or -> "||"
  | Lt -> "<"
  | Gt -> ">"
  | Le -> "<="
  | Ge -> ">="

let rec string_of_expr = function
  | Lit l -> string_of_int l
  | Blit true -> "true"
  | Blit false -> "false"
  | Id s -> s
  | Binop (e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Assign (v, e) -> v ^ " = " ^ string_of_expr e
  | Call (f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Noexpr -> ""

let rec string_of_stmt = function
  | Block stmts ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr expr -> string_of_expr expr ^ ";\n"
  | Return expr -> "return " ^ string_of_expr expr ^ ";\n"
  | If (e, s1, s2) ->
      "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s1 ^ "else\n"
      ^ string_of_stmt s2
  | While (e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

let string_of_typ = function Int -> "int" | Bool -> "bool" | Void -> "void"
let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^ fdecl.fname ^ "("
  ^ String.concat ", " (List.map snd fdecl.formals)
  ^ ")\n{\n"
  ^ String.concat "" (List.map string_of_vdecl fdecl.locals)
  ^ String.concat "" (List.map string_of_stmt fdecl.body)
  ^ "}\n"

let string_of_program (vars, funcs) =
  "\n\nParsed program: \n\n"
  ^ String.concat "" (List.map string_of_vdecl vars)
  ^ "\n"
  ^ String.concat "\n" (List.map string_of_fdecl funcs)