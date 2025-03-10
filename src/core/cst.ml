let window_width = 800
let window_height = 640
let up = Vector.{ x = 0.0; y = -1.0 }
let down = Vector.{ x = 0.0; y = 1.0 }
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
let projectile_size = 10
let player_proj_cd = 0.5




let ball_size = 24
let ball_color = Texture.red

let ball_v_offset = window_height / 2 - ball_size / 2
let ball_left_x = 128 + ball_size / 2
let ball_right_x = window_width - ball_left_x - ball_size

let wall_thickness = 32

let hwall_width = window_width
let hwall_height = wall_thickness
let hwall1_x = 0
let hwall1_y = 0
let hwall2_x = 0
let hwall2_y = window_height -  wall_thickness
let hwall_color = Texture.green

let vwall_width = wall_thickness
let vwall_height = window_height - 2 * wall_thickness
let vwall1_x = 0
let vwall1_y = wall_thickness
let vwall2_x = window_width - wall_thickness
let vwall2_y = vwall1_y
let vwall_color = Texture.green

let font_name = if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf"
let font_color = Gfx.color 0 0 0 255
