(*type animation = {
  frames : Texture.t array;  (* Tableau des textures pour l'animation *)
  frame_count : int;         (* Nombre total de frames *)
  frame_duration : float;    (* Durée d'une frame en secondes *)
  mutable current_frame : int; (* Frame actuelle *)
  mutable elapsed_time : float; (* Temps écoulé depuis la dernière frame *)
}

type t = {
  mutable current_animation : string;  (* Nom de l'animation actuelle *)
  animations : (string, animation) Hashtbl.t;  (* Table des animations *)
}

let create () = {
  current_animation = "idle";
  animations = Hashtbl.create 10;
}

let add_animation anim_table name frames frame_duration =
  let animation = {
    frames;
    frame_count = Array.length frames;
    frame_duration;
    current_frame = 0;
    elapsed_time = 0.0;
  } in
  Hashtbl.add anim_table name animation

let update_animation anim dt =
  let current = Hashtbl.find anim.animations anim.current_animation in
  current.elapsed_time <- current.elapsed_time +. dt;
  if current.elapsed_time >= current.frame_duration then (
    current.elapsed_time <- 0.0;
    current.current_frame <- (current.current_frame + 1) mod current.frame_count
  )

let get_current_frame anim =
  let current = Hashtbl.find anim.animations anim.current_animation in
  current.frames.(current.current_frame)*)