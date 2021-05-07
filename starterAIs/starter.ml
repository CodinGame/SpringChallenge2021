(* Auto-generated code below aims at helping you parse *)
(* the standard input according to the problem statement. *)


(* to create a tree :
let myTree = {pos=2; size=2; ismine = true; isdormant = false} *)
(* you can access to any of the tree attribute with :
let myTreePos = myTree.pos *)
type tree = {pos : int; size : int; ismine : bool; isdormant : bool};;

(* you can create an action like this :
let a = GROW 2 and a2 = COMPLETE 3 and a3 = WAIT and a4 = SEED (2,3) or
use the action function below *)
type action = GROW of int | COMPLETE of int | WAIT | SEED of int*int ;;

(* Convert an action string to an action type :
let a = action "COMPLETE 3" return COMPLETE 3 *)
let action s = match s.[0] with
    | 'W' -> WAIT
    | 'G' ->  GROW (Scanf.sscanf s "%s %d" (fun _ b -> b))
    | 'C' -> COMPLETE (Scanf.sscanf s "%s %d" (fun _ b -> b))
    | 'S' -> let a,b = Scanf.sscanf s "%s %d %d" (fun _ a b -> a,b) in SEED (a,b)
    | _ -> failwith @@ s^" is an invalid action"


(* Convert an action to a string
toString (COMPLETE 3) return "COMPLETE 3" *)
and toString = function (* a good exemple on how you can
match actions *)
    | GROW t -> Printf.sprintf "GROW %d" t
    | COMPLETE t -> Printf.sprintf "COMPLETE %d" t
    | WAIT -> "WAIT" 
    | SEED (a,b) -> Printf.sprintf "SEED %d %d" a b
    in

let numberofcells = int_of_string (input_line stdin) in (* 37 *)

 (* create an array which contains all your neighbours index (-1 meaning that you don't have neighbours in this direction) *)
let neighbourTable = Array.make numberofcells [||]

(* create an array which will associate each cell to
its richness *)
and richnessTable = Array.make numberofcells 0  in
(* return the neighbour array *)
let getNeighbours x = neighbourTable.(x)
(* return the richness of the tile *)
and richness x = richnessTable.(x) in

for i = 0 to numberofcells - 1 do
    (* index: 0 is the center cell, the next cells spiral outwards *)
    (* richness: 0 if the cell is unusable, 1-3 for usable cells *)
    (* neigh0: the index of the neighbouring cell for each direction *)
    let index, richness, neighbours = Scanf.sscanf (input_line stdin) " %d  %d  %d  %d  %d  %d  %d  %d" (fun index richness neigh0 neigh1 neigh2 neigh3 neigh4 neigh5 -> (index, richness, [|neigh0; neigh1; neigh2; neigh3; neigh4; neigh5|])) in
    (* fill the dictionnaries *)
    richnessTable.(index) <- richness ;
    neighbourTable.(index) <- neighbours;
done;


(* game loop *)
while true do
	(* create a dictionnary to store all the trees with their position as index*)
    let treeTable = Hashtbl.create 37 in
    let day = int_of_string (input_line stdin) in (* the game lasts 24 days: 0-23 *)
    let nutrients = int_of_string (input_line stdin) in (* the base score you gain from the next COMPLETE action *)
    (* sun: your sun points *)
    (* score: your current score *)
    let sun, score = Scanf.sscanf (input_line stdin) " %d  %d" (fun sun score -> (sun, score)) in
    (* oppsun: opponent's sun points *)
    (* oppscore: opponent's score *)
    (* oppiswaiting: whether your opponent is asleep until the next day *)
    let oppsun, oppscore, oppiswaiting = Scanf.sscanf (input_line stdin) " %d  %d  %d" (fun oppsun oppscore oppiswaiting -> (oppsun, oppscore, oppiswaiting = 1)) in
    let numberoftrees = int_of_string (input_line stdin) in (* the current amount of trees *)
    for i = 0 to numberoftrees - 1 do
        (* cellindex: location of this tree *)
        (* size: size of this tree: 0-3 *)
        (* ismine: 1 if this is your tree *)
        (* isdormant: 1 if this tree is dormant *)
        let tree = Scanf.sscanf (input_line stdin) " %d  %d  %d  %d" (fun cellindex size ismine isdormant -> {pos=cellindex; size=size; ismine = (ismine = 1); isdormant = (isdormant = 1)}) in
        (* add the tree to the dictionnary *)
        Hashtbl.add treeTable tree.pos tree;
    done;
    let numberofpossiblemoves = int_of_string (input_line stdin) in
    (* make a list of all the actions, replace the for loop in the codingame code *)
    let actionlist =
    let rec aux n = if n = numberofpossiblemoves then [] else (action (input_line stdin) :: aux (n+1))
    in aux 0 in



    (* Write an action using print_endline *)
    (* To debug: prerr_endline "Debug message"; *)


    (* GROW cellIdx | SEED sourceIdx targetIdx | COMPLETE cellIdx | WAIT <message> *)
    match actionlist with
    (* how to print an action *)
    | x :: xs -> print_endline @@ toString x
    | [] -> failwith "No action found (impossible in theory)"
done;;
