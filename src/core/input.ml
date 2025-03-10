let key_table = Hashtbl.create 16
let has_key s = Hashtbl.mem key_table s
let set_key s= Hashtbl.replace key_table s ()
let unset_key s = Hashtbl.remove key_table s

let action_table = Hashtbl.create 16
let register key action = Hashtbl.replace action_table key action

let handle_input () =
  let () =
    match Gfx.poll_event () with
      KeyDown s -> Gfx.debug "%s\n" s; set_key s
    | KeyUp s -> unset_key s
    | Quit -> exit 0
    | _ -> ()
  in
  Hashtbl.iter (fun key action ->
      if has_key key then action ()) action_table

let () =
  register "z" (fun () -> Hero.(move_hero (get_hero()) Cst.up));
  register "s" (fun () -> Hero.(move_hero (get_hero()) Cst.down));
  register "d" (fun () -> Hero.(move_hero (get_hero()) Cst.right));
  register "q" (fun () -> Hero.(move_hero (get_hero()) Cst.left));
  register "ArrowUp" (fun () -> let hero = Hero.get_hero () in let _ = Projectile.projectile (hero#position#get.x +. float hero#box#get.width /. 2. -. float Cst.projectile_size /. 2., hero#position#get.y +. float hero#box#get.height /. 2. -. float Cst.projectile_size /. 2., Cst.projectile_size, Cst.projectile_size, 0) in ());
  register "ArrowDown" (fun () -> let hero = Hero.get_hero () in let _ = Projectile.projectile (hero#position#get.x +. float hero#box#get.width /. 2. -. float Cst.projectile_size /. 2., hero#position#get.y +. float hero#box#get.height /. 2. -. float Cst.projectile_size /. 2., Cst.projectile_size, Cst.projectile_size, 1) in ());
  register "ArrowRight" (fun () -> let hero = Hero.get_hero () in let _ = Projectile.projectile (hero#position#get.x +. float hero#box#get.width /. 2. -. float Cst.projectile_size /. 2., hero#position#get.y +. float hero#box#get.height /. 2. -. float Cst.projectile_size /. 2., Cst.projectile_size, Cst.projectile_size, 2) in ());
  register "ArrowLeft" (fun () -> let hero = Hero.get_hero () in let _ = Projectile.projectile (hero#position#get.x +. float hero#box#get.width /. 2. -. float Cst.projectile_size /. 2., hero#position#get.y +. float hero#box#get.height /. 2. -. float Cst.projectile_size /. 2., Cst.projectile_size, Cst.projectile_size, 3) in ());
