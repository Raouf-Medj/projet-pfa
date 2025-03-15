open Ecs
open Component_defs
open System_defs

type tag += Hero of hero

let hero x y =
  let e = new hero () in
  let Global.{textures; _} = Global.get () in
  e#texture#set textures.(0);
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width = Cst.hero_size; height = Cst.hero_size};
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
      let is_grounded =
        (e#position#get.y +. float Cst.hero_size <= w#position#get.y +. float Cst.barrel_size /. 3.) &&
        (n.y > 0.)
      in
      if is_grounded then e#is_grounded#set true

    | Gate.Gate g ->
      let global = Global.get() in
      global.load_next_scene <- true;
      Global.set global

    | Threat.Spike s ->
      e#health#set (e#health#get - 1);

      let global = Global.get() in
      global.restart <- true;
      Global.set global

    | _ -> ()
  );
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  Gravitate_system.(register (e :> t));
  e

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

let reset_hero_gravity () =
  let global = Global.get() in
  match global.hero with
  | None -> ()
  | Some h -> (
    h#is_grounded#set false;
    global.hero <- Some(h);
    Global.set global
  )

let move_hero hero v spc =
  if Vector.norm hero#velocity#get < Cst.hero_max_velocity then (
    (* Gfx.debug "POS: x = %f, y = %f\n" hero#position#get.Vector.x hero#position#get.Vector.y; *)
    (* Gfx.debug "VEL: x = %f, y = %f\n" hero#velocity#get.Vector.x hero#velocity#get.Vector.y; *)
    if hero#is_grounded#get then (
      if v.Vector.y < 0. then (
        (* hero#is_grounded#set false; *)
        (* Gfx.debug "jump\n"; *)
        if spc then hero#velocity#set Vector.{ x = 0.; y = -. Cst.hero_big_jump }
        else hero#velocity#set Vector.{ x = 0.; y = -. Cst.hero_small_jump }
      )
      else (
        (* Gfx.debug "lr\n"; *)
        hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x *. 20.; y = -. Cst.gravity })
      )
    )
    else
      hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x; y = 0. })
  )