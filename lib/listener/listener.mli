(* listener.mli *)

(** Networking functionalities leveraging the Unix module. *)

val setup_server_socket : int -> Unix.file_descr
(** [setup_server_socket port] sets up a server socket on the specified [port].
    It creates a socket, binds it to a loopback address and the given port, and starts listening on it.
    The socket is set to allow the reuse of local addresses and is configured to listen with a maximum of 10 pending connections.
    @param port The port number on which the server will listen for incoming connections.
    @return A file descriptor for the created and bound socket. *)

val handle_client : Unix.file_descr -> unit
(** [handle_client client_sock] handles communication with a connected client through [client_sock].
    It reads data from the client, printing it to the standard output (stdout) as it is received.
    This function runs in a loop, continuously reading data until the connection is closed by the client or an error occurs.
    @param client_sock The client's socket file descriptor through which data is received.
    Note: This function can raise [Exit] to signal the end of the file or connection closure by the client. *)

val accept_loop : Unix.file_descr -> unit
(** [accept_loop sock] continuously accepts incoming connections on the socket [sock] and handles them using [handle_client].
    For each accepted connection, it prints the address and port number of the connecting client.
    This function recurses indefinitely, effectively running the server in an infinite loop to accept and handle new connections.
    @param sock The server socket file descriptor on which the server accepts incoming connections. *)
