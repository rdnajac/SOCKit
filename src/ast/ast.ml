type op =
  | Add
  | Sub
  | Mul
  | Div
  | Mod
  | Eq
  | Neq
  | And
  | Or
  | Lt
  | Gt
  | Le
  | Ge

type typ = Int | Void
type bind = typ * string

type expr =
  | Id of string
  | Lit of int
  | Binop of expr * op * expr
  | Assign of string * expr
  | Call of string * expr list

type stmt =
  | Block of stmt list
  | Expr of expr
  | If of expr * stmt * stmt
  | While of expr * stmt
  | Return of expr

type fdecl = {
  rtyp : typ;
  fname : string;
  formals : bind list;
  locals : bind list;
  body : stmt list;
}

type program = bind list * fdecl list

(* pretty-printing *)

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

let name_of_op = function
  | Add -> "ADD"
  | Sub -> "SUB"
  | Mul -> "MUL"
  | Div -> "DIV"
  | Mod -> "MOD"
  | Eq -> "EQ"
  | Neq -> "NEQ"
  | And -> "AND"
  | Or -> "OR"
  | Lt -> "LT"
  | Gt -> "GT"
  | Le -> "LE"
  | Ge -> "GE"

let rec string_of_expr = function
  | Id s -> s
  | Lit l -> string_of_int l
  | Binop (e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
      (* string_of_expr e1 ^ " " ^ name_of_op o ^ " " ^ string_of_expr e2 *)
  | Assign (v, e) -> v ^ " = " ^ string_of_expr e
  | Call (f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"

let string_of_typ = function Int -> "int" | Void -> "void"
let string_of_bind (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let rec string_of_stmt = function
  | Block stmts ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr expr -> string_of_expr expr ^ ";\n"
  | Return expr -> "return " ^ string_of_expr expr ^ ";\n"
  | If (e, s1, s2) ->
      "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s1 ^ "else\n"
      ^ string_of_stmt s2
  | While (e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

(* let string_of_vdecl vdecl = string_of_bind vdecl *)
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
