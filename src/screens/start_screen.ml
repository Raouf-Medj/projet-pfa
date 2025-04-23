let draw ctx window =
  Texture.draw ctx (Gfx.get_surface window) Vector.zero Rect.{ width=Cst.window_width; height=Cst.window_height } (let Global.{textures; _} = Global.get () in textures.(18));

  let white = Gfx.color 255 255 255 255 in

  Texture.draw ctx (Gfx.get_surface window) Vector.{ x=Cst.logo_x; y=Cst.logo_y } Rect.{ width=Cst.logo_width; height=Cst.logo_height } (let Global.{textures; _} = Global.get () in textures.(19));

  let font = Gfx.load_font (if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf") "" 15 in
  let instructions = "Press [ENTER] to start the game" in
  let instr_width, instr_height = Gfx.measure_text instructions font in
  let instr_x = (Cst.window_width / 2) - (instr_width / 2) in
  let instr_y = (Cst.window_height / 2) + 60 in
  Gfx.set_color ctx white;
  let instr_surface = Gfx.render_text ctx instructions font in
  Gfx.blit ctx (Gfx.get_surface window) instr_surface instr_x instr_y;

  Gfx.commit ctx