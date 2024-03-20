open Ast
open Sast

module StringMap = Map.Make(String)

(* Some type definitions to clarify signatures *)
type func_symbol = func_decl StringMap.t

(* Semantic checking of the AST. Returns a semantically
checked program (globals, SAST) if successful;
throws an exception if something is wrong. *)

let check (globals, functions) =

    let rec expr = (* ... *) in
        let rec check_stmt = (* ... *)
        (* check_binds, check globals,
build and check function symbol table, check for main *)

        in { styp = func.typ;
            sfname = func.fname;
            sformals = func.formals;
            slocals = func.locals;
            sbody = match check_stmt (Block func.body) with
                SBlock(sl) -> sl
                | _ -> raise (Failure
                    ("internal error: block didn’t become a block?"))
        }

    in (globals, List.map check_function functions)
