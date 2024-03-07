open Hello

let test_hello () =
  print_endline "Testing Hello...";
  say_hello ();
  print_endline "Hello test expected to be printed above."

let () = test_hello ()

