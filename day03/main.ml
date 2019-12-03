open! Base

let _ = Caml.Gc.set {(Caml.Gc.get ()) with
                     Caml.Gc.major_heap_increment = 100;
                     max_overhead = 1000000 }

let input =
  let parse_command part =
    let direction = part.[0] in
    let length = String.drop_prefix part 1 |> Int.of_string in
    direction, length
  in
  Stdio.In_channel.read_lines "input"
  |> List.map ~f:(fun line ->
      String.split ~on:',' line |> List.map ~f:parse_command)

let to_pointpath dirs =
  let len = List.fold dirs  ~init:0 ~f:(fun acc (_, l) -> acc + l) in
  let result = Array.init len ~f:(fun _ -> (0, 0, 0)) in

  let expand_segment (x, y, z) direction length =
    let dx, dy = match direction with
      | 'U' -> 0, 1
      | 'D' -> 0, -1
      | 'R' -> -1, 0
      | 'L' -> 1, 0
      | _ -> failwith "illegal direction"
    in
    for i = 1 to length do
      let point = x + i * dx, y + i * dy, z + i - 1 in
      result.(z + i - 2) <- point;
    done;
    x + length * dx, y + length * dy, z + length
  in
  List.fold dirs ~init:(0, 0, 1)
    ~f:(fun pos (direction, length) -> expand_segment pos direction length)
  |> ignore;
  result

let () =
  let paths =
    let cmp (x, y, z) (v, w, z') =
      match x - v with
      | 0 -> (match y - w with 0 -> z - z' | m -> m)
      | n -> n
    in
    List.map input
      ~f:(fun dirs ->
          let points = to_pointpath dirs in
          Array.sort points ~compare:cmp;
          points)
    |> List.to_array
  in

  let cmp (x, y, _) (v, w, _) =
    match x - v with
    | 0 -> y - w
    | n -> n
  in
  let pi, pj = paths.(0), paths.(1) in
  let ni, nj = Array.length paths.(0), Array.length paths.(1) in
  let rec search i j accum =
    if i >= ni || j >= nj
    then accum
    else match cmp (Array.unsafe_get pi i) (Array.unsafe_get pj j) with
      | 0 ->
        let x, y, z = pi.(i) in
        let _, _, z' = pj.(j) in
        search (i + 1) (j + 1) ((x, y, z + z') :: accum)
      | n when n < 0 -> search (i + 1) j accum
      | _ -> search i (j + 1) accum
  in
  let common_points = search 0 0 [] in

  let find_optimum objective =
    List.min_elt ~compare:objective common_points
    |> (fun x -> Option.value_exn x)
  in

  let objective_part1 (x, y, _) (v, w, _) = abs x + abs y - abs v - abs w in
  find_optimum objective_part1
  |> (fun (x, y, _) -> Stdio.printf "part1: %d\n" (abs (x + y)));

  let objective_part2 (_, _, z1) (_, _, z2) = z1 - z2 in
  find_optimum objective_part2
  |> (fun (_, _, z) -> Stdio.printf "part2: %d\n" z)
