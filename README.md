# SOCKit: Socket Oriented Concurrency Kit

**Authors:**
- Quentin Autry (System Architect)
- Quinn Booth (Language Guru)
- Hakim El Ghazi (Float Goat)
- Ryan Najac (Manager)
- Stacey Yao (Tester)

## Motivation

SockIt introduces a blend of Unix socket programming and concurrency, drawing inspiration from the efficiency and robustness of C programming. The core ambition of SockIt is to offer a streamlined experience in utilizing concurrency, surpassing C's complexity by integrating features that enhance the developer's quality of life. These enhancements include compiler warnings for potential race conditions and deadlocks, aiming to make concurrent programming more accessible and safer. SockIt is designed for programmers seeking a sophisticated yet more intuitive approach to multi-threading, complemented by seamless socket programming capabilities. The language facilitates effortless inter-client communication, leveraging `source` and `destination` data type alongside a pipelining syntax. This innovative approach not only visualizes but also simplifies the flow of data across devices, making SockIt an ideal choice for developers focused on efficient data transfer and real-time communication.

## Language Paradigms and Features

- **Imperative Paradigm:** Focus is on commands for the computer to perform.
- **Weakly, Statically Typed:** Variables are defined with types at compile time, though the typing system allows some flexibility.
- **Statically Scoped and Strict Evaluation Order:** Clear and predictable.
- **Concurrency:** Built-in efficient multi-threading and parallel processing.
- **Socket Programming:** Provides first-class support for socket operations, streamlining the complexities of network communication.
- **Pipelining Data:** Introduces a syntax for data pipelining, significantly improving data processing efficiency, throughput, and latency.

### Features Under Consideration:

- **Automatic Mutual Exclusion:** Proposes compiler-enforced mutual exclusion for shared variables to mitigate race conditions, enhancing concurrency safety.
- **Regex Pattern Matching:** Aims to integrate built-in support for regular expression matching, facilitating more straightforward text processing.
- **Garbage Collection for Threads:** Contemplates the automatic management of spawned threads, addressing memory management and resource cleanup.

## “Hello World”

```"Hello, world!" -{send}-> 192.168.1.1:12345 &```

## "SOCKit in One Slide"

1.  find DEST1 @ 192.168.1.1:10
2.  find DEST2 @ 192.168.1.2:20
3.  find DEST3 @ 192.168.1.3
4.  find ME @ localhost
5.  
6.  func encrypt (msg, key) ~> encrypted_msg
7.      ~> "EMPTY" ? ~msg
8.      ~> msg ? msg = key
9.      let encrypted_msg = ""
10.     for msg_char at i in msg
11.         encrypted_msg += (msg_char + key[i % len(key)]) % 256
12. 
13. protocol send_by_character (msg)
14.     for i in msg
15.         ~> i
16. 
17. protocol wait_to_send (port, msg)
18.     let received = listen(port)
19.     while ~received
20.         wait
21.     ~{send}~> "BAD" ? ~received
22.     ~> msg
23. 
24. ("Hello", "Key123") ~> encrypt ~{send}~> DEST1 > DEST2 | DEST3(30) &
25. "Hello" ~{send_by_character}~> DEST1 | DEST2 &
26. 
27. let dests = [DEST1, DEST2]
28. "Hello" ~{wait_to_send}~> |dests| &  !! Wait, then send concurrently.
29. "Hello" |~{send, send_by_character}~> dests| &  !! Use different protocols.

