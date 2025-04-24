open Ecs
class position () =
  let r = Component.init Vector.zero in
  object
    method position = r
  end

class box () =
  let r = Component.init Rect.{width = 0; height = 0} in
  object
    method box = r
  end

class texture () =
  let r = Component.init (Texture.Color (Gfx.color 0 0 0 255)) in
  object
    method texture = r
  end

type tag = ..
type tag += No_tag

class tagged () =
  let r = Component.init No_tag in
  object
    method tag = r
  end

class resolver () =
  let r = Component.init (fun (_ : Vector.t) (_ : tagged) -> ()) in
  object
    method resolve = r
  end

class velocity () =
  let r = Component.init Vector.zero in
  object
    method velocity = r
  end

class grounded () =
  let r = Component.init true in
  object
    method is_grounded = r
  end

class health () =
  let r = Component.init 2 in
  object
    method health = r
  end

class max_health () =
  let r = Component.init 2 in
  object
    method max_health = r
  end

class attack (init : int) =
  let r = Component.init init in
  object
    method attack = r
  end

class damage_cooldown () =
  let r = Component.init 0. in
  object
    method damage_cooldown = r
  end

class has_key () =
  let r = Component.init false in
  object
    method has_key = r
    method collect_key = r#set true
    method use_key = r#set false
  end

class locked () =
  let r = Component.init true in
  object
    method is_locked = r
    method unlock = r#set false
  end

class blocked () =
  let r = Component.init false in
  object
    method is_blocked = r
  end

class collected_frags () =
  let r = Component.init 0 in
  object
    method collected_frags = r
  end

class platform_boundaries () =
  let r = Component.init (0.0, 0.0) in
  object
    method set_platform_boundaries left right = r#set (left, right)
    method get_platform_left = fst (r#get)
    method get_platform_right = snd (r#get)
  end


(** Interfaces : ici on liste simplement les types des classes dont on hérite
    si deux classes définissent les mêmes méthodes, celles de la classe écrite
    après sont utilisées (héritage multiple).
*)

class type collidable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit tagged
    inherit resolver
  end

class type drawable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit texture
  end

class type movable =
  object
    inherit Entity.t
    inherit position
    inherit velocity
  end

class type gravitational =
  object
    inherit Entity.t
    inherit position
    inherit velocity
  end

(*
type animation_record = {
  frames: Texture.t array;
  mutable frame_count: int;
  mutable frame_duration: float;
  mutable current_frame: int;
  mutable elapsed_time: float;
}

class animation = 
  object
    (* Table des animations *)
    val animations = Hashtbl.create 10
    val mutable current_animation = "idle"

    (* Ajouter une animation *)
    method add_animation name frames frame_duration =
      let animation = {
        frames;
        frame_count = Array.length frames;
        frame_duration;
        current_frame = 0;
        elapsed_time = 0.0;
      } in
      Hashtbl.add animations name animation

    (* Mettre à jour l'animation actuelle *)
    method update_animation dt =
      match Hashtbl.find_opt animations current_animation with
      | Some anim ->
          anim.elapsed_time <- anim.elapsed_time +. dt;
          if anim.elapsed_time >= anim.frame_duration then (
            anim.elapsed_time <- 0.0;
            anim.current_frame <- (anim.current_frame + 1) mod anim.frame_count
          )
      | None -> ()

    (* Obtenir la frame actuelle *)
    method get_current_frame =
      match Hashtbl.find_opt animations current_animation with
      | Some anim -> anim.frames.(anim.current_frame)
      | None -> Texture.Color (Gfx.color 0 0 0 255)  (* Retourne une texture par défaut si aucune animation *)

    (* Changer l'animation actuelle *)
    method set_animation name =
      if Hashtbl.mem animations name then current_animation <- name
  end*)
(** Entités :
    Ici, dans inherit, on appelle les constructeurs pour qu'ils initialisent
    leur partie de l'objet, d'où la présence de l'argument ()
*)
class hero () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver ()
    inherit velocity ()
    inherit grounded ()
    inherit health ()
    inherit max_health ()
    inherit attack (1)
    inherit damage_cooldown ()
    inherit has_key ()
    inherit collected_frags ()
    (*inherit animation*)
  end

class projectile (attack) =
object
  inherit Entity.t ()
  inherit position ()
  inherit box ()
  inherit tagged ()
  inherit texture ()
  inherit resolver ()
  inherit velocity ()
  inherit attack (attack)
end

class barrel () =
object
  inherit Entity.t ()
  inherit position ()
  inherit box ()
  inherit tagged ()
  inherit texture ()
  inherit resolver ()
  inherit velocity ()
  inherit grounded ()
  inherit blocked ()
end

class barrier () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver()
  end

class gate () =
object
  inherit Entity.t ()
  inherit position ()
  inherit box ()
  inherit tagged ()
  inherit texture ()
  inherit resolver()
  inherit locked ()
end

class key () =
object
  inherit Entity.t ()
  inherit position ()
  inherit box ()
  inherit resolver()
  inherit tagged ()
  inherit texture ()
end

class threat () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver ()
    inherit velocity ()
    inherit health ()
    inherit max_health ()
    inherit platform_boundaries ()
  end
  
class potion () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver()
  end

class sun () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver()
  end
  