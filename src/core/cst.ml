let window_width = 800
let window_height = 640
let logo_width = 353
let logo_height = 242
let logo_x = float (window_width / 2 - logo_width / 2)
let logo_y = float (window_height / 2 - logo_height / 2 - 70)
let up = Vector.{ x = 0.0; y = -1.0 }
let right = Vector.{ x = 0.2; y = 0.0 }
let left = Vector.{ x = -0.2; y = 0.0 }
let up_projectile = Vector.{ x = 0.0; y = -15.0 }
let down_projectile = Vector.{ x = 0.0; y = 15.0 }
let right_projectile = Vector.{ x = 15.0; y = 0.0 }
let left_projectile = Vector.{ x = -15.0; y = 0.0 }
let hero_size = 32
let hero_small_jump = 5.0
let hero_big_jump = 6.5
let barrel_size = 32
let gate_size = 32
let key_size = 20
let projectile_size = 10
let player_proj_cd = 0.5
let gravity = 0.3
let hero_max_velocity = 10.