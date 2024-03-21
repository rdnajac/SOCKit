open OUnit2
open Mylib
open Interpreter
open Ast

let global_env =
  let empty_locals = NameMap.empty in
  let globals = NameMap.empty in
  (empty_locals, globals)

let test_eval_lit _ =
    assert_equal (42, global_env) (eval global_env (Lit 42))

let test_eval_add _ =
    assert_equal (7, global_env) (eval global_env (Bop (Lit 3, Add, Lit 4)))

let test_eval_sub _ =
    assert_equal (1, global_env) (eval global_env (Bop (Lit 4, Sub, Lit 3)))

let test_eval_mul _ =
    assert_equal (12, global_env) (eval global_env (Bop (Lit 3, Mul, Lit 4)))

let test_eval_div _ =
    assert_equal (2, global_env) (eval global_env (Bop (Lit 4, Div, Lit 2)))

let test_eval_var_assign _ =
    let _, env = eval global_env (Ass ("x", Lit 5)) in
    assert_equal (5, env) (eval env (Id "x"))

let test_eval_undefined_var _ =
    assert_raises (Failure "undeclared identifier y") (fun () -> eval global_env (Id "y"))

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


