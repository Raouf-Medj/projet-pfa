open Ecs
open Component_defs
open System_defs

type tag += Hero of hero

let hero ctx font =
  let e = new hero () in
  let y_orig = float Cst.ball_v_offset in
  (* e#texture#set Cst.ball_color; *)
  let Global.{textures; _} = Global.get () in
  e#texture#set textures.(0);
  e#position#set Vector.{x = float Cst.ball_left_x; y = y_orig};
  e#box#set Rect.{width = Cst.ball_size; height = Cst.ball_size};
  e#velocity#set Vector.zero;
  e#tag#set (Hero e);
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

let get_hero () = 
  let Global.{hero; _ } = Global.get () in
  match hero with
  | Some h -> h
  | None -> failwith "No hero"

let stop_hero () = 
  let Global.{hero; _ } = Global.get () in
  match hero with
  | Some h -> h#velocity#set Vector.zero
  | None -> ()

let move_hero hero v =
  if Vector.norm hero#velocity#get < 20. then
    Gfx.debug "y = %f\n" v.Vector.y;
    if v.Vector.y < 0. && hero#is_grounded#get then (
      Gfx.debug "jump\n";
      hero#is_grounded#set false;
      hero#velocity#set Vector.{ x = 0.; y = -5. }
    )
    else (
      if v.Vector.x <> 0. && hero#is_grounded#get then (
        Gfx.debug "lr\n";
        hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x *. 15.; y = 0. }) 
      )
      else
        hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x; y = 0. })
    )