let draw ctx window =
  Texture.draw ctx (Gfx.get_surface window) Vector.zero Rect.{ width=Cst.window_width; height=Cst.window_height } (let Global.{textures; _} = Global.get () in textures.(17));

  let black = Gfx.color 0 0 0 255 in
  let dark_purple = Gfx.color 97 0 255 255 in
  let dark_blue = Gfx.color 0 74 173 255 in
  let light = Gfx.color 255 255 255 120 in

  Texture.draw ctx (Gfx.get_surface window) Vector.{ x=100.; y=230. } Rect.{ width=600; height=160 } (Texture.Color light);

  let font = Gfx.load_font (if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf") "" 25 in
  let text = "The Eternal Sun has been restored!" in
  let text_width, text_height = Gfx.measure_text text font in
  let text_x = (Cst.window_width / 2) - (text_width / 2) in
  let text_y = (Cst.window_height / 2) - (text_height / 2) - 50 in
  Gfx.set_color ctx dark_purple;
  let text_surface = Gfx.render_text ctx text font in
  Gfx.blit ctx (Gfx.get_surface window) text_surface text_x text_y;

  let font = Gfx.load_font (if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf") "" 15 in
  let text = "Thanks for playing! Your score is " ^ string_of_int (Global.get_score ()) in  let text_width, text_height = Gfx.measure_text text font in
  let text_x = (Cst.window_width / 2) - (text_width / 2) in
  let text_y = (Cst.window_height / 2) - (text_height / 2) - 20 in
  Gfx.set_color ctx dark_blue;
  let text_surface = Gfx.render_text ctx text font in
  Gfx.blit ctx (Gfx.get_surface window) text_surface text_x text_y;

  let font = Gfx.load_font (if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf") "" 15 in
  let instructions = "Press [ESC] to go back to the start screen" in
  let instr_width, instr_height = Gfx.measure_text instructions font in
  let instr_x = (Cst.window_width / 2) - (instr_width / 2) in
  let instr_y = (Cst.window_height / 2) + 20 in
  Gfx.set_color ctx black;
  let instr_surface = Gfx.render_text ctx instructions font in
  Gfx.blit ctx (Gfx.get_surface window) instr_surface instr_x instr_y;

  if Global.is_high_score (Global.get_score ()) then
    let font = Gfx.load_font (if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf") "" 25 in
    let text = "New High Score!" in
    let text_width, text_height = Gfx.measure_text text font in
    let text_x = (Cst.window_width / 2) - (text_width / 2) in
    let text_y = (Cst.window_height / 2) - (text_height / 2) + 10 in
    Gfx.set_color ctx dark_purple;
    let text_surface = Gfx.render_text ctx text font in
    Gfx.blit ctx (Gfx.get_surface window) text_surface text_x text_y;
    
  Gfx.commit ctx