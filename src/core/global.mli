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
  mutable pause : bool;
  mutable won : bool;
  mutable started : bool;
  mutable dead : bool;
  mutable boss : boss option;
  mutable boss_tower : tower option;
}

val get : unit -> t
val set : t -> unit
val toggle_pause : unit -> unit
val start_game : unit -> unit
val restart_game : unit -> unit
val reset : unit -> unit
val die : unit -> unit
val set_boss_position : Vector.t -> unit
val get_boss_position : unit -> Vector.t
val set_hero_position : Vector.t -> unit
val get_hero_position : unit -> Vector.t
val set_boss_health : int -> unit
val get_boss_health : unit -> int