open Component_defs
open System_defs

type tag += Fireball of fireball

let fireball (x, y, width, height, txt, direction, attack) =
  let e = new fireball (attack) in
  e#texture#set txt;
  e#position#set Vector.{x; y};
  e#tag#set (Fireball e);
  e#box#set Rect.{width; height};
  e#resolve#set (fun n t ->
    match t#tag#get with
    | Hero.Hero s ->
      Draw_system.(unregister (e :> t));
      Collision_system.(unregister (e :> t));
      Move_system.(unregister (e :> t));
      if s#damage_cooldown#get <= 0. then (
        if s#protection#get > 0 then s#protection#set (s#protection#get - 1)
        else if s#health#get > 1 then s#health#set (s#health#get - 1)
        else (
          Draw_system.(unregister (s :> t));
          Collision_system.(unregister (s :> t));
          Move_system.(unregister (s :> t));
          Gravitate_system.(unregister (s :> t));
          Global.die ()
        );
        s#damage_cooldown#set 60.;
      )
      
    | Barrier.Barrier _ | Barrel.Barrel _ ->
      Draw_system.(unregister (e :> t));
      Collision_system.(unregister (e :> t));
      Move_system.(unregister (e :> t));
      
    | _ -> ()
  );
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  e
