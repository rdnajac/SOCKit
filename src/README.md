### Build the SOCKscanner

```
ocamlbuild SOCK.native
```

### Run the SOCKscanner
```
./SOCK.native
```

### Example
```
./SOCK.native < test1.it
```

### Compiler files
-  `ast.ml`: abstract syntax tree (AST) -- a list of strings for the lexer
-  `lexer.mll`: scanner -- convert the source code into a sequence of tokens
-  `parse.mly`: parser -- parse the sequence of tokens into a list of strings
-  `SOCK.ml`: main file -- the main file to run the SOCKscanner

