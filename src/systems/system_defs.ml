
open Ecs

module Collision_system = System.Make(Collision)

module Draw_system = System.Make(Draw)

module Move_system = System.Make(Move)

module Gravitate_system = System.Make(Gravitate)

module Animation_system = System.Make(Animation)