open Ast

(* Set of strings *)
module SS = Set.Make(String)

(* Set of dependency pairs *)
module SDP = Set.Make(
    struct 
        type t = dp 
        let compare = compare_dp
    end)

let root_sym : expr -> string = 
    fun e -> 
    match e with 
    | Unary (Sym s, _) -> s 
    | Binary (Sym op, _, _) -> op 
    | Fun (Sym f, _) -> f 
    | Term (Sym x) -> x
    | Const c -> c 

let find_defined_syms : system -> dsyms =
    fun rules ->
    let dsyms = ref SS.empty in 
    let rec aux : system -> string list =
        fun rules -> 
        match rules with 
        | [] -> SS.elements !dsyms
        | Arr(e, _) :: rs -> 
            let defined = root_sym e in 
            begin 
            dsyms := SS.add defined !dsyms;
            aux rs 
            end 
    in aux rules

let find_dps_rule : rule -> dsyms -> dps =
    fun rule dsyms -> 
    let l, r = (match rule with Arr(l, r) -> l, r) in
    let dps = ref [] in
    let rec aux : expr -> unit = 
        fun e -> 
        let add_dp e s = 
            if List.mem s dsyms 
            then dps := (Dp (l, e)) :: !dps 
            else () 
        in
        match e with 
        | Unary (Sym s, a) ->
            let _ = add_dp e s in aux a

        | Binary (Sym op, a1, a2) -> 
            let _ = add_dp e op in (aux a1; aux a2)

        | Fun (Sym f, l) -> 
            let _ = add_dp e f in 
            List.iter aux l 

        | (Term (Sym x) | Const x) -> add_dp e x
    in 
    let _ = aux r in !dps


let find_dps : system -> string list -> dps = 
    fun rules dsyms ->
    let dps = ref SDP.empty in
    let rec aux =
        fun rules ->
        match rules with
        | [] -> SDP.elements !dps 
        | r :: rs -> let new_dps = find_dps_rule r dsyms in
                     let _ = dps := SDP.union !dps (SDP.of_list new_dps) in aux rs
    in aux rules

