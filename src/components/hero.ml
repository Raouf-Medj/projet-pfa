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
      if e#position#get.y < w#position#get.y then e#is_grounded#set true

    | Gate.Gate g ->
      let global = Global.get() in
      global.load_next_scene <- true;
      Global.set global

    | Threat.Spike s ->
      Draw_system.(unregister (e :> t));
      Collision_system.(unregister (e :> t));
      Move_system.(unregister (e :> t));
      Gravitate_system.(unregister (e :> t));

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

let move_hero hero v =
  if Vector.norm hero#velocity#get < 20. then
    Gfx.debug "y = %f\n" v.Vector.y;
    if v.Vector.y < 0. && hero#is_grounded#get then (
      Gfx.debug "jump\n";
      hero#is_grounded#set false;
      hero#velocity#set Vector.{ x = 0.; y = -6. }
    )
    else (
      if v.Vector.x <> 0. && hero#is_grounded#get then (
        Gfx.debug "lr\n";
        hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x *. 15.; y = 0. }) 
      )
      else
        hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x; y = 0. })
    )