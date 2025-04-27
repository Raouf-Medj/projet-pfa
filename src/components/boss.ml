open Component_defs
open System_defs

type tag += Boss of boss

let boss (x, y, width, height) ?(platform_left = 0.0) ?(platform_right = 0.0) () =
  let e = new boss() in
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#texture#set (let Global.{textures; _} = Global.get () in textures.(39));
  e#velocity#set Vector.{x = 1.0; y = 0.0};
  e#set_platform_boundaries platform_left platform_right;
  e#tag#set (Boss e);
  e#health#set 30;
  Draw_system.(register (e :> t));
  Move_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e

 let update_boss_position (b : boss) =
  (* Vérifier si le boss est en mouvement rapide et s'il est déjà à la position cible *)
  if b#is_in_rapid_movement ()  then (if b#position#get =  Global.get_hero_position () then (b#stop_rapid_movement () )) 
  else (
    let hero_pos = Global.get_hero_position () in
    let b_pos = b#position#get in
    
    if(hero_pos.x < b_pos.x) then
      b#texture#set (let Global.{textures; _} = Global.get () in textures.(39))
    else b#texture#set (let Global.{textures; _} = Global.get () in textures.(38));

    let platform_left = b#get_platform_left in
    let platform_right = b#get_platform_right in
    let tile_size = 32.0 in
    let fixed_distance = 7.0 *. tile_size in

    (* Calculer la position cible du boss *)
    let target_x =
      if hero_pos.x < b_pos.x then hero_pos.x +. fixed_distance
      else hero_pos.x -. fixed_distance
    in

    (* Contraindre la position cible à rester sur la plateforme *)
    let constrained_target_x = max (platform_left) (min target_x (platform_right -. float b#box#get.width)) in

    (* Si le boss est bloqué dans un coin, inverser la direction et augmenter temporairement la vitesse *)
    let (final_target_x, temporary_speed) =
      if abs_float (constrained_target_x -. target_x) > 1.0 then (
        if hero_pos.x < b_pos.x then (platform_right -. fixed_distance, 4.0)
        else (platform_left +. fixed_distance, 4.0)
      ) else (constrained_target_x, 1.5)
    in

    (* Déplacer le boss uniquement si nécessaire *)
    if abs_float (b_pos.x -. final_target_x) > 1.0 then (
      let direction = final_target_x -. b_pos.x in
      let velocity_x = if direction > 0.0 then temporary_speed else -.temporary_speed in
      b#velocity#set Vector.{x = velocity_x; y = 0.0};
      let new_pos = Vector.add b_pos b#velocity#get in
      b#position#set Vector.{x = new_pos.x; y = b_pos.y}
    ) else (
      b#velocity#set Vector.{x = 0.0; y = 0.0}
    )
  )

let update_boss_rapid_movement (b : boss) =
  if (not (b#is_in_rapid_movement ())) then (
  let hero_pos = Global.get_hero_position () in
  let b_pos = b#position#get in
  let platform_left = b#get_platform_left in
  let platform_right = b#get_platform_right in

  let final_target_x = hero_pos.x
  in
  if (abs_float (b_pos.x -. final_target_x) > 1.0 && final_target_x < platform_right -. float b#box#get.width && final_target_x > platform_left  )then (
    b#start_rapid_movement ();  (* Activer l'état d'attaque rapide *)
    let direction = final_target_x -. b_pos.x in
    let speed = 4.0 in
    let velocity_x = if direction > 0.0 then speed else -.speed in
    b#velocity#set Vector.{x = velocity_x; y = 0.0};
    let new_pos = Vector.add b_pos b#velocity#get in
    b#position#set Vector.{x = new_pos.x; y = b_pos.y};
    
    (* Vérifier si le boss a atteint la cible *)
    if abs_float (b_pos.x -. final_target_x) <= 0.3 then
      b#velocity#set Vector.{x = 0.0; y = 0.0};
      b#stop_rapid_movement ()  (* Désactiver l'état d'attaque rapide *)
  ))

let spawn_enemies (b : boss) =
  let pos = b#position#get in
  let spawn_offset = 32 in  (* Offset to spawn darkies near the boss *)
  let follower_positions = [
    (pos.x -. float spawn_offset, pos.y);
    (pos.x +. float spawn_offset, pos.y);
  ] in
  List.iter (fun (x, y) ->
    let h = HealthBar.healthBar (int_of_float x, int_of_float y, 16, 8, 3) in
    let _ = Threat.threat (int_of_float x, int_of_float y + 64 + 16, 32, 16, 2) ~platform_left:(b#get_platform_left) ~platform_right:(b#get_platform_right) ~h () in
    ()
  ) follower_positions