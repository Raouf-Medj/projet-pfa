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
      Gravitate_system.(unregister (e :> t));
      Draw_system.(unregister (s :> t));
      Collision_system.(unregister (s :> t))

    | _ -> ()
  );
  let global = Global.get () in
  Global.set global;
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  e