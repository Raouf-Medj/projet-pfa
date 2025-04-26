open Component_defs
open System_defs

type tag += Barrier of barrier

let barrier (x, y, txt, width, height) =
  let e = new barrier () in
  e#texture#set (let Global.{textures; _} = Global.get () in textures.(1));
  e#position#set Vector.{x = float x; y = float y};
  e#tag#set (Barrier e);
  e#box#set Rect.{width; height};
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e