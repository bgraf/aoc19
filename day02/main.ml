open! Base

let perform input pos f =
  let p1 = input.(pos) in
  let p2 = input.(pos + 1) in
  let out = input.(pos + 2) in
  input.(out) <- f input.(p1) input.(p2)

let opfun = function
  | 99 -> None
  | 1 -> Some (+)
  | 2 -> Some ( * )
  | _ -> failwith "unknown opcode"

let run_for input noun verb =
    let input = Array.copy input in
    input.(1) <- noun;
    input.(2) <- verb;
    let rec run input pos =
      match opfun input.(pos) with
      | Some f -> perform input (pos + 1) f; run input (pos + 4)
      | _ -> ()
    in
    run input 0;
    input.(0)

let part1 input =
  run_for input 12 2
  |> Stdio.printf "part1: input(0) = %d\n"

let part2 input =
  let vals = Sequence.init 100 ~f:Fn.id in
  Sequence.cartesian_product vals vals
  |> Sequence.find ~f:(fun (noun, verb) -> run_for input noun verb = 19690720)
  |> Option.iter ~f:(fun (noun, verb) ->
      let result = noun * 100 + verb in
      Stdio.printf
        "part2: noun = %d, verb = %d, output = %d\n"
        noun verb result)

let () =
  let input =
    Option.value_exn Stdio.(In_channel.input_line stdin)
    |> String.split ~on:','
    |> Array.of_list_map ~f:Int.of_string
  in

  part1 (Array.copy input);
  part2 input
