#!/bin/bash
set -euo pipefail

# Helper functions for colored messages
okay() { echo -e "\033[92m$1\033[0m"; }
info() { echo -e "\033[94m$1\033[0m"; }
warn() { echo -e "\033[91m$1\033[0m"; }

# Checks if the necessary commands are installed
assert_installed() {
  if ! command -v "$1" &> /dev/null; then
    warn "$1 is not installed. Please install $1 and try again."
    exit 1
  else
    okay "$1 is installed."
  fi
}

# Function to install and setup LLVM for a given version on macOS
setup_llvm() {
  local version=$1

  if [[ "$OSTYPE" != "darwin"* ]]; then
    warn "This script has only been tested on macOS. Continue? [y/n]: "
    read -n 1 -r reply
    echo
    if [[ $reply =~ ^[Nn]$ ]]; then
      warn "Exiting..."
      exit 1
    fi
  fi

  local llvm_path="/opt/homebrew/opt/llvm@${version}"
  local llvm_bin="$llvm_path/bin"
  local llvm_config="$llvm_bin/llvm-config"

  info "Setting up LLVM $version..."

  # Install LLVM using Homebrew if not already installed
  brew list llvm@"${version}" &>/dev/null || brew install llvm@"${version}"

  # Check if the user wants to add environment variables to .zshrc
  if ! grep -q "llvm@${version}/bin" ~/.zshrc; then
    echo "Do you want to add LLVM $version environment variables to your .zshrc? [y/n]: "
    read -n 1 -r reply
    echo
    if [[ $reply =~ ^[Yy]$ ]]; then
      {
        echo "export PATH=\"$llvm_bin:\$PATH\""
        echo "export LLVM_CONFIG=\"$llvm_config\""
        echo "export PKG_CONFIG_PATH=\"$llvm_path/lib/pkgconfig\""
      } >> ~/.zshrc
      source ~/.zshrc
      okay "Environment variables for LLVM $version added to .zshrc."
    fi
  else
    okay "Environment variables for LLVM $version already set in .zshrc."
  fi

  okay "LLVM $version setup complete."
}

# Ensure required tools are installed
assert_installed ocaml
assert_installed opam
assert_installed dune

# Function to create an OPAM switch and install a specific version of LLVM
create_switch_install_llvm() {
  local switch_name=$1
  local llvm_version=$2

  info "Creating OPAM switch $switch_name..."
  opam switch create "$switch_name" --empty --yes
  eval "$(opam env --switch="$switch_name")"

  info "Installing LLVM $llvm_version in switch $switch_name..."
  opam install llvm."$llvm_version" --yes
}

# Setup LLVM 14 for macOS
setup_llvm 14

# Install dependencies listed in the .opam file
info "Installing dependencies from the .opam file..."
# opam install . --deps-only --yes

# Create a switch and install a specific version of LLVM
create_switch_install_llvm "llvm-14.0.6" "14.0.6"

# Stay in the current switch without switching back to default
eval "$(opam env)"

okay "All dependencies installed successfully."

# Uncomment these to build and test your project
# info "Building the project in the current environment..."
# dune build
# okay "Project built successfully."
# info "Testing the project..."
 dune runtest

