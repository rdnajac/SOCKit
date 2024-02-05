# langnamehere

name (position)...

## 1 Motivation


## 2 Language Paradigms and Features

| Paradigm    | Type System                 | Scoping            | Evaluation Order |
|-------------|-----------------------------|--------------------|------------------|
| Imperative  | Strong/Weak                 | Statically scoped  | Strict           |
| Declarative | Static/Gradual/Dynamic      | Dynamically scoped | Lazy             |

Features
* Higher order functions
* Type Inference
* Garbage Collection
* Concurrency
* Immutability
* ADTs (Algebraic Data Types)
* Modules
* Object-oriented
* Anonymous Functions
* Partial application


## 3 Hello World

```
print_endline "Hello World"
```

## 4 langnamehere in One Slide

1.  `let rec map f = function`
2.  `  | [] -> []`
3.  `  | head :: tail ->`
4.  `    let r = f head in`
5.  `    r :: map f tail`

