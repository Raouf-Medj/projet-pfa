let key_table = Hashtbl.create 16
let has_key s = Hashtbl.mem key_table s
let set_key s= Hashtbl.replace key_table s ()
let unset_key s = Hashtbl.remove key_table s
let action_table = Hashtbl.create 16
let register key action = Hashtbl.replace action_table key action

let handle_input () =
  let () =
    match Gfx.poll_event () with
      KeyDown s -> (* Gfx.debug "%s\n" s; *) set_key s
    | KeyUp s -> unset_key s
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
  let gen_proj dir =
    let Global.{ last_player_proj_dt; textures; _ } = Global.get () in
    if Sys.time () -. last_player_proj_dt < Cst.player_proj_cd then ()
    else (
      let hero = Hero.get_hero () in
      let _ = Projectile.projectile (hero#position#get.x +. float hero#box#get.width /. 2. -. float Cst.projectile_size /. 2., 
                                     hero#position#get.y +. float hero#box#get.height /. 2. -. float Cst.projectile_size /. 2., 
                                     Cst.projectile_size, Cst.projectile_size, textures.(dir + 3), dir) 
      in ()
    )
  in
  register "ArrowUp" (fun () -> gen_proj 0);
  register "ArrowDown" (fun () -> gen_proj 1);
  register "ArrowRight" (fun () -> gen_proj 2);
  register "ArrowLeft" (fun () -> gen_proj 3);