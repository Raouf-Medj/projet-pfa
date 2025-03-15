open Ecs
open Component_defs

type t = gravitational

let init _ = ()

let update _ entities =
  Seq.iter (fun e ->
    let vel = e#velocity#get in
    let acc = Vector.{ x = 0.; y = Cst.gravity } in
    e#velocity#set (Vector.add vel acc)
  ) entities
