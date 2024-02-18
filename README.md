# SOCKit: Socket Oriented Concurrency Kit

**Authors:**
- Quentin Autry (System Architect)
- Quinn Booth (Language Guru)
- Hakim El Ghazi (Float Goat)
- Ryan Najac (Manager)
- Stacey Yao (Tester)
# Motivation

The Socket-Oriented Concurrency Kit Unix combines Unix socket programming with bash-like syntax for safe and easy concurrency with the robustness of a C program. With improvements like warning compiler warnings for potential race conditions and deadlocks, SOCKit aims to make concurrent programming safer and more accessible leveraging `source` and `destination` data type alongside a pipelining syntax. The language facilitates (pseudo-)multi-threaded and asynchronous inter-client communication and simplifies the flow of data across devices. SOCKit is an ideal choice for developers focused on efficient data transfer and real-time communication.

# Language Paradigms and Features

SOCKit is an imperative, weakly but statically typed language with static scope and a strict evaluation order, designed for clarity and predictability. It supports efficient concurrency, socket programming, and data pipelining to enhance processing efficiency. Future considerations include compiler-enforced mutual exclusion for concurrency safety, built-in regex support for easier text processing, and automatic thread garbage collection for improved memory management.

# “Hello World”

```plaintext
send{"Hello, world!"}-> DEST & DEST <- 192.168.1.1:8080
```

# “Language in One Slide”

```plaintext
SRC <- localhost
DEST1 <- 192.168.1.1:10
DEST2 <- 192.168.1.2:20
DEST3 <- 192.168.1.3

func encrypt (DATA, key) -> encrypted_msg
    -> ~DATA ? "EMPTY MSG! "
    -> DATA ? msg == key ? msg

    set encrypted_msg ""
    for c in i in msg
        set encrypted_char (c + key[i % len(key)]) % 256
        encrypted_msg += encrypted_char

set protocol send_by_character (msg) -{}->
    for i in msg
        -> i

set protocol wait_to_send (port, msg) -{send_by_character}->
    set received listen(SRC:port)
    wait while ~receive
    send{"BAD"} ? ~received : -> msg

!! Send encrypted msg to DEST1, then DEST2 and port 30 of DEST3
send{"Hello", "aX82kLei19g"} -> encrypt -> DEST1 | DEST2 & DEST3:30
```
