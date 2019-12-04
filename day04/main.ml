(* Quick and dirty *)
let () =
  let rec criterion1 = function
    | c1::c2::t -> if c1 <= c2 then criterion1 (c2::t) else false
    | [] -> true
    | _::[] -> true
  in

  let rec criterion2 = function
    | c1::c2::t -> if c1 == c2 then true else criterion2 (c2::t)
    | _ -> false
  in

  let rec criterion22' = function
    | c1::c2::c3::[] -> c1 <> c2 && c2 == c3
    | c1::c2::c3::c4::t ->
      if c1 <> c2 && c2 == c3 && c3 <> c4
      then true
      else criterion22' (c2::c3::c4::t)
    | _ -> false
  in

  let criterion22 = function
    | c1::c2::c3::_ as t' ->
      if c1 == c2 && c2 <> c3
      then true
      else criterion22' t'
    | _ -> false
  in

  let cnt1 = ref 0 in
  let cnt2 = ref 0 in
  for i = 353096 to 843212 do
    let toks = i |> Int.to_string |> String.to_seq |> List.of_seq in
    if criterion1 toks then begin
      if criterion2 toks then incr cnt1;
      if criterion22 toks then incr cnt2;
    end;
  done;
  Stdio.printf "part1 => %d\n" !cnt1;
  Stdio.printf "part2 => %d\n" !cnt2;
