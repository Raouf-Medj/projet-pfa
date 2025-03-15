open Ecs
open Component_defs


type t = drawable

let init _ = ()

let white = Gfx.color 255 255 255 255

let update _dt el =
  let Global.{window; ctx; hero; _} = Global.get () in
  let surface = Gfx.get_surface window in
  let ww, wh = Gfx.get_context_logical_size ctx in
  (* Gfx.set_color ctx white;
  Gfx.fill_rect ctx surface 0 0 ww wh; *)
  let Global.{ textures; _ } = Global.get () in
  Texture.draw ctx surface Vector.zero Rect.{width=ww;height=wh} textures.(2);
  Seq.iter (fun (e:t) ->
    let pos = e#position#get in
    let box = e#box#get in
    let txt = e#texture#get in
    Texture.draw ctx surface pos box txt
  ) el;
  let hlt = (match hero with
  | Some h -> h#health#get
  | None -> failwith "No hero") in
  if hlt = 3 then Texture.render_text ctx surface Vector.zero Rect.{width=100;height=80} "❤️❤️❤️" Texture.blue 25
  else if hlt = 2 then Texture.render_text ctx surface Vector.zero Rect.{width=100;height=80} "❤️❤️💔" Texture.blue 25
  else if hlt = 1 then Texture.render_text ctx surface Vector.zero Rect.{width=100;height=80} "❤️💔💔" Texture.blue 25
  else if hlt = 0 then Texture.render_text ctx surface Vector.zero Rect.{width=100;height=80} "💔💔💔" Texture.blue 25;
  Gfx.commit ctx