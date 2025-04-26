(*open Tsdl_mixer

let init () =
  if Mix.init Mix.Init.mp3 = 0 then
    failwith "Failed to initialize SDL_mixer";
  if Mix.open_audio 44100 Mix.default_format 2 2048 <> 0 then
    failwith "Failed to open audio"

let load_music path =
  match Mix.load_music path with
  | None -> failwith ("Failed to load music: " ^ path)
  | Some music -> music

let play_music music =
  if Mix.play_music music ~loops:(-1) <> 0 then
    failwith "Failed to play music"

let stop_music () =
  Mix.halt_music ()*)