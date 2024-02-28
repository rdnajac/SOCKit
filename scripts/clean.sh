#!/bin/bash
# Remove OCaml object files and interface files
rm -f *.cmi *.cmo

# Remove generated lexer and parser ML files if you want to regenerate them from .mll and .mly
rm -f lexer.ml parser.ml
rm -f lexer.mli parser.mli eval.mli
rm -f calc



# Any other generated files you want to clean up can be added here

echo "Build artifacts removed."

