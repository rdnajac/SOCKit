(* command line parsing *)
type action = Hello | Repl | Scan | File of string | Debug

let parse () =
  let action = ref None in
  let filename = ref None in
  let debug = ref false in
  let speclist =
    [
      ( "--hello",
        Arg.Unit (fun () -> action := Some Hello),
        "Print Hello, World!" );
      ("-r", Arg.Unit (fun () -> action := Some Repl), "Run in REPL mode");
      ("--repl", Arg.Unit (fun () -> action := Some Repl), "Run in REPL mode");
      ("-s", Arg.Unit (fun () -> action := Some Scan), "Scan");
      ("--scan", Arg.Unit (fun () -> action := Some Scan), "Scan");
      ( "-f",
        Arg.String
          (fun f ->
            action := Some (File f);
            filename := Some f),
        "<filename> Execute a file" );
      ( "--file",
        Arg.String
          (fun f ->
            action := Some (File f);
            filename := Some f),
        "<filename> Execute a file" );
      ("-d", Arg.Set debug, "Enable debug mode");
      ("--debug", Arg.Set debug, "Enable debug mode");
    ]
  in
  let usage_msg =
    "Usage: sockit [-r|--repl] [-s|--scan] [-f|--file <filename>] [-d|--debug] \
     ..."
  in
  Arg.parse speclist (fun _ -> ()) usage_msg;
  (!action, !debug)
