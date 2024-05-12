#!/bin/bash
set -euo pipefail

# Helper functions for colored messages
okay() { echo -e "\033[92m$1\033[0m"; }
info() { echo -e "\033[94m$1\033[0m"; }
warn() { echo -e "\033[91m$1\033[0m"; }

assert_installed() {
  if ! command -v "$1" &> /dev/null; then
    warn "$1 is not installed. Please install $1 and try again."
    exit 1
  else
    okay "$1 is installed."
  fi
}

# Ensure required tools are installed
assert_installed ocaml
assert_installed opam
assert_installed dune

# Function to create an OPAM switch and install LLVM
create_switch_install_llvm() {
  local switch_name=$1
  local llvm_version=$2

  info "Creating OPAM switch $switch_name..."
  opam switch create "$switch_name" --empty --yes
  eval "$(opam env --switch="$switch_name")"

  info "Installing LLVM $llvm_version in switch $switch_name..."
  opam install llvm."$llvm_version" --yes
}

# Install dependencies listed in the .opam file
info "Installing dependencies from the .opam file..."
# opam install . --deps-only --yes

# Create switch and install specific version of LLVM
create_switch_install_llvm "llvm-14.0.6" "14.0.6"
# create_switch_install_llvm "llvm-16.0.6+nnp" "16.0.6+nnp"
# create_switch_install_llvm "llvm-15.0.7+nnp-2" "15.0.7+nnp-2"

# Uncomment these lines when testing is ready
# info "Building the project in the default environment..."
# dune build
# okay "Project built successfully."
# info "Testing the project..."
# dune runtest
