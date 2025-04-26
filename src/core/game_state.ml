open Vector

let hero_position = ref Vector.zero
let boss_health = ref 0

let boss_position = ref Vector.zero
let set_boss_position pos =
  boss_position := pos
let get_boss_position () =
  !boss_position


let set_hero_position pos =
  hero_position := pos

let get_hero_position () =
  !hero_position

let set_boss_health h =
  boss_health := h

let get_boss_health () =
  !boss_health
