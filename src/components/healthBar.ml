open Component_defs
open System_defs

type tag += Bar of healthBar

let healthBar (x, y, txt, width, height, max_health) =
    let e = new healthBar () in
    e#texture#set Texture.green;
    e#position#set Vector.{x = float x; y = float y};
    e#velocity#set Vector.{x = 1.0; y = 0.0};
    e#tag#set (Bar e);
    e#box#set Rect.{width; height};
    e#max_health#set max_health;
    e#health#set max_health;
    Draw_system.(register (e :> t));
    Move_system.(register (e :> t));
    e
  
let move_health (e : healthBar) (b : threat) =
  let b_pos = b#position#get in
  let h_pos = e#position#get in
  if h_pos.x <=  b_pos.x -. 0.2 || h_pos.x >=  b_pos.x -. 0.2 then (
    e#velocity#set b#velocity#get;
    e#position#set b_pos;
  ) else (
    e#velocity#set Vector.zero;
  )

let update_health_bar_width (e : healthBar) =
  let max_health = e#max_health#get in
  let current_health = e#health#get - 1 in
  let original_width = (e#box#get).width in
  let new_width = (float_of_int current_health /. float_of_int max_health) *. (float_of_int original_width) in
  Draw_system.(unregister (e :> t));
  e#box#set Rect.{ width = int_of_float new_width; height = (e#box#get).height };
  Draw_system.(register (e :> t))