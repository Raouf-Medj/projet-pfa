let window_r = ref None

let window () = match !window_r with Some w -> w | None -> failwith "Uninitialized window"

let init str =
  let w = Gfx.create str in
  window_r := Some w



let scoring_r = ref 0

let set_scoring n = scoring_r := n
let scoring () = !scoring_r