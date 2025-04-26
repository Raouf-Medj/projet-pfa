open System_defs

let key_table = Hashtbl.create 16
let has_key s = Hashtbl.mem key_table s
let set_key s= Hashtbl.replace key_table s ()
let unset_key s = Hashtbl.remove key_table s
let action_table = Hashtbl.create 16
let register key action = Hashtbl.replace action_table key action

let handle_input () =
  let () =
    let is_input_blocked = not (Global.get ()).started || (Global.get ()).pause in
    match Gfx.poll_event () with
    | KeyDown "Enter" | KeyDown "return" -> if (not (Global.get ()).started) then Gfx.debug "enter\n"; set_key "Enter"
    | KeyDown "Escape" | KeyDown "escape" -> if ((Global.get ()).won || (Global.get ()).dead) then (Gfx.debug "esc_won/dead\n"; Global.restart_game ()) else if ((Global.get ()).started) then (Gfx.debug "esc_pause\n"; Global.toggle_pause ())
    | KeyDown "R" | KeyDown "r" -> if (Global.get ()).pause then (Gfx.debug "R_restart\n"; Global.restart_game (); Global.toggle_pause ())
    | KeyDown s -> if not is_input_blocked then Gfx.debug "%s\n" s; set_key s
    | KeyUp s -> if not is_input_blocked then unset_key s
    | Quit -> exit 0
    | _ -> ()
  in
  Hashtbl.iter (fun key action ->
      if has_key key then action ()) action_table

let () =
  register "z" (fun () -> Hero.(move_hero (get_hero()) Cst.up false));
  register "Z" (fun () -> Hero.(move_hero (get_hero()) Cst.up false));
  register " " (fun () -> Hero.(move_hero (get_hero()) Cst.up true));
  register "d" (fun () -> Hero.(move_hero (get_hero()) Cst.right false));
  register "D" (fun () -> Hero.(move_hero (get_hero()) Cst.right false));
  register "q" (fun () -> Hero.(move_hero (get_hero()) Cst.left false));
  register "Q" (fun () -> Hero.(move_hero (get_hero()) Cst.left false));
  register "Escape" (fun () -> Global.toggle_pause ());
  register "Enter" (fun () -> Global.start_game ());

  let gen_proj dir =
    let Global.{ last_player_proj_dt; textures; _ } = Global.get () in
    if Sys.time () -. last_player_proj_dt < Cst.player_proj_cd then ()
    else (
      let hero = Hero.get_hero () in
      let proj_size = Cst.projectile_size * hero#attack#get in
      let _ = Projectile.projectile (hero#position#get.x +. float hero#box#get.width /. 2. -. float proj_size /. 2., 
                                     hero#position#get.y +. float hero#box#get.height /. 2. -. float proj_size /. 2., 
                                     proj_size, proj_size, textures.(dir + 3), dir, hero#attack#get) 
      in ()
    )
  in
  register "ArrowUp" (fun () -> gen_proj 0);
  register "ArrowDown" (fun () -> gen_proj 1);
  register "ArrowRight" (fun () -> gen_proj 2);
  register "ArrowLeft" (fun () -> gen_proj 3);