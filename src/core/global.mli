open Component_defs
(* A module to initialize and retrieve the global state *)
type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player : player option;
  hero : hero option;
  textures : Texture.t array;
}

val get : unit -> t
val set : t -> unit
