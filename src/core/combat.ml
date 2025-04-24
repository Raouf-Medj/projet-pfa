(*open Component_defs
open System_defs

let boss_attack_hero (boss : boss) (hero : hero) =
  if hero#damage_cooldown#get <= 0. then (
    if hero#protection#get > 0 then hero#protection#set (hero#protection#get - 1)
    else if hero#health#get > 1 then hero#health#set (hero#health#get - 1)
    else (
      Draw_system.(unregister (hero :> t));
      Collision_system.(unregister (hero :> t));
      Move_system.(unregister (hero :> t));
      Gravitate_system.(unregister (hero :> t));
      Global.die ()
    );
    hero#damage_cooldown#set 60.;
  )

let hero_attack_boss (hero : hero) (boss : boss) =
  if boss#health#get > 0 then boss#health#set (boss#health#get - hero#attack#get);
  if boss#health#get <= 0 then (
    Draw_system.(unregister (boss :> t));
    Collision_system.(unregister (boss :> t));
    Move_system.(unregister (boss :> t));
    Gravitate_system.(unregister (boss :> t));
  )

let fireball_hit_target (fireball : fireball) (target : #Entity.t) =
  match target#tag#get with
  | Hero.Hero h -> boss_attack_hero (fireball#owner#get : boss) h
  | Boss.Boss b -> hero_attack_boss (fireball#owner#get : hero) b
  | _ -> ()*)