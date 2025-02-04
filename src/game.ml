(* Les types des textures qu'on veut dessiner à l'écran *)
type texture =
    Color of Gfx.color
  | Image of Gfx.surface

let white = Color (Gfx.color 255 255 255 255)
let black = Color (Gfx.color 0 0 0 255)
let red = Color (Gfx.color 255 0 0 255)
let green = Color (Gfx.color 0 255 0 255)
let blue = Color (Gfx.color 0 0 255 255)

(* On crée un type config pour stocker les informations du jeu *)

type config = {
  (* Informations des touches *)
  key_left: string;
  key_up : string;
  key_down : string;
  key_right : string;

  (* Informations de fenêtre *)
  window : Gfx.window;
  window_surface : Gfx.surface;
  ctx : Gfx.context;

  (* Textures *)
  textures : texture array;
  mutable current : int;

  (* Temps *)
  mutable last_dt : float;

  (* Coordonnées *)
  mutable x : int;
  mutable y : int;
}


(* On crée une fenêtre *)

let draw_rect config texture x y w h =
  (* Question 4.2.2 *)
  match texture with
  | Color c ->
    Gfx.set_color config.ctx c;
    Gfx.fill_rect config.ctx config.window_surface x y w h
  | Image img ->
    (* Question 4.3.2 *)
    Gfx.blit_scale config.ctx config.window_surface img x y w h

let keys : (string, unit) Hashtbl.t = Hashtbl.create 16

let update cfg dt =
  (* Question 4.2.3 *)
  (* Gfx.set_color cfg.ctx (Gfx.color 255 255 255 255);
  Gfx.fill_rect cfg.ctx cfg.window_surface 0 0 800 600;
  draw_rect cfg black 100 100 200 200; *)

  (* Question 4.2.5 *)
  let () = 
    match Gfx.poll_event () with
    | Gfx.NoEvent -> ()
    | Gfx.KeyDown k -> Gfx.debug "%s@\n%!" k; Hashtbl.replace keys k ()
    | Gfx.KeyUp k -> Hashtbl.remove keys k
    | Gfx.Quit -> Hashtbl.replace keys "q" ()
    | _ -> ()
  in
  if Hashtbl.mem keys cfg.key_left then cfg.x <- cfg.x - 10;
  if Hashtbl.mem keys cfg.key_right then cfg.x <- cfg.x + 10;
  if Hashtbl.mem keys cfg.key_up then cfg.y <- cfg.y - 10;
  if Hashtbl.mem keys cfg.key_down then cfg.y <- cfg.y + 10;

  (* Question 4.2.4 *)
  Gfx.set_color cfg.ctx (Gfx.color 255 255 255 255);
  Gfx.fill_rect cfg.ctx cfg.window_surface 0 0 800 600;
  draw_rect cfg cfg.textures.(cfg.current) cfg.x cfg.y 200 200;
  if dt -. cfg.last_dt > 1000.0 then begin
    Gfx.debug "%f@\n%!" dt;
    cfg.current <-  (cfg.current + 1) mod Array.length cfg.textures;
    cfg.last_dt <- dt
  end;
  Gfx.commit cfg.ctx;

  (* Question 4.2.4 / 4.2.5 *)
  if (Hashtbl.mem keys "q") then Some () else None


let run keys =
  (* Question 4.2.1 *)
  let window = Gfx.create "game_canvas:800x600:" in
  let window_surface = Gfx.get_surface window in
  let ctx = Gfx.get_context window in
  (* On peut laisser ces deux lignes, mais elle deviendront inutile après la question 1 *)
  (* Gfx.set_color ctx (Gfx.color 0 0 0 255);
  Gfx.fill_rect ctx window_surface 100 100 200 200; *)
 
  (* let cfg = {
    key_left = keys.(0);
    key_right = keys.(1);
    key_up = keys.(2);
    key_down = keys.(3);
    window = window;
    window_surface = window_surface;
    ctx = ctx;
    textures = [| red; green; blue |];
    current = 0;
    last_dt = 0.0;
    x = 100;
    y = 100;
  } in

  Gfx.main_loop (update cfg) (fun () -> ()) *)

  (* Question 4.3.1 *)
  let tile_set_r = Gfx.load_file "resources/files/tile_set.txt" in
  Gfx.main_loop
    (fun _dt -> Gfx.get_resource_opt tile_set_r)
    (fun txt ->
       let images_r =
         txt
         |> String.split_on_char '\n'
         |> List.filter (fun s -> s <> "") (* retire les lignes vides *)
         |> List.map (fun s -> Gfx.load_image ctx ("resources/images/" ^ s))
       in
       Gfx.main_loop (fun _dt ->
           if List.for_all Gfx.resource_ready images_r then
             Some (List.map Gfx.get_resource images_r)
           else None
         )
         (fun images ->
            let textures = images
                           |> List.map (fun img -> Image img)
                           |> Array.of_list
            in

            let cfg = {
              (* Question 4.2.3 *)
              key_left = keys.(0);
              key_right = keys.(1);
              key_up = keys.(2);
              key_down = keys.(3);
              window;
              window_surface;
              ctx;
              (* Question 4.2.4 *)
              last_dt = 0.0;
              textures; (* réutilise textures défini plus haut *)
              current = 0;
              (* Question 4.2.5 *)
              x = 100;
              y = 100;
            }
            in Gfx.main_loop (update cfg) (fun () -> ())
         ))