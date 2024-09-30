open Base
open Stdio

type coords = int * int

let () =
  let args = Sys.get_argv() in
  let reg_dot, s_desc = match args with
  | [|_; a; b|] -> String.drop_prefix a 1, b
  | _ ->
    Stdlib.exit 1
  in
  let regions =
    s_desc
    |> String.split ~on:' '
    |> List.map ~f:(fun str ->
      let[@warning"-8"] st :: fn :: [] = String.split ~on:',' str in
      let[@warning"-8"] st_l :: st_c :: [] = String.split ~on:'.' st |> List.map ~f:Int.of_string in
      let[@warning"-8"] fn_l :: fn_c :: [] = String.split ~on:'.' fn |> List.map ~f:Int.of_string in
      (st_l, st_c), (fn_l, fn_c)
    )
  in
  let regions = List.sort ~compare:(fun ((st_l1, st_c1),(_, _)) ((st_l2, st_c2),(_, _)) ->
    match Int.compare st_l1 st_l2 with
    | 0 -> Int.compare st_c1 st_c2
    | x -> x
  ) regions
  in
  let rec take acc chars n =
    match chars with
    | '"' :: tl when n > 0 ->
      take ('"'::acc) tl n
    | hd :: tl when n > 0 ->
      take (hd::acc) tl (n-1)
    | hd :: tl ->
      List.rev acc, chars
    | [] -> List.rev acc, chars
  in
  let rec aux acc chars regs =
    match regs with
    | ((st_l, st_c), (fn_l, fn_c)) :: tl ->
      let len = match Int.compare st_l fn_l with
        | 0 -> fn_c - st_c + 1
        | _ ->
        Stdlib.exit 1
      in
      let to_acc, rest = take [] chars len in
      let rest = match rest with
      | hd :: tl -> tl
      | [] -> []
      in
      aux (to_acc :: acc) rest tl
    | [] ->
    List.map ~f:String.of_list acc
  in
  let encapsulate str =
    match String.find ~f:(fun c -> Char.equal c '\'') str with
    | Some x ->
      (match String.find ~f:(fun c -> Char.equal c '"') str with
      | None -> "\"" ^ str ^ "\""
      | Some _ ->
        Stdlib.exit 1)
    | None -> "'" ^ str ^ "'"
  in
  let result = List.map ~f:encapsulate @@ aux [] (String.to_list reg_dot) regions in
  let reversed = String.concat ~sep:" " result in
  printf "%s\n" reversed
