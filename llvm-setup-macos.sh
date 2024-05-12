#!/bin/bash
set -euo pipefail

# Helper functions for colored messages
okay() { echo -e "\033[92m$1\033[0m"; }
info() { echo -e "\033[94m$1\033[0m"; }
warn() { echo -e "\033[91m$1\033[0m"; }

# Function to install and setup LLVM for a given version
setup_llvm() {
  local version=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
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
  else
    warn "This script is intended for macOS."
  fi
}

# Prompt user to enter a valid LLVM version
# echo "Enter the LLVM version to setup (14, 15, or 16):"
# read -r version
# if [[ "$version" =~ ^(14|15|16)$ ]]; then
#   setup_llvm "$version"
# else
#   warn "Invalid version entered. Please enter one of 14, 15, or 16."
# fi

# Setup LLVM 14
setup_llvm 14

