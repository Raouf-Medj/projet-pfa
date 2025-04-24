open Ecs
open Component_defs

type t = animatable

let init _ = ()

let update _ entities =
  Seq.iter (fun (entity : t) ->
    let velocity = entity#velocity#get in

    (* Si l'entité est en mouvement, alterner les textures *)
    let current_texture = entity#texture#get in
    let textures = (Global.get ()).textures in
      (*armour*)
      (* Alterner les textures en fonction de la direction *)
    if velocity.x > 0. then
      if current_texture = textures.(24) then
        entity#texture#set textures.(25)
      else if current_texture = textures.(25) then
        entity#texture#set textures.(26)
      else
        entity#texture#set textures.(24)
    else if velocity.x < 0. then
      if current_texture = textures.(21) then
        entity#texture#set textures.(22)
      else if current_texture = textures.(22) then
        entity#texture#set textures.(23)
      else
        entity#texture#set textures.(21)
    else(
      if (current_texture = textures.(26) || current_texture = textures.(25)) then entity#texture#set textures.(24)
      else if (current_texture = textures.(23) || current_texture = textures.(22)) then entity#texture#set textures.(21);
    )    
  ) entities