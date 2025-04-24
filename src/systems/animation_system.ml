(*open Animation
open Component_defs

let animation_components : (drawable, Animation.t) Hashtbl.t = Hashtbl.create 16
let update dt entities =
  List.iter (fun entity ->
    match Hashtbl.find_opt animation_components entity with
    | Some anim_comp ->
        (* Mettre à jour l'animation de l'entité *)
        Animation.update_animation anim_comp dt
    | None -> ()
  ) entities*)