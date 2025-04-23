
open Ecs

module Collision_system = System.Make(Collision)

module Draw_system = System.Make(Draw)

module Move_system = System.Make(Move)

module Gravitate_system = System.Make(Gravitate)

module Pause_system = struct
  include System.Make(Pause)

  (* Expose les fonctions spécifiques à Pause *)
  let toggle_pause = Pause.toggle_pause
  let is_game_paused = Pause.is_game_paused
end