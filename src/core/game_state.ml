open Vector

let hero_position = ref Vector.zero

let set_hero_position pos =
  hero_position := pos

let get_hero_position () =
  !hero_position