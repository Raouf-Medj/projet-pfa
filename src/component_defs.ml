open Ecs

(* Some basic components *)
class position =
  object
    val pos = Component.def Vector.zero
    method pos = pos
  end

class rect =
  object
    val rect = Component.def Rect.{width = 0; height = 0}
    method rect = rect
  end

class velocity =
  object
    val velocity = Component.def Vector.zero
    method velocity = velocity
  end

class texture =
  object
    val texture = Component.def (Texture.color (Gfx.color 0 0 0 0))
    method texture = texture
  end

class id =
  object
    val id = Component.def ("")
    method id = id
  end

class mass =
  object
    val mass = Component.def 0.0
    method mass = mass
  end

class sum_forces =
  object
    val sum_forces = Component.def Vector.zero
    method sum_forces = sum_forces
  end

(* Some complex components *)

class movable =
  object
    inherit position
    inherit velocity
  end

class drawable =
  object
    inherit position
    inherit rect
    inherit texture
  end

class collidable =
  object
    inherit velocity
    inherit position
    inherit rect
    inherit mass
  end

class physics =
  object
    inherit mass
    inherit sum_forces
    inherit velocity
  end

class box =
  object
    inherit drawable
    inherit! collidable
    inherit! physics
    inherit id
  end
