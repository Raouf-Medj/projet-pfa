open Component_defs
open System_defs

let create id x y w h texture mass =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # texture # set texture;
  box # mass # set mass;
  box # id # set id;
  Draw_system.register (box :> drawable);
  Collision_system.register (box :> collidable);
  Move_system.register (box :> movable);
  Force_system.register (box :> physics);
  box
