open Ecs
open Component_defs

type t = movable

let init (_ : float) = ()

let update _ el =
  Seq.iter (fun e ->
    let pos = e#position#get in
    let vel = e#velocity#get in
    (* if Vector.(norm vel) > 10. then Gfx.debug "vel: %f\n" Vector.(norm vel); *)
    e#position#set (Vector.add pos vel)
  ) el