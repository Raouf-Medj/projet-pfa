open Ecs
open Component_defs

type t = movable

let init (_ : float) = ()

let update _ el =
  Seq.iter (fun e ->
    let pos = e#position#get in
    let vel = e#velocity#get in
    e#position#set (Vector.add pos vel)
  ) el