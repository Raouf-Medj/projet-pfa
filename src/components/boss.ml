open Component_defs
open System_defs

type tag += Boss of boss

let bosss = ref []

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
  bosss := e :: !bosss;
  e


let update_boss_position (b : boss) =
  let hero_pos = Game_state.get_hero_position () in
  let b_pos = b#position#get in
  let vel = b#velocity#get in
  let platform_left = b#get_platform_left in
  let platform_right = b#get_platform_right in
  
    (* Vérifier si le héros est sur la même plateforme que le b *)
  if hero_pos.x >= platform_left +. float b#box#get.width &&
    hero_pos.x <= platform_right -. float b#box#get.width then (    (* Le héros est sur la même plateforme, le b commence à le pourchasser *)
    let direction = Vector.sub hero_pos b_pos in
    let distance = Vector.norm direction in
    if distance > 0.0 then (
      let normalized_direction = Vector.normalize direction in
      let speed = 1.5 in
      let velocity = Vector.mult speed normalized_direction in
      b#velocity#set Vector.{ x = velocity.x; y = 0.0 };
      let new_pos = Vector.add b_pos b#velocity#get in
      b#position#set Vector.{ x = new_pos.x; y = b_pos.y }
    )
  ) else (
      (* Le héros n'est pas sur la même plateforme, le b agit comme un darkie *)
    let new_pos = Vector.add b_pos vel in
    b#position#set new_pos;
  
      (* Inverser la direction si le b atteint les bords de la plateforme *)
    let box = b#box#get in
    if new_pos.x <= platform_left || new_pos.x +. float box.width >= platform_right then (
      b#velocity#set Vector.{ x = -.vel.x; y = vel.y }
    )
  )
let update_boss_rapid_movement (b : boss) =
  b#velocity#set Vector.{x = 5.0; y = 0.0};
  (* Appeler update_boss_position pour gérer le mouvement rapide *)
  update_boss_position b;
  b#velocity#set Vector.{x = 0.0; y = 0.0} (* Arrêter le mouvement normal *)

(*let shoot_projectiles_in_arc (b : boss) (hero : hero)=
    (* Exemple : Le boss attaque le héros s'il est proche *)
    let boss_pos = b#position#get in
    let hero_pos = hero#position#get in
    if Vector.norm boss_pos hero_pos < 50.0 then
      boss_attack_hero b hero*)
  
let spawn_enemies (b : boss) =
  let pos = b#position#get in
  let spawn_offset = 32 in  (* Offset to spawn darkies near the boss *)
  let darkie_positions = [
    (pos.x -. float spawn_offset, pos.y);  (* Spawn to the left of the boss *)
    (pos.x +. float spawn_offset, pos.y);  (* Spawn to the right of the boss *)
  ] in
  List.iter (fun (x, y) ->
    let _ = Threat.threat (int_of_float x, int_of_float y, 32, 32, 0) ~platform_left:(b#get_platform_left) ~platform_right:(b#get_platform_right) () in
    ()
  ) darkie_positions

  