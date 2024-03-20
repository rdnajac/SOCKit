open Ast

let string_of_bop = function
  | Add -> "+" | Sub -> "-" | Mul -> "*" | Div -> "/" | Mod -> "%"
  | And -> "&&" | Or -> "||" | Lt -> "<" | Gt -> ">"
  | Leq -> "<=" | Geq -> ">=" | Eq -> "==" | Neq -> "!="

let string_of_uop = function | Neg -> "-" | Not -> "!"

let string_of_typ = function | Int -> "int" | Bool -> "bool" | Void -> "void"

let rec string_of_expr = function
  | Lit l -> string_of_int l
  | Blit b -> string_of_bool b
  | Id s -> s
  | Bop (e1, o, e2) -> "(" ^ string_of_expr e1 ^ " " ^ string_of_bop o ^ " " ^ string_of_expr e2 ^ ")"
  | Uop (o, e) -> string_of_uop o ^ string_of_expr e
  | Ass (s, e) -> s ^ " = " ^ string_of_expr e
  | Call (f, el) -> f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Noexpr -> ""

let rec string_of_stmt = function
  | Block stmts -> "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr expr -> string_of_expr expr ^ ";\n"
  | Return expr -> "return " ^ string_of_expr expr ^ ";\n"
  | If (e, s1, s2) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | For (e1, e2, e3, s) -> "for (" ^ string_of_expr e1 ^ "; " ^ string_of_expr e2 ^ "; " ^ string_of_expr e3 ^ ") " ^ string_of_stmt s
  | While (e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

let string_of_fdecl fdecl =
  string_of_typ fdecl.typ ^ " " ^ fdecl.fname ^ "(" ^
  String.concat ", " (List.map (fun (t, n) -> string_of_typ t ^ " " ^ n) fdecl.formals) ^
  ")\n" ^ string_of_stmt (Block fdecl.body)

let string_of_program (vars, funcs) =
  "Variables:\n" ^ String.concat "" (List.map (fun (t, n) -> string_of_typ t ^ " " ^ n ^ ";\n") vars) ^
  "\nFunctions:\n" ^ String.concat "\n\n" (List.map string_of_fdecl funcs)
