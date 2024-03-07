# Makefile used in development environment.
# This file will be deleted.
OCAMLC = ocamlc
OCAMLLEX = ocamllex
OCAMLYACC = ocamlyacc

all: ast parser lexer

ast:
	$(OCAMLC) -c ast.mli

parser: ast
	$(OCAMLYACC) parser.mly
	$(OCAMLC) -c parser.mli
	$(OCAMLC) -c parser.ml

lexer: parser
	$(OCAMLLEX) lexer.mll
	$(OCAMLC) -c lexer.ml

clean:
	rm -f *.cmi *.cmo lexer.ml parser.ml parser.mli parser.output

