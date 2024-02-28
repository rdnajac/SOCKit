(lang dune 3.13)

(name SOCK)

(generate_opam_files true)

(authors
  "Quentin Autry"
  "Quinn Booth"
  "Hakim El Ghazi"
  "Ryan Najac"
  "Misha Smirnov"
  "Stacey Yao"
  )

(maintainers
  "Quentin Autry"
  "Quinn Booth"
  "Hakim El Ghazi"
  "Ryan Najac"
  "Misha Smirnov"
  "Stacey Yao"
  )

(license LICENSE)

(package
  (name SOCK)
  (synopsis "Socket Oriented Concurrency Kit")
  (description "PLT Spring 2024 Team Programming Project")
  (documentation https://url/to/documentation)
  (depends ocaml dune)
  (source
    (github rdnajac/SOCKit))
  (tags
    (topics "to describe" your project)))
  (bug_reports https://github.com/rdnajac/SOCKit/issues)

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
