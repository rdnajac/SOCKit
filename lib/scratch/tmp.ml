module StringMap = Map.Make(String)

type symbol_table = {
  variables : ty StringMap.t;  (* Variables bound in current block *)
  parent : symbol_table option;  (* Enclosing scope *)
}

let rec find_variable (scope : symbol_table) name =
  try
    (* Try to find the binding in the nearest block *)
    StringMap.find name scope.variables
  with Not_found ->
    (* Try looking in outer blocks *)
    match scope.parent with
    | Some(parent) -> find_variable parent name
    | _ -> raise Not_found


type translation_environment = {
  scope : symbol_table;  (* Symbol table for vars *)
  return_type : ty option;  (* Function's return type *)
  labels : string list;  (* Labels on statements *)
}

