let draw ctx window =
  Gfx.set_color ctx (Gfx.color 32 33 36 50);
  Gfx.fill_rect ctx (Gfx.get_surface window) 0 0 Cst.window_width Cst.window_height;

  let white = Gfx.color 255 255 255 255 in

  let font = Gfx.load_font (if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf") "" 50 in
  let text = "Game Over (:-:)" in
  let text_width, text_height = Gfx.measure_text text font in
  let text_x = (Cst.window_width / 2) - (text_width / 2) in
  let text_y = (Cst.window_height / 2) - (text_height / 2) - 50 in
  Gfx.set_color ctx white;
  let text_surface = Gfx.render_text ctx text font in
  Gfx.blit ctx (Gfx.get_surface window) text_surface text_x text_y;

  let font = Gfx.load_font (if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf") "" 20 in
  let instructions = "Press [ESC] to restart" in
  let instr_width, instr_height = Gfx.measure_text instructions font in
  let instr_x = (Cst.window_width / 2) - (instr_width / 2) in
  let instr_y = (Cst.window_height / 2) + 20 in
  let instr_surface = Gfx.render_text ctx instructions font in
  Gfx.blit ctx (Gfx.get_surface window) instr_surface instr_x instr_y;

  Gfx.commit ctx