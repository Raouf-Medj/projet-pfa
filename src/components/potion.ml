open Component_defs
open System_defs

type tag += Potion of potion

let potion (x, y, width, height) =
  let e = new potion () in
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set (let Global.{textures; _} = Global.get () in textures.(10));
    e#tag#set (Potion e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
  e
  