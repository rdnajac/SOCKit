(lang dune 3.13)

(name sock)

(generate_opam_files true)

(authors
  "Quentin Autry"
  "Hakim El Ghazi"
  "Ryan Najac"
  "Misha Smirnov"
  "Stacey Yao"
  )

(maintainers
  "Ryan Najac"
  )

(license LICENSE)

(package
  (name sock)
  (synopsis "Socket Oriented Concurrency Kit")
  (description "PLT Spring 2024 Team Programming Project")
  (documentation https://url/to/documentation)
  (depends ocaml dune ocamllex ocamlyacc)
  (source
    (github rdnajac/SOCKit))
  (tags
    (topics "to describe" your project)))
  (bug_reports https://github.com/rdnajac/SOCKit/issues)

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
