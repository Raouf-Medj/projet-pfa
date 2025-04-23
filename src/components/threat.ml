open Component_defs
open System_defs

type tag += Spike of threat | Darkie of threat | Follower of threat

let darkies = ref []
let followers = ref []


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
  )
  else if typ = 2 then (
    (* Follower logic *)
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set Texture.red;
    e#velocity#set Vector.{x = 0.0; y = 0.0};
    e#set_platform_boundaries platform_left platform_right;
    e#tag#set (Follower e);
    Draw_system.(register (e :> t));
    Move_system.(register (e :> t));
    Collision_system.(register (e :> t));
    followers := e :: !followers  (* Add to the followers list *)
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

  
let update_follower_position (follower : threat) =
  let hero_pos = Game_state.get_hero_position () in
  let follower_pos = follower#position#get in
  let vel = follower#velocity#get in
  let platform_left = follower#get_platform_left in
  let platform_right = follower#get_platform_right in

  (* Vérifier si le héros est sur la même plateforme que le follower *)
  if hero_pos.x >= platform_left && hero_pos.x <= platform_right then (
    (* Le héros est sur la même plateforme, le follower commence à le pourchasser *)
    let direction = Vector.sub hero_pos follower_pos in
    let distance = Vector.norm direction in
    if distance > 0.0 then (
      let normalized_direction = Vector.normalize direction in
      let speed = 1.5 in
      let velocity = Vector.mult speed normalized_direction in
      follower#velocity#set Vector.{ x = velocity.x; y = 0.0 };
      let new_pos = Vector.add follower_pos follower#velocity#get in
      follower#position#set Vector.{ x = new_pos.x; y = follower_pos.y }
    )
  ) else (
    (* Le héros n'est pas sur la même plateforme, le follower agit comme un darkie *)
    let new_pos = Vector.add follower_pos vel in
    follower#position#set new_pos;

    (* Inverser la direction si le follower atteint les bords de la plateforme *)
    let box = follower#box#get in
    if new_pos.x <= platform_left || new_pos.x +. float box.width >= platform_right then (
      follower#velocity#set Vector.{ x = -.vel.x; y = vel.y }
    )
  )