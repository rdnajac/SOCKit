# Calculator
This is the example from the lecture slides

To compile everything, execute:
```sh
        ocamllex lexer.mll
        ocamlyacc parser.mly
        ocamlc -c parser.mli
        ocamlc -c lexer.ml
        ocamlc -c parser.ml
        ocamlc -c calc.ml
        ocamlc -o calc lexer.cmo parser.cmo calc.cmo
```

