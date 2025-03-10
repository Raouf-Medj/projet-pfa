open System_defs

type t = string array

let reset () =
  Gravitate_system.reset ();
  Collision_system.reset ();
  Draw_system.reset ();
  Move_system.reset ()

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
        let _ = Gate.gate (j * 32) (i * 32) in
        ()
      else if c = 'S' then
        let hero = Some (Hero.hero (j * 32) (i * 32)) in
        global.hero <- hero;
        Global.set global
      else if c = 'P' then
        let _ = Threat.threat (j * 32, i * 32 + 16, 32, 16) in
        ()
    done
  done
  