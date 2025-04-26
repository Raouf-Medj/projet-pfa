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
  mutable won : bool;
  mutable started : bool;
  mutable dead : bool;
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

let start_game () =
  let g = get () in
  g.started <- true;
  set g

let restart_game () =
  let g = get () in
  g.restart <- true;
  g.dead <- false;
  set g

let die () =
  let g = get () in
  g.dead <- true;
  set g

let reset () =
  let g = get () in
  g.hero <- None;
  g.current_scene <- -1;
  g.load_next_scene <- true;
  g.restart <- false;
  g.last_player_proj_dt <- 0.;
  g.pause <- false;
  g.won <- false;
  g.started <- false;
  g.dead <- false;
  set g