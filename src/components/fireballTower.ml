open Component_defs
open System_defs

type tag += Tower of tower

let towers = ref []

let tower (x, y, txt, width, height) =
  let e = new tower () in
  e#texture#set Texture.green;
  e#position#set Vector.{x = float x; y = float y};
  e#tag#set (Tower e);
  e#box#set Rect.{width; height};
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  towers := e :: !towers;
  e

 
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
      let f = Fireball.fireball
        (tower_pos.x, tower_pos.y, 8, 8, Texture.red, (rotated_direction.x *. 5.0, rotated_direction.y *. 5.0), 1)
      in
      f#velocity#set Vector.{x = rotated_direction.x *. 5.0; y = rotated_direction.y *. 5.0};
    ) angles