(* entry point for running all tests *)
open OUnit2

let () =
  let all_suites = [
    (* add all test suites here *)
    Test_eval.suite;
  ]
  in
  run_test_tt_main ("All tests" >::: all_suites)

