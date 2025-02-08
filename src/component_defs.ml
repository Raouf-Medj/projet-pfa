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

class color =
  object
    val color = Component.def (Gfx.color 0 0 0 0)
    method color = color
  end

class id =
  object
    val id = Component.def ("")
    method id = id
  end
(* Some complex components *)

class drawable =
  object
    inherit position
    inherit rect
    inherit color
  end
(* Créer un composant box qui regroupe*)