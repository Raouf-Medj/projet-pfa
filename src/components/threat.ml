open Component_defs
open System_defs

type tag += Spike of threat | Darkie of threat

let darkies = ref []

let threat (x, y, width, height, typ) ?(platform_left = 0.0) ?(platform_right = 0.0) () =
  let e = new threat () in
  if typ = 0 then (
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    (* e#texture#set Texture.red; *)
    e#texture#set (let Global.{textures; _} = Global.get () in textures.(11));
    e#velocity#set Vector.{x = 1.0; y = 0.0};
    e#set_platform_boundaries platform_left platform_right;
    e#tag#set (Darkie e);
    Draw_system.(register (e :> t));
    Move_system.(register (e :> t));
    Collision_system.(register (e :> t));
    darkies := e :: !darkies  (* Add darkie to the list *)
  )
  else if typ = 1 then (
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    (* e#texture#set Texture.red; *)
    e#texture#set (let Global.{textures; _} = Global.get () in textures.(9));
    e#velocity#set Vector.{x = 0.0; y = 0.0};
    e#tag#set (Spike e);
    Draw_system.(register (e :> t));
    Move_system.(register (e :> t));
    Collision_system.(register (e :> t));
  );
e

let update_darkie_position (darkie :threat) =
  let pos = darkie#position#get in
  let vel = darkie#velocity#get in
  let new_pos = Vector.add pos vel in
  darkie#position#set new_pos;
  (* Reverse direction if spike reaches edge of platform *)
  let box = darkie#box#get in
  let platform_left = darkie#get_platform_left in
  let platform_right = darkie#get_platform_right in
  if new_pos.x <= platform_left || new_pos.x +. float box.width >= platform_right then
    darkie#velocity#set Vector.{x = -.vel.x; y = vel.y}