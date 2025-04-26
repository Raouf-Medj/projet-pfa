open Component_defs
open System_defs

type tag += Trampoline of trampoline

let trampoline x y =
  let e = new trampoline () in
  e#texture#set (let Global.{textures; _} = Global.get () in textures.(34));
  e#position#set Vector.{x = float x; y = float y};
  e#tag#set (Trampoline e);
  e#box#set Rect.{width = 32; height = 8};
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e