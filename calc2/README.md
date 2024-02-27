# A complete example
The all-time favorite from https://v2.ocaml.org/manual/lexyacc.html.

To compile everything, execute:
```sh
        ocamllex lexer.mll       # generates lexer.ml
        ocamlyacc parser.mly     # generates parser.ml and parser.mli
        ocamlc -c parser.mli
        ocamlc -c lexer.ml
        ocamlc -c parser.ml
        ocamlc -c calc.ml
        ocamlc -o calc lexer.cmo parser.cmo calc.cmo
```

Start the calculator with:
```sh
        ./calc
```

The calculator reads expressions from the standard input, evaluates them, and prints the result.
```sh
        1 + 2 * (3 - 4)
```
