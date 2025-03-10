open Component_defs
open System_defs

type tag += Spike of threat | Darkie of threat

let threat (x, y, width, height, typ) =
  let e = new threat () in
  if typ = 0 then (
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set Texture.red;
    e#tag#set (Spike e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t))
  )
  else if typ = 1 then (
    (* e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set Texture.red;
    e#tag#set (Darkie e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t)) *)
  );
  e
  