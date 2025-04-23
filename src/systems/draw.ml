open Ecs
open Component_defs


type t = drawable

let init _ = ()

let white = Gfx.color 255 255 255 255

let render_status_bar ctx surface hl max_hl attack collected_fragments has_key =
  let render_health ctx surface (hlt : int) (max_hlt : int) =
    let full_heart = "❤️" in
    let empty_heart = "💔" in
    let heart_string =
      "HP:" ^ (String.concat ""
        (List.init max_hlt (fun i -> if i < hlt then full_heart else empty_heart)))
    in
    Texture.render_text ctx surface Vector.{ x = 6.; y = 0. }
      Rect.{ width = 100; height = 80 }
      heart_string Texture.white 25
  in
  let render_attack ctx surface (attack : int) =
    let atk = Int.to_string attack in
    Texture.render_text ctx surface Vector.{ x = 32. *. 5. +. 10.; y = 3. }
      Rect.{ width = 100; height = 80 }
      ("ATK:⚔️x" ^ atk) Texture.white 23
  in
  let render_frags ctx surface (nb_collected : int) =
    Texture.render_text ctx surface Vector.{ x = 32. *. 9. +. 10.; y = 3. }
    Rect.{ width = 100; height = 80 }
    ("Collected fragments ("^Int.to_string nb_collected^"/3)") Texture.white 23;
    if nb_collected >= 1 then Texture.draw ctx surface Vector.{ x = 32. *. 19. +. 16.; y = 0. } Rect.{ width=32; height=32 } (let Global.{textures; _} = Global.get () in textures.(14));
    if nb_collected >= 2 then Texture.draw ctx surface Vector.{ x = 32. *. 20. +. 16.; y = 0. } Rect.{ width=32; height=32 } (let Global.{textures; _} = Global.get () in textures.(15));
    if nb_collected >= 3 then Texture.draw ctx surface Vector.{ x = 32. *. 21. +. 16.; y = 0. } Rect.{ width=32; height=32 } (let Global.{textures; _} = Global.get () in textures.(16));
  in
  let render_keys ctx surface (has_key : bool) =
    Texture.draw ctx surface Vector.{ x = 32. *. 23. +. 4.; y = 4. } Rect.{ width=24; height=24 } (let Global.{textures; _} = Global.get () in textures.(8));
    let nb_keys = if has_key then 1 else 0 in
    Texture.render_text ctx surface Vector.{ x = 32. *. 24. +. 4.; y = 3. }
    Rect.{ width = 100; height = 80 }
    (Int.to_string nb_keys) Texture.white 23;
  in
  Texture.draw ctx surface Vector.zero Rect.{ width = Cst.window_width; height = 32 } Texture.dark;
  Texture.draw ctx surface Vector.{ x = 0.; y = 32. } Rect.{ width = Cst.window_width; height = 2 } Texture.light;
  Texture.draw ctx surface Vector.{ x = 32. *. 5.; y = 0. } Rect.{ width = 2; height = 32 } Texture.light;
  Texture.draw ctx surface Vector.{ x = 32. *. 9.; y = 0. } Rect.{ width = 2; height = 32 } Texture.light;
  Texture.draw ctx surface Vector.{ x = 32. *. 23.; y = 0. } Rect.{ width = 2; height = 32 } Texture.light;
  render_health ctx surface hl max_hl;
  render_attack ctx surface attack;
  render_frags ctx surface collected_fragments;
  render_keys ctx surface has_key

let update _dt el =
  let Global.{window; ctx; hero; textures; won; restart; pause; started; dead; _} = Global.get () in
  let surface = Gfx.get_surface window in
  let ww, wh = Gfx.get_context_logical_size ctx in
  if started then (
    if not won then (
      if not dead then (
        if not pause then (
          Texture.draw ctx surface Vector.zero Rect.{ width=ww; height=wh } textures.(2);
          Seq.iter (fun (e:t) ->
            let pos = e#position#get in
            let box = e#box#get in
            let txt = e#texture#get in
            Texture.draw ctx surface pos box txt
          ) el;
          let hlt, max_hlt, attack, nb_frags, has_key = (match hero with
          | Some h -> h#health#get, h#max_health#get, h#attack#get, h#collected_frags#get, h#has_key#get
          | None -> 1, 1, 1, 0, false) in
          render_status_bar ctx surface hlt max_hlt attack nb_frags has_key;
          Gfx.commit ctx
        )
        else (
          Pause_screen.draw ctx window
        )
      )
      else (
        Game_over_screen.draw ctx window
      )
    )
    else (
      if restart then (
        Global.reset ();
        Start_screen.draw ctx window
      )
      else (
        You_win_screen.draw ctx window
      )
    )
  )
  else (
    Start_screen.draw ctx window
  )