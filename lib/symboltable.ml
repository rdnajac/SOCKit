(* track variables by mapping integer values to string names *)
type t = (string, int) Hashtbl.t

let init () : t = Hashtbl.create 8

let add_entry (table : t) (name : string) (value : int) : unit =
  Hashtbl.replace table name value

let get_value (table : t) (name : string) : int option =
  try Some (Hashtbl.find table name) with Not_found -> None
