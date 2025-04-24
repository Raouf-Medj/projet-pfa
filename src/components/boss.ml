open Component_defs
open System_defs

type tag += Boss of boss

let boss (x, y, width, height, platform_list) ?(platform_left = 0.0) ?(platform_right = 0.0) ()=
  let e = new boss() in
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#texture#set (let Global.{textures; _} = Global.get () in textures.(11));
  e#velocity#set Vector.{x = 1.0; y = 0.0};
  e#set_platform_boundaries platform_left platform_right;
  e#tag#set (Boss e);
  Draw_system.(register (e :> t));
  Move_system.(register (e :> t));
  Collision_system.(register (e :> t));
