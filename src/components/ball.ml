open Ecs
open Component_defs
open System_defs

type tag += Ball of ball

let ball ctx font =
  let e = new ball () in
  let y_orig = float Cst.ball_v_offset in
  e#texture#set Cst.ball_color;
  (* let Global.{textures; _} = Global.get () in
  e#texture#set textures.(1); *)
  e#position#set Vector.{x = float Cst.ball_left_x; y = y_orig};
  e#box#set Rect.{width = Cst.ball_size; height = Cst.ball_size};
  e#velocity#set Vector.zero;
  e#tag#set (Ball e);
  e#resolve#set (fun n t ->
    match t#tag#get with
    | Barrier.Barrier w ->
      (* e#velocity#set Vector.{ x = e#velocity#get.x *. n.x; y = e#velocity#get.y *. n.y } *)
      let s_pos, s_rect = Rect.mdiff e#position#get e#box#get w#position#get w#box#get in
      let n = Rect.penetration_vector s_pos s_rect in
      e#position#set (Vector.sub e#position#get n);
      e#velocity#set Vector.zero;
      if e#position#get.y < w#position#get.y then e#is_grounded#set true
    | _ -> ()
  );
  Draw_system.(register (e :>t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  Gravitate_system.(register (e :> t));
  e

let random_v b =
  let a = Random.float (Float.pi/.2.0) -. (Float.pi /. 4.0) in
  let v = Vector.{x = cos a; y = sin a} in
  let v = Vector.mult 5.0 (Vector.normalize v) in
  if b then v else Vector.{ v with x = -. v.x }

let get_ball () = 
  let Global.{ball; _ } = Global.get () in
  ball

let stop_ball () = 
  let Global.{ball; _ } = Global.get () in
  ball#velocity#set Vector.zero

let move_ball ball v =
  if Vector.norm ball#velocity#get < 20. then
    Gfx.debug "y = %f\n" v.Vector.y;
    if v.Vector.y < 0. && ball#is_grounded#get then (
      Gfx.debug "jump\n";
      ball#is_grounded#set false;
      ball#velocity#set Vector.{ x = 0.; y = -5. }
    )
    else (
      if v.Vector.x <> 0. && ball#is_grounded#get then (
        Gfx.debug "lr\n";
        ball#velocity#set (Vector.add ball#velocity#get Vector.{ x = v.x *. 15.; y = 0. }) 
      )
      else
        ball#velocity#set (Vector.add ball#velocity#get Vector.{ x = v.x; y = 0. })
    )