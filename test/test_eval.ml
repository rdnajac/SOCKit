open OUnit2
open Mylib


let test_eval_lit _ =
    assert_equal 42 (Sock.eval_expr global_env (Lit 42)

let test_eval_add _ =
    assert_equal 7 (Sock.eval_expr global_env (BinOp (Lit 3, Add, Lit 4)))

let test_eval_sub _ =
    assert_equal 1 (Sock.eval_expr global_env (BinOp (Lit 4, Sub, Lit 3)))

let test_eval_mul _ =
    assert_equal 12 (Sock.eval_expr global_env (BinOp (Lit 3, Mul, Lit 4)))

let test_eval_div _ =
    assert_equal 2 (Sock.eval_expr global_env (BinOp (Lit 4, Div, Lit 2)))

let test_eval_var_assign _ =
    ignore (Sock.eval_expr global_env (Assign ("x", Lit 5)));
    assert_equal 5 (Sock.eval_expr global_env (Var "x"))

let test_eval_undefined_var _ =
    assert_raises (Failure "Undefined variable: y") (fun () -> Sock.eval_expr global_env (Var "y"))

let suite =
    "Eval Tests" >::: [
        "eval_lit" >:: test_eval_lit;
        "eval_add" >:: test_eval_add;
        "eval_sub" >:: test_eval_sub;
        "eval_mul" >:: test_eval_mul;
        "eval_div" >:: test_eval_div;
        "eval_var_assign" >:: test_eval_var_assign;
        "eval_undefined_var" >:: test_eval_undefined_var;
    ]

let () =
    run_test_tt_main suite

