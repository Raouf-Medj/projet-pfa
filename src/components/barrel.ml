open Ecs
open Component_defs
open System_defs

type tag += Barrel of barrel

let barrel x y =
  let e = new barrel () in
  e#texture#set Texture.yellow;
  (* let Global.{textures; _} = Global.get () in
  e#texture#set textures.(0); *)
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width = Cst.barrel_size; height = Cst.barrel_size};
  e#velocity#set Vector.zero;
  e#tag#set (Barrel e);
  e#resolve#set (fun n t ->
    match t#tag#get with
    | Barrier.Barrier w ->
      let s_pos, s_rect = Rect.mdiff e#position#get e#box#get w#position#get w#box#get in
      let n = Rect.penetration_vector s_pos s_rect in
      e#position#set (Vector.sub e#position#get n);
      e#velocity#set Vector.zero;
      if n.y > 0. then e#is_grounded#set true
    | Hero.Hero h ->
      let s_pos, s_rect = Rect.mdiff e#position#get e#box#get h#position#get h#box#get in
      let n = Rect.penetration_vector s_pos s_rect in
      let is_on_top = n.y < 0. in
      if not is_on_top then (
        e#position#set (Vector.sub e#position#get n);
        e#velocity#set Vector.zero
      )
      else (
        h#is_grounded#set true;
        h#position#set (Vector.add h#position#get n);
        h#velocity#set Vector.zero
      )
    | Barrel h ->
      let s_pos, s_rect = Rect.mdiff e#position#get e#box#get h#position#get h#box#get in
      let n = Rect.penetration_vector s_pos s_rect in
      e#position#set (Vector.sub e#position#get n);
      e#velocity#set Vector.zero
    | Threat.Spike t -> 
      let vel = t#velocity#get in
      t#velocity#set Vector.{x = -.vel.x; y = vel.y}
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