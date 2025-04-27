open Component_defs

(* We had to put this aside because of dependency cycles *)
let perform_special_attack (b : boss) (h : hero) =
  let atk = Random.int 10 in
  match atk with
  | 0 | 1 | 2  -> Boss.update_boss_rapid_movement b
  | 3 | 4 ->  Boss.spawn_enemies b
  | 5 | 6 -> FireballTower.shoot b h
  | _ -> ()

let launch_attacks () =
  let g = Global.get () in
  (match g.hero with
  | Some h ->
    Hero.update_hero_cooldown h;
    List.iter (fun darkie -> Threat.update_darkie_position darkie) !Threat.darkies;
    List.iter (fun follower -> Threat.update_follower_position follower) !Threat.followers;
    let current_time = Sys.time () in
    if current_time -. g.last_time_shot >= Cst.shooting_interval then (
      g.last_time_shot <- current_time;
      Global.set g;
      List.iter (fun tower -> if (not (tower#is_on_boss())) then  FireballTower.shoot_fireballs tower h) !FireballTower.towers;
    );
    (match (Global.get ()).boss with 
    | Some b -> 
      let current_time = Sys.time () in
      if current_time -. g.last_special_attack_time >= Cst.special_attack_interval then (
        g.last_special_attack_time <- current_time;
        Global.set g;
        perform_special_attack b h;
      )else if current_time -. g.last_special_attack_time >= Cst.special_attack_interval/. 2. then  Boss.update_boss_position b;
      List.iter (fun tower ->  if tower#is_on_boss() then FireballTower.move_tower tower b;) !FireballTower.towers;
    | None -> ()
    );
  | None -> ());
  Hero.reset_hero_gravity ();