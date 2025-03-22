open System_defs

type t = string array

let reset () =
  Gravitate_system.reset ();
  Collision_system.reset ();
  Draw_system.reset ();
  Move_system.reset ()

let find_platform_boundaries scene i j =
  let left = ref j in
  let right = ref j in
  let row_length = String.length scene.(i) in
  let height = Array.length scene in

  (* Vérifie si c'est un mur ou du sol *)
  let is_wall c = (c = 'B') in

  (* Vérifie si l'ennemi peut marcher sur la case *)
  let is_safe_ground i j =
    i + 1 < height && scene.(i + 1).[j] = 'B'  (* Vérifie que sous la case actuelle il y a du sol *)
  in

  (* Recherche vers la gauche *)
  while !left > 0 && not (is_wall scene.(i).[!left - 1]) && is_safe_ground i (!left - 1) do
    decr left
  done;

  (* Recherche vers la droite *)
  while !right < row_length - 1 && not (is_wall scene.(i).[!right + 1]) && is_safe_ground i (!right + 1) do
    incr right
  done;

  (* Retourne les coordonnées en pixels *)
  (float_of_int !left *. 32., float_of_int (!right + 1) *. 32.)

let load scene_index =
  let global = Global.get () in
  let scene = global.scenes.(scene_index) in
  for i = 0 to Array.length scene - 1 do
    let row = scene.(i) in
    for j = 0 to String.length row - 1 do
      let c = row.[j] in
      if c = 'B' then
        let _ = Barrier.barrier (j * 32, i * 32, Texture.blue, 32, 32) in
        ()
      else if c = 'R' then
        let _ = Barrel.barrel (j * 32) (i * 32) in
        ()
      else if c = 'G' then
        let _ = Gate.gate (j * 32) (i * 32) false in
        ()
      else if c = 'g' then
        let _ = Gate.gate (j * 32) (i * 32) true in
        ()
      else if c = 'K' then
        let _ = Key.key (j * 32) (i * 32) in
        ()
      else if c = 'S' then
        let hero = Some (Hero.hero (j * 32) (i * 32)) in
        global.hero <- hero;
        Global.set global
      else if c = 'P' then
        let platform_left, platform_right = find_platform_boundaries scene i j in
        let _ = Threat.threat (j * 32, i * 32 + 16, 32, 16, 0) ~platform_left ~platform_right () in
        ()
      else if c = 'p' then
        let _ = Threat.threat (j * 32, i * 32 + 16, 32, 16, 1) () in
        ()
      else if c = 'H' then 
        let _ = Potion.potion (j * 32, i * 32 + 16, 32, 16, 0) in
        ()
    done
  done
  
let update_scene () =
  let global = Global.get() in
  if global.load_next_scene || global.restart then (
    reset ();
    if global.restart then (
      global.restart <- false;
    )
    else (
      global.load_next_scene <- false;
      global.current_scene <- global.current_scene + 1
    );
    Global.set global;
    load (global.current_scene)
  )