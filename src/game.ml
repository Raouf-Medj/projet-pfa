open System_defs
open Component_defs
open Ecs
open Pause_screen

let last_special_attack_time = ref 0.0  (* Temps de la dernière attaque spéciale *)
let special_attack_interval = 1.  (* Intervalle en secondes entre les attaques spéciales *)

let update dt =
    let () = Scene.update_scene () in
    let () = Input.handle_input () in
    if (not ((Global.get ()).pause) && (Global.get ()).started && not (Global.get ()).dead) then (
      Move_system.update dt;
      Animation_system.update dt;
      (*FireballTower.update_fireball_towers ();*)
      let Global.{hero; _ } = Global.get () in
      (match hero with
      | Some h ->
        Hero.update_hero_cooldown h;
        List.iter (fun darkie -> Threat.update_darkie_position darkie) !Threat.darkies;
        List.iter (fun follower -> Threat.update_follower_position follower) !Threat.followers;
        (match !Boss.bosss with 
        |Some b -> 
          let current_time = Sys.time () in
          if current_time -. !last_special_attack_time >= special_attack_interval then (
            last_special_attack_time := current_time;
            BossAtack.perform_special_attack b h;
          )else if current_time -. !last_special_attack_time >= special_attack_interval/. 2. then  Boss.update_boss_position b;
          List.iter (fun tower ->  if tower#is_on_boss() then FireballTower.move_tower tower b;) !FireballTower.towers;

        |None ->() (* Je mettrai le soleil ou une clé genre là*) )
      | None -> ());
      let () = Hero.reset_hero_gravity () in
      Collision_system.update dt;
      Gravitate_system.update dt; 
    );
    Draw_system.update dt;
    None

let run () =
  let window_spec =
    Format.sprintf "game_canvas:%dx%d:"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create window_spec in
  let ctx = Gfx.get_context window in
  let level_list = Gfx.load_file "resources/files/levels.txt" in
  Gfx.main_loop (fun _dt -> Gfx.get_resource_opt level_list) (
    fun txt ->
      let levelz = txt
                      |> String.split_on_char '\n'
                      |> List.filter (fun s -> s <> "")
                      |> List.map (fun s -> Gfx.load_file ("resources/files/" ^ s))
      in
      Gfx.main_loop (fun _dt -> if List.for_all Gfx.resource_ready levelz then Some (List.map Gfx.get_resource levelz) else None) (
        fun level_texts ->
          let scenes = level_texts
                         |> List.map (fun txt -> txt |> String.split_on_char '\n' |> Array.of_list)
                         |> Array.of_list
          in
          let resource_list = Gfx.load_file "resources/files/resource_list.txt" in
          Gfx.main_loop (fun _dt -> Gfx.get_resource_opt resource_list) (
            fun txt ->
              let resources = txt
                              |> String.split_on_char '\n'
                              |> List.filter (fun s -> s <> "")
                              |> List.map (fun s -> Gfx.load_image ctx ("resources/images/" ^ s))
              in
              Gfx.main_loop (fun _dt -> if List.for_all Gfx.resource_ready resources then Some (List.map Gfx.get_resource resources) else None) (
                fun images ->
                  let textures = images
                                |> List.map (fun img -> Texture.Image img)
                                |> Array.of_list
                  in
                  let current_scene = -1 in
                  let load_next_scene = true in
                  let restart = false in
                  let last_player_proj_dt = 0. in
                  let global = Global.{ window; ctx; hero = None; textures; scenes; current_scene; load_next_scene; restart; last_player_proj_dt; pause=false; won=false; started=false; dead=false } in
                  Global.set global;
                  Gfx.main_loop update (fun () -> ())
              )
          )
      )
  )
