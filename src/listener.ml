(* Import the Unix module for neworking functionalities. *)
open Unix;;

(* Function to create a socket, bind it to an address and port, and start listening. *)
let setup_server_socket port =
    let socket_addr = ADDR_INET (inet_addr_loopback, port) in
    let sock = socket PF_INET SOCK_STREAM 0 in (* Create a socket *)
    setsockopt sock SO_REUSEADDR true; (* Allows the reuse of local addresses *)
    bind sock socket_addr; (* Bind the socket to the address *)
    listen sock 10; (* Listen on the socket, with a max of 10 pending connections *)
    sock;;

(* Function to handle client connection, reading data and printing to stdout. *)
let handle_client client_sock =
    let buffer = Bytes.create 4096 in  (* Create a buffer for reading data *)
    try
        while true do
            let bytes_read = read client_sock buffer 0 (Bytes.length buffer) in
            if bytes_read = 0 then raise Exit; (* End of file/connection closed by client *)
            (* Print the received data to stdout *)
            print_string (Bytes.sub_string buffer 0 bytes_read);
            flush stdout;  (* Ensure that the output is displayed immediately *)
        done
    with
    | Exit -> ()  (* Gracefully exit the loop when the client disconnects *)
    | e -> Printf.printf "An error occurred: %s\n" (Printexc.to_string e);;

let rec accept_loop sock =
    match accept sock with
    | (client_sock, client_addr) ->
        (match client_addr with
            | ADDR_INET (addr, port) ->
                Printf.printf "Accepted connection from %s:%d\n" (Unix.string_of_inet_addr addr) port
            | _ -> ());  (* Handle non-INET addresses if necessary *)
        handle_client client_sock;  (* Handle the client connection *)
        accept_loop sock  (* Continue accepting new connections *)

let () =
    let port = 50000 in
    let server_sock = setup_server_socket port in
    Printf.printf "Server is running on port %d\n" port;
    accept_loop server_sock  (* Start accepting connections *)

