(* filepath: /home/zieir/pfaGame/projet-pfa/src/core/button.ml *)
(*
type button = {
  x : int; (* X position *)
  y : int; (* Y position *)
  width : int; (* Width of the button *)
  height : int; (* Height of the button *)
  label : string; (* Text displayed on the button *)
  on_click : unit -> unit; (* Function to execute when clicked *)
}

let create_button ~x ~y ~width ~height ~label ~on_click =
  { x; y; width; height; label; on_click }

let is_inside button mx my =
  mx >= button.x && mx <= button.x + button.width &&
  my >= button.y && my <= button.y + button.height

let handle_click buttons mx my =
  List.iter (fun button ->
    if is_inside button mx my then button.on_click ()
  ) buttons

let render_button window button =
  let ctx = Gfx.get_context window in 
  (* Dessiner le fond du bouton *)
  (* Dessiner le rectangle du bouton *)
  Texture.draw ctx
    Gfx.get_surface window (* Utilisez directement la fenêtre *)
    Vector.{ x = float_of_int button.x; y = float_of_int button.y }
    Rect.{ width = button.width; height = button.height }
    (Texture.Color Texture.blue);

  (* Dessiner le texte du bouton *)
  Texture.render_text window
    window (* Utilisez directement la fenêtre *)
    Vector.{ x = float_of_int (button.x + 10); y = float_of_int (button.y + 10) }
    Rect.{ width = button.width - 20; height = button.height - 20 }
    button.label
    Texture.white
    20

let render_buttons ctx buttons =
  List.iter (render_button ctx) buttons
let render_buttons ctx buttons =
  List.iter (render_button ctx) buttons   *)