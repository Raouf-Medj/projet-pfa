open Component_defs
open System_defs

type tag += Spike of threat | Darkie of threat

let spikes = ref []

let threat (x, y, width, height, typ, platform_left, platform_right) =
  let e = new threat () in
  if typ = 0 then (
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set Texture.red;
    e#velocity#set Vector.{x = 1.0; y = 0.0};
    e#set_platform_boundaries platform_left platform_right;
    e#tag#set (Spike e);
    Draw_system.(register (e :> t));
    Move_system.(register (e :> t));
    Collision_system.(register (e :> t));
    spikes := e :: !spikes  (* Add spike to the list *)
  )
  else if typ = 1 then (
    (* e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set Texture.red;
    e#tag#set (Darkie e);
    Draw_system.(register (e :> t)) *)
  );
  e

let update_spike_position (spike :threat) =
  let pos = spike#position#get in
  let vel = spike#velocity#get in
  let new_pos = Vector.add pos vel in
  spike#position#set new_pos;
  (* Reverse direction if spike reaches edge of platform *)
  let box = spike#box#get in
  let platform_left = spike#get_platform_left in
  let platform_right = spike#get_platform_right in
  if new_pos.x <= platform_left || new_pos.x +. float box.width >= platform_right then
    spike#velocity#set Vector.{x = -.vel.x; y = vel.y}