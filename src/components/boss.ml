open Component_defs
open System_defs
open Threat

type tag += Boss of boss

let boss (x, y, width, height) ?(platform_left = 0.0) ?(platform_right = 0.0) () =
  let e = new boss() in
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#texture#set Texture.red;
  e#velocity#set Vector.{x = 0.0; y = 0.0};
  e#set_platform_boundaries platform_left platform_right;
  e#tag#set (Boss e);
  Draw_system.(register (e :> t));
  Move_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e

let update_boss_position (b : boss) =
  let pos = b#position#get in
  let vel = b#velocity#get in
  let new_pos = Vector.add pos vel in
  b#position#set new_pos;
  (* Inverser la direction si le boss atteint les bords de la plateforme *)
  let box = b#box#get in
  let platform_left = b#get_platform_left in
  let platform_right = b#get_platform_right in
  if new_pos.x <= platform_left || new_pos.x +. float box.width >= platform_right then
    b#velocity#set Vector.{x = -.vel.x; y = vel.y}

let update_boss_rapid_movement (b : boss) =
  b#velocity#set Vector.{x = 5.0; y = 0.0};
  (* Appeler update_boss_position pour gérer le mouvement rapide *)
  update_boss_position b;
  b#velocity#set Vector.{x = 0.0; y = 0.0} (* Arrêter le mouvement normal *)

let shoot_projectiles_in_arc (b : boss) =
  let pos = b#position#get in
  let num_projectiles = 8 in
  let angle_step = Float.pi /. float_of_int (num_projectiles - 1) in  (* Diviser 180° (π radians) en 8 parties *)
  for i = 0 to num_projectiles - 1 do
    let angle = Float.of_int i *. angle_step -. (Float.pi /. 2.0) in  (* Centrer l'arc autour de 0° *)
    let direction = Vector.{x = cos angle; y = sin angle} in  (* Calculer la direction à partir de l'angle *)
    let _ = Projectile.projectile (pos.x, pos.y, 16, 16, (Global.get ()).textures.(12), (int_of_float (direction.x *. 5.0)), (int_of_float (direction.y *. 5.0))) in
    ()
  done
let spawn_enemies (b : boss) =
  let pos = b#position#get in
  let spawn_offset = 32 in  (* Offset to spawn darkies near the boss *)
  let darkie_positions = [
    (pos.x -. float spawn_offset, pos.y);  (* Spawn to the left of the boss *)
    (pos.x +. float spawn_offset, pos.y);  (* Spawn to the right of the boss *)
  ] in
  List.iter (fun (x, y) ->
    let _ = Threat.darkie (int_of_float x, int_of_float y, 32, 32) () in
    ()
  ) darkie_positions