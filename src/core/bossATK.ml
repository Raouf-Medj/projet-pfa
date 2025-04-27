open Component_defs

(* We had to put this aside because of dependency cycles *)
let perform_special_attack (b : boss) (h : hero) =
  let atk = Random.int 10 in
  match atk with
  | 0 | 1 | 2  -> Boss.update_boss_rapid_movement b
  | 3 | 4 ->  Boss.spawn_enemies b
  | 5 | 6 -> FireballTower.shoot b h
  | _ -> ()