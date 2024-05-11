#!/bin/bash
set -euo pipefail

# Helper functions for colored messages
okay() { echo -e "\033[92m$1\033[0m"; }
info() { echo -e "\033[94m$1\033[0m"; }
warn() { echo -e "\033[91m$1\033[0m"; }
bail() { warn "${1}"; exit "${2:-1}"; }

# update_opam_env() { eval "$(opam env --set-switch)"; }
update_opam_env() { eval "$(opam env)" && eval  "$(opam env --set-switch)"; }

assert_installed() {
  if command -v "$1" > /dev/null; then
    okay "$1 is installed."
  else
    bail "$1 is not installed. Please install $1 and try again."
  fi
}

# Requirements
assert_installed ocaml
assert_installed opam

info "Setting up opam..."
opam init --auto-setup --yes > /dev/null 2>&1 || bail "Failed to initialize opam."
update_opam_env

# Check and set up OPAM switch
if opam switch show > /dev/null 2>&1; then
    okay "OPAM switch for this directory already exists."
else
    info "Creating a local OPAM switch with the latest base compiler..."
    opam switch create . --deps-only --yes > /dev/null 2>&1 || bail "Failed to create a local OPAM switch."
    update_opam_env
fi

info "Updating opam and upgrading packages..."
yes | opam update || true
yes | opam upgrade || true

info "Installing dependencies from the .opam file..."
opam install . --deps-only --yes > /dev/null 2>&1 || bail "Failed to install dependencies."

okay "Dependencies installed successfully."

info "Building the project..."
dune build

#okay "Project built successfully."
# info "Testing the project..."
# dune runtest
