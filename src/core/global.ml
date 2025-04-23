open Component_defs

type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  mutable hero : hero option;
  textures : Texture.t array;
  scenes : string array array;
  mutable current_scene : int;
  mutable load_next_scene : bool;
  mutable restart : bool;
  mutable last_player_proj_dt : float;
  mutable pause : bool;
}

let state = ref None

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s

let set s = state := Some s

let toggle_pause () =
  let g = get () in
  g.pause <- not g.pause;
  set g