let message () = "Hello, World!"

let say_hello () = Lwt_main.run (Lwt_io.printf "%s\n" (message ()))
