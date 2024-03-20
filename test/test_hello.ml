let test_hello _ =
  Hello.say_hello ();
  print_endline "Testing...";

let hello_suite = "Hello Tests" >::: [
  "hello" >:: test_hello;
]


let () =
  run_test_tt_main hello_suite

