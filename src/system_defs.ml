
open Ecs


module Draw_system = System.Make(Draw)
(* Use a functor to define the new system *)

let () = System.register (module Draw_system)
(* Register the system globally *)