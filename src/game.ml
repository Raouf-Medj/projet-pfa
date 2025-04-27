open System_defs
open Component_defs
open Ecs
open Pause_screen

let update dt =
    let () = Scene.update_scene () in
    let () = Input.handle_input () in
    let g = Global.get () in
    if (not (g.pause) && g.started && not g.dead) then (
      Move_system.update dt;
      Animation_system.update dt;
      Atk.launch_attacks ();
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
                  let last_time_shot = 0. in
                  let last_special_attack_time = 0. in
                  let score = 0 in
                  let global = Global.{ window; ctx; hero = None; textures; scenes; current_scene; load_next_scene; restart; last_player_proj_dt; pause=false; won=false; started=false; dead=false; boss=None; boss_tower=None; last_special_attack_time; last_time_shot; score } in
                  Global.set global;
                  Gfx.main_loop update (fun () -> ())
              )
          )
      )
  )