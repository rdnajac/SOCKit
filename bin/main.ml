let main () =
  let args = Array.to_list Sys.argv in
  match args with
  (*| [_; filename] -> File.execute filename*)
  (*| _ -> Repl.loop ()*)
  | [_; "hello"] -> Hello.say_hello ()
  | _ -> print_endline "Usage: sockit..."

let () = main ()
