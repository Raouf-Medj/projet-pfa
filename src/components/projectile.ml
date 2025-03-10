open Component_defs
open System_defs

type tag += PlayerProjectile of projectile

let projectile (x, y, width, height, direction) =
  let e = new projectile () in
  e#texture#set Texture.purple;
  e#position#set Vector.{x = float x; y = float y};
  let dir = [| Cst.up_projectile; Cst.down_projectile; Cst.right_projectile; Cst.left_projectile |] in
  e#velocity#set dir.(direction);
  e#tag#set (PlayerProjectile e);
  e#box#set Rect.{width; height};
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  e