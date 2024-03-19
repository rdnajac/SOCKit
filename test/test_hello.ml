open Hello

let test_hello () =
  print_endline "Testing...";
  say_hello ();
  print_endline "OK!"

let () = test_hello ()
