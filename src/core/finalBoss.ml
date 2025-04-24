let shoot_fireballs =
  let pos = Game_state.get_boss_position in
  let num_fireballs = 8 in
  let angle_step = 2.0 *. Float.pi /. float_of_int num_fireballs in  (* Diviser 360° (2π radians) en 8 parties *)
  for i = 0 to num_fireballs - 1 do
    let angle = Float.of_int i *. angle_step in  (* Calculer l'angle pour chaque fireball *)
    let direction = Vector.{x = cos angle; y = sin angle} in  (* Calculer la direction à partir de l'angle *)
    let _ = Fireball.fireball
      (pos.x, pos.y, 16, 16, (Global.get ()).textures.(12), direction.x *. 5.0, direction.y *. 5.0)
    in
    ()
  done