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
    | Wall.HWall w | Wall.VWall (_, w) ->
      let s_pos, s_rect = Rect.mdiff e#position#get e#box#get w#position#get w#box#get in
      let n = Rect.penetration_vector s_pos s_rect in
      e#position#set (Vector.sub e#position#get n);
      e#velocity#set Vector.zero
    | Ball.Ball b ->
      let s_pos, s_rect = Rect.mdiff b#position#get b#box#get e#position#get e#box#get in
      let n = Rect.penetration_vector s_pos s_rect in
      b#position#set (Vector.sub b#position#get n);
      b#velocity#set Vector.zero
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
  player

let stop_player () = 
  let Global.{player; _ } = Global.get () in
  player#velocity#set Vector.zero

let move_player player v = player#velocity#set (Vector.add player#velocity#get v)
  