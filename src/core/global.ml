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
  mutable boss : boss option;
  mutable boss_tower : tower option;
  mutable last_special_attack_time : float;
  mutable last_time_shot : float;
  mutable score : int;
}

let state = ref None
let highscore = ref 0

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s

let set s = state := Some s

let is_high_score s =
    s > !highscore
let set_high_score s =
  let g = get () in
  highscore := s;
  g.score <- s;
  set g

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
  highscore := g.score;
  set g

let die () =
  let g = get () in
  g.dead <- true;
  highscore := g.score;
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
  g.score <- 0;
  set g

let get_hero_position () =
  let g = get () in match g.hero with
  | None -> Vector.zero
  | Some h -> h#position#get

let set_hero_position pos =
  let g = get () in match g.hero with
  | None -> ()
  | Some h -> (
      h#position#set pos;
      g.hero <- Some h;
      set g
    )

let set_boss_position pos =
  let g = get () in match g.boss with
  | None -> ()
  | Some h -> (
      h#position#set pos;
      g.boss <- Some h;
      set g
    )

let get_boss_position () =
  let g = get () in match g.boss with
  | None -> Vector.zero
  | Some b -> b#position#get

let set_boss_health h =
  let g = get () in match g.boss with
  | None -> ()
  | Some b -> (
      b#health#set h;
      g.boss <- Some b;
      set g
    )

let get_boss_health () =
  let g = get () in match g.boss with
  | None -> 0
  | Some b -> b#health#get

let get_score () =
  let g = get () in
  g.score
let add_score s =
  let g = get () in
  g.score <- g.score + s;
  set g
