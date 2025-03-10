open Component_defs
open System_defs

type tag += Spike of spike

let threat (x, y, width, height) =
  let e = new spike () in
  e#texture#set Texture.red;
  e#position#set Vector.{x = float x; y = float y};
  e#tag#set (Spike e);
  e#box#set Rect.{width; height};
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e