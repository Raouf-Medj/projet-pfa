open System_defs

type t = string array

let reset () =
  let reset_level_entities () =
    (* Réinitialiser les listes globales ou les systèmes contenant les entités spécifiques au niveau *)
    Threat.darkies := [];
    Boss.bosss := None;
    FireballTower.towers := [];
  in reset_level_entities ();
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

let load scene_index save_hero_hl save_hero_mhl save_hero_prt save_hero_mprt save_hero_attack save_hero_nb_frags save_hero_has_key =
  let global = Global.get () in
  let scene = global.scenes.(scene_index) in
  for i = 0 to Array.length scene - 1 do
    let row = scene.(i) in
    for j = 0 to String.length row - 1 do
      let c = row.[j] in
      if c = 'B' then
        let _ = Barrier.barrier (j * 32, i * 32, Texture.blue, 32, 32) in
        ()
      else if c = 'T' then
          let _ = FireballTower.tower (j * 32, i * 32, Texture.green, 32, 32, false) in
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
        let h = Hero.hero (j * 32) (i * 32) in
        h#health#set save_hero_hl;
        h#max_health#set save_hero_mhl;
        h#max_protection#set save_hero_mprt;
        h#protection#set save_hero_prt;
        h#attack#set save_hero_attack;
        h#collected_frags#set save_hero_nb_frags;
        h#has_key#set save_hero_has_key;
        global.hero <- Some (h);
        Global.set global
      else if c = 'P' then
        let _ = Threat.threat (j * 32, i * 32 + 16, 32, 16, 1) () in
        ()
      else if c = 'F' then
        let _ = Threat.threat (j * 32, i * 32 + 16, 32, 16, 11) () in
        ()
      else if c = 'p' then
        let platform_left, platform_right = find_platform_boundaries scene i j in
        let _ = Threat.threat (j * 32, i * 32 + 16, 32, 16, 0) ~platform_left ~platform_right () in
        ()
      else if c = 'f' then
        let platform_left, platform_right = find_platform_boundaries scene i j in
        let _ = Threat.threat (j * 32, i * 32 + 16, 32, 16, 2) ~platform_left ~platform_right () in
        ()
      else if c = 'H' then 
        let _ = Potion.potion (j * 32, i * 32 - 16, 24, 24) in
        ()
      else if c = 'h' then
        let _ = Shield.shield (j * 32, i * 32 - 16, 24, 24) in
        ()
      else if c = '0' then (* Eternal sun *)
        let _ = Sun.sun (j * 32, i * 32 - 32*3, 128, 128, 0) in
        ()
      else if c = '1' then (* Hope fragment *)
        let _ = Sun.sun (j * 32, i * 32 - 32, 64, 64, 1) in
        ()
      else if c = '2' then (* Power fragment *)
        let _ = Sun.sun (j * 32, i * 32 - 32, 64, 64, 2) in
        ()
      else if c = '3' then (* Wisdom fragment *)
        let _ = Sun.sun (j * 32, i * 32 - 32, 64, 64, 3) in
        ()
      else if c = 'X' then 
        let platform_left, platform_right = find_platform_boundaries scene i j in
        let _ = FireballTower.tower (j * 32, i * 32, Texture.green, 0, 0, true) in 
        let _ = Boss.boss (j * 32, i * 32 , 32, 32) ~platform_left ~platform_right () in 
      ()
    done
  done
  
let update_scene () =
  let global = Global.get() in
  if not global.won then (
    if global.started then (
      if not global.pause then (
        if global.load_next_scene || global.restart then (
          let save_hero_hl, save_hero_mhl, save_hero_prt, save_hero_mprt, save_hero_attack, save_hero_nb_frags, save_hero_has_key = match global.hero with
            | Some h -> h#health#get, h#max_health#get, h#protection#get, h#max_protection#get, h#attack#get, h#collected_frags#get, h#has_key#get 
            | None -> 1, 1, 1, 1, 1, 0, false
          in
          reset ();
          if global.restart then (
            global.restart <- false;
            global.current_scene <- 0;
            Global.set global;
            load global.current_scene 1 1 1 1 1 0 false
          )
          else (
            global.load_next_scene <- false;
            global.current_scene <- global.current_scene + 1;
            Global.set global;
            load global.current_scene save_hero_hl save_hero_mhl save_hero_prt save_hero_mprt save_hero_attack save_hero_nb_frags save_hero_has_key
          );
        )
      )
    )
  )
  else (
    reset ()
  )
