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
          let pos = s#position#get in
          let _ = Sun.sun (int_of_float pos.x , int_of_float pos.y - 32*2, 128, 128, 0) in ()
        );
        Draw_system.(unregister (e :> t));
        Collision_system.(unregister (e :> t));
        Move_system.(unregister (e :> t));
        Gravitate_system.(unregister (e :> t));

    | FireballTower.Tower t ->
      if t#health#get > attack then t#health#set (t#health#get - attack)
      else (
        Draw_system.(unregister (t :> t));
        Collision_system.(unregister (t :> t));
        Move_system.(unregister (t :> t));
      );
      Draw_system.(unregister (e :> t));
      Collision_system.(unregister (e :> t));
      Move_system.(unregister (e :> t));
      Gravitate_system.(unregister (e :> t));

    | Fireball.Fireball f ->
      Draw_system.(unregister (f :> t));
      Collision_system.(unregister (f :> t));
      Move_system.(unregister (f :> t));

    | _ -> ()
  );
  let global = Global.get () in
  global.last_player_proj_dt <- Sys.time ();
  Global.set global;
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  e