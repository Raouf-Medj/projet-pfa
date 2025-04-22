open Component_defs
open System_defs

type tag += Key of key

let key x y =
  let e = new key () in
  (* e#texture#set Texture.white; *)
  e#texture#set (let Global.{textures; _} = Global.get () in textures.(8));
  e#position#set Vector.{x = float x; y = float y};
  e#tag#set (Key e);
  e#box#set Rect.{width = Cst.key_size; height = Cst.key_size};
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e