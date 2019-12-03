open! Base

let () =
  let fuel_of_mass mass = mass / 3 - 2 |> max 0 in
  let rec total_fuel_of_mass mass acc =
    match fuel_of_mass mass with
    | 0 -> acc
    | n -> total_fuel_of_mass n (acc + n)
  in
  Stdio.In_channel.fold_lines Stdio.stdin ~init:0
    ~f:(fun total_fuel line -> total_fuel_of_mass (Int.of_string line) total_fuel)
  |> Stdio.printf "%d\n"
