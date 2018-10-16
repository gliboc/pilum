type symbol = Sym of string [@@deriving show,eq,ord]
type dsyms = string list [@@deriving show]

let pprint_dsyms : dsyms -> unit = fun dsyms ->
    Printf.printf "[%s]" (String.concat ", " dsyms)


type expr =   Unary of symbol * expr 
            | Binary of symbol * expr * expr 
            | Const of string 
            | Fun of symbol * (expr list) 
            | Term of symbol [@@deriving show,eq,ord]

let rec pshow_expr : expr -> string = fun expr -> 
    match expr with 
    | Fun (Sym f, l) -> Printf.sprintf "%s(%s)" f (String.concat ", " (List.map pshow_expr l))
    | Binary (Sym op, e1, e2) -> 
        begin
        match e1, e2 with
        | Binary _, Binary _ -> Printf.sprintf "(%s) %s (%s)" (pshow_expr e1) op (pshow_expr e2)
        | Binary _, _ -> Printf.sprintf "(%s) %s %s" (pshow_expr e1) op (pshow_expr e2)
        | _, Binary _ -> Printf.sprintf "%s %s (%s)" (pshow_expr e1) op (pshow_expr e2)
        | _ -> Printf.sprintf "%s %s %s" (pshow_expr e1) op (pshow_expr e2)
        end
    | Unary (Sym s, e) -> Printf.sprintf "%s(%s)" s (pshow_expr e)
    | Const c -> c 
    | Term (Sym s) -> s


type dp = Dp of expr * expr [@@deriving show,eq,ord]

let pprint_dp : dp -> unit = fun dp -> 
    match dp with Dp (e1, e2) ->
    Printf.printf "<%s, %s>\n" (pshow_expr e1) (pshow_expr e2)


type dps = dp list [@@deriving show]

let pprint_dps : dps -> unit = fun dps ->
    if dps = [] then print_endline "none" else
    List.iter pprint_dp dps


type rule = Arr of expr * expr [@@deriving show]

let pprint_rule : rule -> unit = fun rule ->
    match rule with Arr(e1, e2) ->
    Printf.printf "%s → %s\n" (pshow_expr e1) (pshow_expr e2)

type system = rule list [@@deriving show]

let pprint_system : system -> unit = fun system -> 
    List.iter pprint_rule system

type slist = string list [@@deriving show]
