let draw ctx window =
  (* Dessiner un écran de pause *)
  Gfx.set_color ctx (Gfx.color 0 0 0 200);  (* Fond noir semi-transparent *)
  Gfx.fill_rect ctx (Gfx.get_surface window) 0 0 Cst.window_width Cst.window_height;

  (* Définir une couleur blanche pour le texte *)
  let text_color = Gfx.color 255 255 255 255 in

  (* Afficher le texte "Paused" *)
  let font = Gfx.load_font "Arial" "" 50 in
  let text = "Paused" in
  let text_width, text_height = Gfx.measure_text text font in
  let text_x = (Cst.window_width / 2) - (text_width / 2) in
  let text_y = (Cst.window_height / 2) - (text_height / 2) - 50 in
  Gfx.set_color ctx text_color;  (* Appliquer la couleur blanche *)
  let text_surface = Gfx.render_text ctx text font in
  Gfx.blit ctx (Gfx.get_surface window) text_surface text_x text_y;

  (* Afficher des instructions *)
  let instructions = "Press ESC to resume" in
  let instr_width, instr_height = Gfx.measure_text instructions font in
  let instr_x = (Cst.window_width / 2) - (instr_width / 2) in
  let instr_y = (Cst.window_height / 2) + 20 in
  let instr_surface = Gfx.render_text ctx instructions font in
  Gfx.blit ctx (Gfx.get_surface window) instr_surface instr_x instr_y;

  let quit_text = "Press M to mute" in
  let quit_width, quit_height = Gfx.measure_text quit_text font in
  let quit_x = (Cst.window_width / 2) - (quit_width / 2) in
  let quit_y = (Cst.window_height / 2) + 80 in
  let quit_surface = Gfx.render_text ctx quit_text font in
  Gfx.blit ctx (Gfx.get_surface window) quit_surface quit_x quit_y;

  (* Commit pour afficher les changements *)
  Gfx.commit ctx