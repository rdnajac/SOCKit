# Define compiler and flags
OCAMLLEX=ocamllex
OCAMLYACC=ocamlyacc
OCAMLC=ocamlc

# Define source files
LEXER_SRC=lexer.mll
PARSER_SRC=parser.mly
PARSER_INTF=$(PARSER_SRC:.mly=.mli)
LEXER_ML=$(LEXER_SRC:.mll=.ml)
PARSER_ML=$(PARSER_SRC:.mly=.ml)
SOURCES=lexer.ml parser.ml calc.ml

# Define compiled object files
OBJECTS=$(SOURCES:.ml=.cmo)

# Target executable
EXEC=calc

all: $(EXEC)

$(EXEC): $(OBJECTS)
	$(OCAMLC) -o $@ $^

%.cmo: %.ml
	$(OCAMLC) -c $<

%.ml: %.mll
	$(OCAMLLEX) $<

%.ml %.mli: %.mly
	$(OCAMLYACC) $<

%.cmo %.cmi: %.mli
	$(OCAMLC) -c $<

clean:
	rm -f *.cmo *.cmi lexer.ml parser.ml parser.mli $(EXEC)

.PHONY: all clean

