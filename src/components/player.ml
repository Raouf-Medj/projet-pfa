open Ecs
open Component_defs
open System_defs

type tag += Player

let player (name, x, y, txt, width, height) =
  let e = new player name in
  e#texture#set txt;
  e#tag#set Player;
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#velocity#set Vector.zero;
  e#tag#set Player;
  e#resolve#set (fun _ t ->
    match t#tag#get with
    | Barrier.Barrier w ->
      let s_pos, s_rect = Rect.mdiff e#position#get e#box#get w#position#get w#box#get in
      let n = Rect.penetration_vector s_pos s_rect in
      e#position#set (Vector.sub e#position#get n);
      e#velocity#set Vector.zero
    | Hero.Hero h ->
      let s_pos, s_rect = Rect.mdiff e#position#get e#box#get h#position#get h#box#get in
      let n = Rect.penetration_vector s_pos s_rect in
      e#position#set (Vector.sub e#position#get n);
      e#velocity#set Vector.zero
    | _ -> ()
  );
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  Gravitate_system.(register (e :> t));
  e

let init_player () =  
  player  Cst.("player", player_x, player_y, player_color, player_width, player_height)


let get_player () = 
  let Global.{player; _ } = Global.get () in
  match player with
  | Some p -> p
  | None -> failwith "No player"

let stop_player () = 
  let Global.{player; _ } = Global.get () in
  match player with
  | Some p -> p#velocity#set Vector.zero
  | None -> ()

let move_player hero v =
  if Vector.norm hero#velocity#get < 20. then
    Gfx.debug "y = %f\n" v.Vector.y;
    if v.Vector.y < 0. && hero#is_grounded#get then (
      Gfx.debug "jump\n";
      hero#is_grounded#set false;
      hero#velocity#set Vector.{ x = 0.; y = -5. }
    )
    else (
      if v.Vector.x <> 0. && hero#is_grounded#get then (
        Gfx.debug "lr\n";
        hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x *. 15.; y = 0. }) 
      )
      else
        hero#velocity#set (Vector.add hero#velocity#get Vector.{ x = v.x; y = 0. })
    )
  