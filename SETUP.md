# Prerequisites
## [OCaml](https://ocaml.org/docs/install.html)
```
$ sudo apt-get install ocaml
```
### Unix library
SOCKit uses the Unix library for socket programming.
```
$ sudo apt-get install libunix-ocaml-dev
```

To use the Unix library, compile and link your program with the Unix library.
```
$ ocamlc -o my_program unix.cma my_program.ml
```

For more information, see [Module Unix](https://v2.ocaml.org/api/Unix.html).


## [opam](https://opam.ocaml.org/): OCaml Package Manager
Installation:
```
$ sudo apt-get install opam
```
Using opam:
```
opam list -a         # List the available packages
opam install lwt     # Install LWT
opam update          # Update the package list
...
opam upgrade         # Upgrade the installed packages to their latest version
```

## [Dune](https://dune.readthedocs.io/en/stable/quick-start.html)
We use Dune to build the project. Installation:
```
$ opam install dune
```
> Dune is a composable build system. Each directory contains a `dune` file (note the lack of file extension) specifying how to build the files in that directory, and Dune composes them when building the project.
>source: https://mukulrathi.com/ocaml-tooling-dune/

There are three types different "stanzas" in a `dune` file:
- `executable` for building executables
```dune
(executable
(name main)
<options>
)
```

- `library` for building libraries
```dune
(library
(name lib)
<options>
)
```

- `test` for building tests
```dune
(test
(name foo)
<options>
)

```
### Dune commands
- `dune build` to build the project
- `dune runtest` to run the tests
- `dune exec` to execute the project

### Linting and Formatting with Dune
To add [PPX JS Style](https://github.com/janestreet/ppx_js_style):
```dune
(lint
  (pps ppx_js_style -annotated-ignores -styler -pretty -dated-deprecation)))
```

Run the autoformatter on your OCaml source files using:
```
dune build @fmt
```

To update the source files with the formatted versions, use:
```
dune promote
```

Combine formatting and automatic promotion into one command:
```
dune build @fmt --auto-promote
```

#### Integration into Pre-commit Hooks
To ensure formatted code on commits, add to `.git/hooks/pre-commit`:
```
#!/bin/sh
dune build @fmt --auto-promote
git add $(git diff --cached --name-only --diff-filter=d)
```

Then, set execute permissions:
```
chmod +x .git/hooks/pre-commit
```

This setup automatically formats and includes the changes in your commit.

### Autogeneration of Documentation with [Odoc](https://github.com/ocaml/odoc)

- Execute `dune build @doc` to generate HTML documentation for all public libraries in your project. Find the documentation in `_build/default/_doc/_html/`.

- The `index.html` in the documentation root lists all the opam packages for the public libraries, with links to individual module documentation.

- Use comments in `.mli` files to generate documentation. For example, for module `Foo`, annotate functions or types with `(** *)`.

### Bonus: IDE Integration with Merlin

- Dune also generates `.merlin` files, enabling Merlin to provide IDE features such as autocompletion.


### When in doubt
Read the docs: https://dune.readthedocs.io/en/stable/

---

## [odoc](https://ocaml.github.io/odoc/)
Odoc is a documentation generator for OCaml. It reads `.cmt` files and generates HTML documentation.

Installation:
```
$ opam install odoc
```

