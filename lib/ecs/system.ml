module type S = sig
  type t
  (**  the type of values accepted by the system *)

  val init : float -> unit
  (* initializes the system. The float argument is the current time in nanoseconds. *)

  val update : float -> unit
  (* updates the system. The float argument is the current time in nanoseconds *)

  val register : t -> unit
  (* register an entity for this system *)

  val unregister : t -> unit
  (* remove an entity from this system *)
end

module Make (T : sig
    type t

    val init : float -> unit
    val update : float -> t Seq.t -> unit
  end) : S with type t = T.t = struct
  type t = T.t

  let elem_table : (t, unit) Hashtbl.t = Hashtbl.create 16
  let register e = Hashtbl.replace elem_table e ()
  let unregister e = Hashtbl.remove elem_table e
  let init dt = T.init dt
  let update dt = T.update dt (Hashtbl.to_seq_keys elem_table)
end

let systems = Queue.create ()
let register m = Queue.add m systems

let init_all dt =
  Queue.iter
    (fun m ->
       let module M = (val m : S) in
       M.init dt)
    systems

let update_all dt =
  Queue.iter
    (fun m ->
       let module M = (val m : S) in
       M.update dt)
    systems
