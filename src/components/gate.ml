open Component_defs
open System_defs

type tag += Gate of gate

let gate x y locked =
  let e = new gate () in
  if locked then e#texture#set (let Global.{textures; _} = Global.get () in textures.(12))
  else e#texture#set Texture.black;
  e#position#set Vector.{x = float x; y = float y};
  e#tag#set (Gate e);
  e#box#set Rect.{width = Cst.gate_size; height = Cst.gate_size};
  if (not locked) then (e#unlock);
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e
