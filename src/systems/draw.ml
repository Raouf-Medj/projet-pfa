open Ecs
open Component_defs


type t = drawable

let init _ = ()

let white = Gfx.color 255 255 255 255

let render_health ctx surface (hlt : int) (max_hlt : int) =
  let full_heart = "❤️" in
  let empty_heart = "💔" in
  let heart_string =
    String.concat ""
      (List.init max_hlt (fun i -> if i < hlt then full_heart else empty_heart))
  in
  Texture.render_text ctx surface Vector.zero
    Rect.{ width = 100; height = 80 }
    heart_string Texture.blue 25

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
  let hlt, max_hlt = (match hero with
  | Some h -> h#health#get, h#max_health#get
  | None -> failwith "No hero") in
  render_health ctx surface hlt max_hlt;
  Gfx.commit ctx