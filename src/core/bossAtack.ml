open Boss
open Global

type boss = Component_defs.boss
type hero = Component_defs.hero
let shoot (b:boss) (h:hero) = 
  List.iter (fun tower ->  
                  if tower#is_on_boss() then FireballTower.move_tower tower b; FireballTower.shoot_fireballs tower h;) 
            !FireballTower.towers

    
let perform_special_attack (b : boss) (h : hero) =
  (* Générer un nombre aléatoire entre 1 et 10 *)
  let atack = Random.int 10 + 1 in
  match atack with
  | 0| 1| 2  -> Boss.update_boss_rapid_movement b (* Invoquer des ennemis *)
  | 3| 4 ->  Boss.spawn_enemies b  (* Mouvement rapide *)
  | 5| 6 -> shoot b h (* Attaque de feu *)
  | _ -> ()  (* Ne rien faire, cas par défaut *)
