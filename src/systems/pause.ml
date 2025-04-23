open Ecs

type t = Entity.t  (* Le type t doit être un sous-type de Entity.t *)

let is_paused = ref false  (* Variable mutable pour l'état de pause *)

(* Basculer entre pause et reprise *)
let toggle_pause () =
  is_paused := not !is_paused

(* Vérifier si le jeu est en pause *)
let is_game_paused () = !is_paused

(* Initialisation du système Pause *)
let init (_ : float) = ()  (* Rien à initialiser pour le système Pause *)

(* Mise à jour du système Pause *)
let update _ (_ : t Seq.t) =
  ()  (* Le système Pause ne met pas à jour d'entités *)