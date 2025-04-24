open Component_defs
open System_defs

type tag += Boss of boss

let bosss = ref []

let boss (x, y, width, height) ?(platform_left = 0.0) ?(platform_right = 0.0) () =
  let e = new boss() in
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#texture#set Texture.red;
  e#velocity#set Vector.{x = 1.0; y = 0.0};
  e#set_platform_boundaries platform_left platform_right;
  e#tag#set (Boss e);
  e#health#set 10;
  Draw_system.(register (e :> t));
  Move_system.(register (e :> t));
  Collision_system.(register (e :> t));
  bosss := e :: !bosss;
  e


  let update_boss_position (b : boss) =
    let hero_pos = Game_state.get_hero_position () in
    let b_pos = b#position#get in
    let platform_left = b#get_platform_left in
    let platform_right = b#get_platform_right in
    let tile_size = 32.0 in  (* Taille d'une case en pixels *)
    let fixed_distance = 5.0 *. tile_size in  (* Distance fixe en nombre de cases (5 cases ici) *)
  
    (* Calculer la position cible du boss *)
    let target_x =
      if hero_pos.x < b_pos.x then hero_pos.x +. fixed_distance  (* Si le héros est à gauche *)
      else hero_pos.x -. fixed_distance  (* Si le héros est à droite *)
    in
  
    (* Contraindre la position cible à rester sur la plateforme *)
    let target_x = max platform_left (min target_x (platform_right -. float b#box#get.width)) in
  
    (* Déplacer le boss uniquement si nécessaire *)
    if abs_float (b_pos.x -. target_x) > 1.0 then (
      let direction = target_x -. b_pos.x in
      let speed = 1.5 in
      let velocity_x = if direction > 0.0 then speed else -.speed in
      b#velocity#set Vector.{x = velocity_x; y = 0.0};
      let new_pos = Vector.add b_pos b#velocity#get in
      b#position#set Vector.{x = new_pos.x; y = b_pos.y}
    ) else (
      (* Arrêter le boss s'il est déjà à la position cible *)
      b#velocity#set Vector.{x = 0.0; y = 0.0}
    )

let update_boss_rapid_movement (b : boss) =
  b#velocity#set Vector.{x = 5.0; y = 0.0};
  (* Appeler update_boss_position pour gérer le mouvement rapide *)
  update_boss_position b;
  b#velocity#set Vector.{x = 0.0; y = 0.0} (* Arrêter le mouvement normal *)


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

  
  
let perform_special_attack (b : boss) =
  (* Générer un nombre aléatoire entre 1 et 10 *)
  let chance = Random.int 10 + 1 in
  if chance = 1 then (
    (* Choisir une attaque spéciale aléatoire *)
    let attack = Random.int 3 in
    match attack with
    | 0 -> FinalBoss.shoot_fireballs  (* Tirer des fireballs *)
    | 1 -> update_boss_rapid_movement b  (* Mouvement rapide *)
    | 2 -> spawn_enemies b  (* Invoquer des ennemis *)
    | _ -> ()  (* Ne rien faire, cas par défaut *)
  )

  (*Game.ml 
  let current_time = Sys.time () in
    if current_time -. !last_special_attack_time >= 1.0 then (
      last_special_attack_time := current_time;
      List.iter (fun boss -> Boss.perform_special_attack boss) !Boss.bosss
    );*)