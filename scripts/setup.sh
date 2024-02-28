#!/bin/bash
# Ensure ocaml is installed and up to date
opam update
opam upgrade

# Install the required packages
opam install -y ocamlyacc ocamllex
opam install -y unix
opam install -y core
opam install -y dune

