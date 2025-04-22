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
let r = Component.init 3 in
object
  method health = r
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

class type killable =
object
  inherit Entity.t
  inherit health
end

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
    val mutable damage_cooldown = 0.
    method set_damage_cooldown (cooldown : float) : unit = damage_cooldown <- cooldown
    method get_damage_cooldown : float = damage_cooldown
    val mutable has_key = false
    method has_key = has_key
    method collect_key = has_key <- true
    method use_key = has_key <- false
  end

class projectile () =
object
  inherit Entity.t ()
  inherit position ()
  inherit box ()
  inherit tagged ()
  inherit texture ()
  inherit resolver ()
  inherit velocity ()
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
  val mutable locked = true
  method is_locked = locked
  method unlock = locked <- false
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
    val mutable platform_left = 0.0
    val mutable platform_right = 0.0
    method set_platform_boundaries left right =
      platform_left <- left;
      platform_right <- right
    method get_platform_left = platform_left
    method get_platform_right = platform_right
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
  