open System_defs
open Component_defs
open Ecs

let update dt =
  let () = Player.stop_player () in
  let () = Input.handle_input () in
  Move_system.update dt;
  Collision_system.update dt;
  Gravitate_system.update dt;
  Draw_system.update dt;
  None

let run () =
  let window_spec =
    Format.sprintf "game_canvas:%dx%d:"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create window_spec in
  let ctx = Gfx.get_context window in
  let font = Gfx.load_font Cst.font_name "" 128 in
  let _walls = Barrier.walls () in
  let player = Player.init_player () in
  let ball = Ball.ball ctx font in
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
          let global = Global.{ window; ctx; player; ball; textures } in
          Global.set global;
          Gfx.main_loop update (fun () -> ())
      )
  )