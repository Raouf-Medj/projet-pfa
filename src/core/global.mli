(* A module to initialize and retrieve global objects *)

val window : unit -> Gfx.window
(** Returns the main window *)


val init : string -> unit

val scoring : unit -> int
val set_scoring : int -> unit

