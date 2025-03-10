open Component_defs
(* A module to initialize and retrieve the global state *)
type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  mutable hero : hero option;
  textures : Texture.t array;
  scenes : string array array;
  mutable current_scene : int;
  mutable load_next_scene : bool;
  mutable restart : bool;
  mutable last_player_proj_dt : float;
}

val get : unit -> t
val set : t -> unit
