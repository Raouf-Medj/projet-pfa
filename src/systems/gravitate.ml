open Ecs
open Component_defs

type t = gravitational

let init _ = ()

let update _ entities =
  Seq.iter (fun e ->
    let vel = e#velocity#get in
    if Vector.norm vel > 200. then e#velocity#set Vector.{ x = vel.x; y = 200. }
    else (
      (* let ground_lvl = float Cst.window_height -. float Cst.wall_thickness in *)
      let acc = Vector.{ x = 0.; y = 0.3 } in
      e#velocity#set (Vector.add vel acc)
    )
  ) entities
