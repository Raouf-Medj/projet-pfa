open System_defs

(* On crée une fenêtre *)
let init () =
  let win = Gfx.create (Format.sprintf "game_canvas:%dx%d:r=presentvsync" 800 600) in
  Game_state.set_window win
(*
let player =
  let p = Box.create 200.0 200.0 100 100 (Gfx.color 255 0 0 255) in
  Draw_system.register p;
  p
*)

(* Question 1 *)
let init_walls () =
  let blue = Texture.color (Gfx.color 0 0 255 255) in
  let black = Texture.color (Gfx.color 0 0 0 255) in
  ignore (Box.create "wall_top" 0 0 800 40 blue infinity);
  ignore (Box.create "wall_bottom" 0 560 800 40 blue infinity);
  ignore (Box.create "wall_left" 0 40 40 520 black infinity);
  ignore (Box.create "wall_right" 760 40 40 520 black infinity)

(* Question 10 *)
let init_squares () =
  let () = Random.self_init () in
  for i = 0 to 9 do
    let x = 40 + Random.int  720 in
    let y = 40 + Random.int 500 in
    let mass = 1.0 +. Random.float 19.0 in
    let texture = Texture.color (Gfx.color 255 0 0 255) in
    let s = Box.create (Printf.sprintf "square_%d" i ) x y 50 50 texture mass in
    s#sum_forces#set Vector.{ x = Random.float 0.25; y = Random.float 0.25 }
  done

(*
 let keys = Hashtbl.create 16
let white = Gfx.color 255 255 255 2555
*)
let update dt =
  Collision_system.update dt;
  Force_system.update dt;
  Move_system.update dt;
  Draw_system.update dt;
  ignore (Gfx.poll_event());
  true

let run () =
  init ();
  init_walls ();
  init_squares ();
  Gfx.main_loop update
