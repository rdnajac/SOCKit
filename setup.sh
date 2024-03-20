#!/bin/bash

# Function to update shell environment with opam
update_opam_env() {
    eval $(opam env --set-switch)
}

# Function to check if a command is installed
check_installed() {
    command -v "$1" &>/dev/null || { echo "$1 is not installed. Please install $1 and try again."; exit 1; }
}

# Check for OCaml and opam installation
check_installed ocaml
check_installed opam

echo "Setting up opam..."
if ! opam init --auto-setup --yes >/dev/null 2>&1; then
    echo "Failed to initialize opam. Exiting."
    exit 1
fi
update_opam_env

# Check if a local switch exists for this directory
if opam switch show >/dev/null 2>&1; then
    echo "OPAM switch for this directory already exists. Continuing..."
else
    echo "Creating a local OPAM switch with the latest base compiler..."
    if ! opam switch create . --deps-only --yes >/dev/null 2>&1; then
        echo "Failed to create a local OPAM switch. Exiting."
        exit 1
    fi
    update_opam_env
fi

echo "Updating opam and upgrading packages..."
if ! opam update && opam upgrade --yes; then
    echo "Failed to update and upgrade packages."
    exit 1
fi

echo "Installing dependencies from the .opam file..."
if ! opam install . --deps-only --yes >/dev/null 2>&1; then
    echo "Failed to install dependencies from the .opam file."
    exit 1
fi

echo "Dependencies installed successfully."

echo "Building the project..."
if ! dune build >/dev/null 2>&1; then
    echo "Failed to build the project."
    exit 1
fi

echo "Project built successfully."

