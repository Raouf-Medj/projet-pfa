type t =
  | Image of Gfx.surface
  | Color of Gfx.color

let black = Color (Gfx.color 0 0 0 255)
let dark = Color (Gfx.color 0 0 0 200)
let white = Color (Gfx.color 255 255 255 255)
let light = Color (Gfx.color 255 255 255 128)
let red = Color (Gfx.color 255 0 0 255)
let green = Color (Gfx.color 0 255 0 255)
let blue = Color (Gfx.color 0 0 255 255)
let yellow = Color (Gfx.color 255 255 0 255)
let purple = Color (Gfx.color 255 0 255 255)
let transparent = Color (Gfx.color 0 0 0 0)

let draw ctx dst pos box src =
  let x = int_of_float pos.Vector.x in
  let y = int_of_float pos.Vector.y in
  let Rect.{ width; height } = box in
  match src with
  | Image img -> Gfx.blit_scale ctx dst img x y width height
  | Color c ->
    Gfx.set_color ctx c;
    Gfx.fill_rect ctx dst x y width height

let render_text ctx dst pos box text color size =
  let x = int_of_float pos.Vector.x in
  let y = int_of_float pos.Vector.y in
  match color with Color c ->
    Gfx.set_color ctx c;
    let font = Gfx.load_font (if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf") "" size in
    let text = Gfx.render_text ctx text font in
    Gfx.blit ctx dst text x y
  | _ -> failwith "Texture.ml: Invalid color"