open Listener

let () =
  let port = 50000 in
  let server_sock = setup_server_socket port in
  Printf.printf "Server is running on port %d\n" port;
  accept_loop server_sock (* Start accepting connections *)
