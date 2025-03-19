open Component_defs
open System_defs

type tag += Potion of potion

let potion (x, y, width, height, typ) =
  let e = new potion () in
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set Texture.green;
    e#tag#set (Potion e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
  e
  