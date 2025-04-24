open Component_defs
open System_defs

type tag += Shield of shield

let shield (x, y, width, height) =
  let e = new shield () in
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set (let Global.{textures; _} = Global.get () in textures.(33));
    e#tag#set (Shield e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
  e
  