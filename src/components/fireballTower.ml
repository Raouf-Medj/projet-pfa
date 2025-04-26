open Component_defs
open System_defs

type tag += Tower of tower

let towers = ref []

let tower (x, y, txt, width, height, is_on_boss) =
  if (not is_on_boss) then (
  let e = new tower () in
    e#texture#set Texture.green;
    e#position#set Vector.{x = float x; y = float y};
    e#velocity#set Vector.zero;
    e#tag#set (Tower e);
    e#box#set Rect.{width; height};
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
    towers := e :: !towers;
    e
  ) else (
    let e = new tower () in
    e#texture#set Texture.green;
    e#position#set Vector.{x = float x; y = float y};
    e#set_is_on_boss ();
    (match !Boss.bosss with
    | Some b ->  e#velocity#set b#velocity#get;
    | None -> ()); 
    e#tag#set (Tower e);
    e#box#set Rect.{width; height};
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
    towers := e :: !towers;
    e
  )
  
let move_tower (e : tower) (b :boss) =
  let b_pos = b#position#get in
  let tower_pos = e#position#get in
  if tower_pos.x <=  b_pos.x -. 0.2 || tower_pos.x >=  b_pos.x -. 0.2 then (
    e#velocity#set b#velocity#get;
    e#position#set b_pos;
  ) else (
    e#velocity#set Vector.zero;
  )
 
let shoot_fireballs (e : tower) (h : hero) =
    let tower_pos = e#position#get in
    let hero_pos = h#position#get in
    
    (* Calculate the direction vector from the tower to the hero *)
    let direction = Vector.{ 
      x = hero_pos.x -. tower_pos.x; 
      y = hero_pos.y -. tower_pos.y 
    } in
    
    (* Normalize the direction vector *)
    let magnitude = sqrt ((direction.x ** 2.0) +. (direction.y ** 2.0)) in
    let normalized_direction = Vector.{ 
      x = direction.x /. magnitude; 
      y = direction.y /. magnitude 
    } in
    
    (* Define angles for the fireballs: center, 20 degrees up, 20 degrees down *)
    let angles = [0.0; 20.0 *. Float.pi /. 180.0; -20.0 *. Float.pi /. 180.0] in
  
    (* Shoot fireballs in the specified directions *)
    List.iter (fun angle_offset ->
      let rotated_direction = Vector.{
        x = normalized_direction.x *. cos angle_offset -. normalized_direction.y *. sin angle_offset;
        y = normalized_direction.x *. sin angle_offset +. normalized_direction.y *. cos angle_offset;
      } in
      let Global.{textures; _} = Global.get () in 
      let f = Fireball.fireball
        (tower_pos.x, tower_pos.y, 8, 8, textures.(36) , (rotated_direction.x *. 5.0, rotated_direction.y *. 5.0), 1)
      in
      f#velocity#set Vector.{x = rotated_direction.x *. 5.0; y = rotated_direction.y *. 5.0};
    ) angles