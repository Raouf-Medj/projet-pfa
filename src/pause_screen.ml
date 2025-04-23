let draw ctx window =
  (* Dessiner un écran de pause *)
  Gfx.set_color ctx (Gfx.color 0 0 0 255);  (* Fond noir *)
  Gfx.fill_rect ctx (Gfx.get_surface window) 0 0 Cst.window_width Cst.window_height;

  (* Afficher le texte "Paused" *)
  let font = Gfx.load_font "Arial" "" 50 in
  let text = "Paused" in
  let text_width, text_height = Gfx.measure_text text font in
  let text_x = (Cst.window_width / 2) - (text_width / 2) in
  let text_y = (Cst.window_height / 2) - (text_height / 2) in
  let text_surface = Gfx.render_text ctx text font in
  Gfx.blit ctx (Gfx.get_surface window) text_surface text_x text_y;

  (* Commit pour afficher les changements *)
  Gfx.commit ctx