open Ecs
open Component_defs

type t = animatableHero

let init _ = ()

let update _ entities =
  Seq.iter (fun (entity : t) ->
    let velocity = entity#velocity#get in
    let armour = entity#protection#get in

    (* Si l'entité est en mouvement, alterner les textures *)
    let current_texture = entity#texture#get in
    let textures = (Global.get ()).textures in
      (*armour*)
      (* Alterner les textures en fonction de la direction *)
    if velocity.x > 0. then
      if current_texture = textures.(24 +6*(1-armour)) then
        entity#texture#set textures.(25 +6*(1-armour))
      else if current_texture = textures.(25 +6*(1-armour)) then
        entity#texture#set textures.(26 +6*(1-armour))
      else
        entity#texture#set textures.(24 +6*(1-armour))
    else if velocity.x < 0. then
      if current_texture = textures.(21 +6*(1-armour)) then
        entity#texture#set textures.(22 +6*(1-armour))
      else if current_texture = textures.(22 +6*(1-armour)) then
        entity#texture#set textures.(23 +6*(1-armour))
      else
        entity#texture#set textures.(21 +6*(1-armour))
    else(
      if (current_texture = textures.(26 +6*(1-armour)) || current_texture = textures.(25 +6*(1-armour))) then entity#texture#set textures.(24 +6*(1-armour)) 
      else if (current_texture = textures.(23 +6*(1-armour)) || current_texture = textures.(22 +6*(1-armour))) then entity#texture#set textures.(21 +6*(1-armour));
    )    
  ) entities