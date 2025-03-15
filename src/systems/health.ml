open Ecs
open Component_defs
open System_defs

type t = killable

let init _ = ()

let update _ entities =
  Seq.iter (fun e ->
    let hlt = e#health#get in
    if hlt = 0 then (
      Draw_system.(unregister (e :> t));
      Collision_system.(unregister (e :> t));
      Move_system.(unregister (e :> t));
      Gravitate_system.(unregister (e :> t));
    )
  ) entities
