(* Placeholder function definitions *)
let repl_loop () = print_endline "Starting REPL loop..."
let execute_file filename = Printf.printf "Executing file: %s\n" filename
let scan () = print_endline "Scanning..."

let () =
    let action = ref None in
    let filename = ref None in
    let speclist = [
        ("--hello", Arg.Unit (fun () -> action := Some `Hello), "Print Hello, World!");
        ("-r",      Arg.Unit (fun () -> action := Some `Repl), "Run in REPL mode");
        ("--repl",  Arg.Unit (fun () -> action := Some `Repl), "Run in REPL mode");
        ("-s",      Arg.Unit (fun () -> action := Some `Scan), "Scan");
        ("--scan",  Arg.Unit (fun () -> action := Some `Scan), "Scan");
        ("-f",      Arg.String (fun f -> action := Some `File; filename := Some f), "<filename> Execute a file");
        ("--file",  Arg.String (fun f -> action := Some `File; filename := Some f), "<filename> Execute a file");
    ] in
    let usage_msg = "Usage: sockit [-r|--repl] [-s|--scan] [-f|--file <filename>] ..." in
    Arg.parse speclist (fun _ -> ()) usage_msg;

    match !action with
    | Some `Hello -> print_endline "Hello, World!"
    | Some `Repl -> repl_loop ()
    | Some `Scan -> scan ()
    | Some `File ->
        begin match !filename with
            | Some f -> execute_file f
            | None -> print_endline "Filename not provided for file execution."
            end
    | None ->
        print_endline "No option selected. Running default action.";
        print_endline usage_msg

