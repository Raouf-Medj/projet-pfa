let high_scores = ref []

let rec take n lst =
  match lst, n with
  | [], _ -> [] (* Si la liste est vide, retourner une liste vide *)
  | _, n when n <= 0 -> [] (* Si n est 0 ou négatif, retourner une liste vide *)
  | x :: xs, n -> x :: take (n - 1) xs (* Ajouter l'élément courant et continuer *)
let add_high_score score =
  high_scores := score :: !high_scores;
  high_scores := List.sort (fun a b -> b - a) !high_scores |> take 5
let get_high_scores () =
  !high_scores

let save_high_scores filename =
  let oc = open_out filename in
  List.iter (fun score -> Printf.fprintf oc "%d\n" score) !high_scores;
  close_out oc

let load_high_scores filename =
  try
    let ic = open_in filename in
    let rec read_scores acc =
      try
        let line = input_line ic in
        read_scores (int_of_string line :: acc)
      with End_of_file -> acc
    in
    high_scores := List.sort (fun a b -> b - a) (read_scores []);
    close_in ic
  with _ ->
    high_scores := [] (* Si le fichier n'existe pas ou est invalide, on initialise une liste vide *)