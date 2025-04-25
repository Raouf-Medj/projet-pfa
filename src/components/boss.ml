open Component_defs
open System_defs

type tag += Boss of boss

let bosss = ref None

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
  bosss := Some e;
  e


 let update_boss_position (b : boss) =
  if b#is_in_rapid_movement ()  then (if b#position#get =  Game_state.get_hero_position () then (b#stop_rapid_movement () )) 
      (* Ne rien faire si le boss est en attaque rapide *)
  else (
    let hero_pos = Game_state.get_hero_position () in
    let b_pos = b#position#get in
    let platform_left = b#get_platform_left in
    let platform_right = b#get_platform_right in
    let tile_size = 32.0 in  (* Taille d'une case en pixels *)
    let fixed_distance = 7.0 *. tile_size in  (* Distance fixe en nombre de cases (5 cases ici) *)

    (* Calculer la position cible du boss *)
    let target_x =
      if hero_pos.x < b_pos.x then hero_pos.x +. fixed_distance  (* Si le héros est à gauche *)
      else hero_pos.x -. fixed_distance  (* Si le héros est à droite *)
    in

    (* Contraindre la position cible à rester sur la plateforme *)
    let constrained_target_x = max platform_left (min target_x (platform_right -. float b#box#get.width)) in

    (* Si le boss est bloqué dans un coin, inverser la direction et augmenter temporairement la vitesse *)
    let (final_target_x, temporary_speed) =
      if abs_float (constrained_target_x -. target_x) > 1.0 then (
        (* Le boss est bloqué, aller dans l'autre sens et augmenter la vitesse *)
        if hero_pos.x < b_pos.x then (platform_right -. fixed_distance, 4.0)
        else (platform_left +. fixed_distance, 4.0)
      ) else (constrained_target_x, 1.5)  (* Vitesse normale *)
    in

    (* Déplacer le boss uniquement si nécessaire *)
    if abs_float (b_pos.x -. final_target_x) > 1.0 then (
      let direction = final_target_x -. b_pos.x in
      let velocity_x = if direction > 0.0 then temporary_speed else -.temporary_speed in
      b#velocity#set Vector.{x = velocity_x; y = 0.0};
      let new_pos = Vector.add b_pos b#velocity#get in
      b#position#set Vector.{x = new_pos.x; y = b_pos.y}
    ) else (
      (* Arrêter le boss s'il est déjà à la position cible *)
      b#velocity#set Vector.{x = 0.0; y = 0.0}
    )
  )
let update_boss_rapid_movement (b : boss) =
  if (not (b#is_in_rapid_movement ())) then (
  let hero_pos = Game_state.get_hero_position () in
  let b_pos = b#position#get in
  let platform_left = b#get_platform_left in
  let platform_right = b#get_platform_right in

  (* Calculer la position cible pour l'attaque rapide *)
  let final_target_x = hero_pos.x
  in

  (* Déplacer le boss uniquement si nécessaire *)
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
  let darkie_positions = [
    (pos.x -. float spawn_offset, pos.y);  (* Spawn to the left of the boss *)
    (pos.x +. float spawn_offset, pos.y);  (* Spawn to the right of the boss *)
  ] in
  List.iter (fun (x, y) ->(*After the merge ndirou typ = 2 to spawn followers*)
    let _ = Threat.threat (int_of_float x, int_of_float y, 32, 32, 0) ~platform_left:(b#get_platform_left) ~platform_right:(b#get_platform_right) () in
    ()
  ) darkie_positions

  
let perform_special_attack (b : boss) =
  (* Générer un nombre aléatoire entre 1 et 10 *)
  let atack = Random.int 10 + 1 in
  match atack with
  | 0| 1| 2  -> update_boss_rapid_movement b (* Invoquer des ennemis *)
  | 3| 4 ->  spawn_enemies b  (* Mouvement rapide *)
  | _ -> ()  (* Ne rien faire, cas par défaut *)
  
