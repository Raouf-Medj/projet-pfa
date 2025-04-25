open Ecs
open Component_defs
open System_defs

type tag += Hero of hero

let hero x y =
  let e = new hero () in
  let Global.{textures; _} = Global.get () in
  if (e#protection#get > 0 ) then e#texture#set textures.(0)
  else e#texture#set textures.(30);
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width = Cst.hero_size; height = Cst.hero_size};
  e#damage_cooldown#set 2.;
  e#tag#set (Hero e);

  e#resolve#set (fun n t ->
    match t#tag#get with
    | Barrier.Barrier w ->
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
      if g#is_locked#get then
        if e#has_key#get then (
          g#unlock;
          e#use_key
        ) else (
          let s_pos, s_rect = Rect.mdiff e#position#get e#box#get g#position#get g#box#get in
          let n = Rect.penetration_vector s_pos s_rect in
          e#position#set (Vector.sub e#position#get n);
          e#velocity#set Vector.zero;
          let is_grounded =
            (e#position#get.y +. float Cst.hero_size <= g#position#get.y +. float Cst.barrel_size /. 3.) &&
            (n.y > 0.)
          in
          if is_grounded then e#is_grounded#set true
        )
      else
        let global = Global.get() in
        global.load_next_scene <- true;
        Global.set global

    | Key.Key k ->
      e#collect_key;
      k#position#set Vector.{ x = -1000.; y = -1000. };
      Draw_system.(unregister (k :> t));
      Collision_system.(unregister (k :> t));

    | Threat.Darkie s | Threat.Spike s | Threat.Follower s ->
      if e#damage_cooldown#get <= 0. then (
        if e#protection#get > 0 then e#protection#set (e#protection#get - 1)
        else if e#health#get > 1 then e#health#set (e#health#get - 1)
        else (
          Draw_system.(unregister (e :> t));
          Collision_system.(unregister (e :> t));
          Move_system.(unregister (e :> t));
          Gravitate_system.(unregister (e :> t));
          Global.die ()
        );
        e#damage_cooldown#set 60.;
      )
    |Boss.Boss s ->
      if e#damage_cooldown#get <= 0. then (
        if e#protection#get > 0 then e#protection#set (e#protection#get - 1)
        else if e#health#get > 1 then e#health#set (e#health#get - 1)
        else (
          Draw_system.(unregister (e :> t));
          Collision_system.(unregister (e :> t));
          Move_system.(unregister (e :> t));
          Gravitate_system.(unregister (e :> t));
          Global.die ()
        );
        e#damage_cooldown#set 60.;
      )
    | Potion.Potion s ->
      if e#health#get < e#max_health#get then e#health#set (e#health#get + 1);
      s#position#set Vector.{ x = -1000.; y = -1000. };
      Draw_system.(unregister (s :> t));
      Collision_system.(unregister (s :> t));
      let global = Global.get() in
      global.restart <- false;
      Global.set global
    | Shield.Shield s ->
      if e#protection#get < e#max_protection#get then e#protection#set (e#protection#get + 1);
      s#position#set Vector.{ x = -1000.; y = -1000. };
      Draw_system.(unregister (s :> t));
      Collision_system.(unregister (s :> t));
      let global = Global.get() in
      global.restart <- false;
      Global.set global
      
    | Sun.Hope s ->
      e#max_health#set (e#max_health#get + 1);
      e#health#set (e#health#get + 1);
      e#collected_frags#set 1;
      Draw_system.(unregister (s :> t));
      Collision_system.(unregister (s :> t));

    | Sun.Power s ->
      e#attack#set (e#attack#get + 1);
      e#collected_frags#set 2;
      Draw_system.(unregister (s :> t));
      Collision_system.(unregister (s :> t));
      
    | Sun.Wisdom s ->
      e#max_health#set (e#max_health#get + 1);
      e#health#set (e#health#get + 1);
      e#attack#set (e#attack#get + 1);
      e#collected_frags#set 3;
      Draw_system.(unregister (s :> t));
      Collision_system.(unregister (s :> t));

    | Sun.Eternal s ->
      e#collected_frags#set 4;
      Draw_system.(unregister (s :> t));
      Collision_system.(unregister (s :> t));
      let global = Global.get() in global.won <- true;
      Global.set global (* Game Over. You Win ! *)

    | _ -> ()
  );
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  Gravitate_system.(register (e :> t));
  Animation_system.(register (e :> t)); 
  e

let get_hero () = 
  let Global.{hero; _ } = Global.get () in
  match hero with
  | Some h -> h
  | None -> failwith "hero.ml: No hero"

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
      if hero#is_grounded#get then (
        if v.Vector.y < 0. then (
          if spc then hero#velocity#set Vector.{ x = 0.; y = -. Cst.hero_big_jump }
          else hero#velocity#set Vector.{ x = 0.; y = -. Cst.hero_small_jump }
        ) else (
          hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x *. 20.; y = -. Cst.gravity })
        )
      ) else
        hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x; y = 0. })
    );
    (* Mettre à jour la position du héros dans Game_state *)
    Game_state.set_hero_position hero#position#get

let update_hero_cooldown (hero : hero) =
  if hero#damage_cooldown#get > 0. then
    hero#damage_cooldown#set (hero#damage_cooldown#get -. 1.)