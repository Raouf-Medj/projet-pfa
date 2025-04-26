open Component_defs
open System_defs

type tag += PlayerProjectile of projectile

let projectile (x, y, width, height, txt, direction, attack) =
  let e = new projectile (attack) in
  e#texture#set txt;
  e#position#set Vector.{x; y};
  e#tag#set (PlayerProjectile e);
  e#box#set Rect.{width; height};
  let dir = [| Cst.up_projectile; Cst.down_projectile; Cst.right_projectile; Cst.left_projectile |] in
  e#velocity#set dir.(direction);
  e#resolve#set (fun n t ->
    match t#tag#get with
    | Barrier.Barrier _ | Barrel.Barrel _ ->
      Draw_system.(unregister (e :> t));
      Collision_system.(unregister (e :> t));
      Move_system.(unregister (e :> t));
      Gravitate_system.(unregister (e :> t));

    | Threat.Darkie s | Threat.Follower s ->
      if s#health#get > attack then s#health#set (s#health#get - attack)
      else (
        Draw_system.(unregister (s :> t));
        Collision_system.(unregister (s :> t));
        Move_system.(unregister (s :> t));
      );
      Draw_system.(unregister (e :> t));
      Collision_system.(unregister (e :> t));
      Move_system.(unregister (e :> t));
      Gravitate_system.(unregister (e :> t));
    | Boss.Boss s ->
        if s#health#get > attack then s#health#set (s#health#get - attack)
        else (
          Draw_system.(unregister (s :> t));
          Collision_system.(unregister (s :> t));
          Move_system.(unregister (s :> t));
          Game_state.set_boss_position s#position#get;
          Boss.bosss := None;
          Boss.killed := true;
        );
        Draw_system.(unregister (e :> t));
        Collision_system.(unregister (e :> t));
        Move_system.(unregister (e :> t));
        Gravitate_system.(unregister (e :> t));

    | _ -> ()
  );
  let global = Global.get () in
  global.last_player_proj_dt <- Sys.time ();
  Global.set global;
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  e