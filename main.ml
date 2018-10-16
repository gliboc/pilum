open Dp
open Ast

let memory = ref [] 
let rec repl () = 
    let lb = Lexing.from_string (read_line ()) in
    let ast = Parser.main Lexer.token lb in 
    let _ =
        begin
        memory := ast @ !memory;
        let dsyms = find_defined_syms !memory in 
        let dps = find_dps !memory dsyms in
        Printf.printf "\nThe current system is:\n";
        pprint_system !memory; print_newline ();
        Printf.printf "The defined symbols are:\n";
        pprint_dsyms dsyms; print_newline (); print_newline ();
        Printf.printf "The dependency pairs are:\n";
        pprint_dps dps; print_newline();
        end
    in repl ()




let memory_file = ref [] 
let repl_file ic = 
        let lexbuf = Lexing.from_channel ic in
        let ast = Parser.main Lexer.token lexbuf in 
        begin
        memory_file := ast @ !memory_file;
        let dsyms = find_defined_syms !memory_file in 
        let dps = find_dps !memory_file dsyms in
        begin
        Printf.printf "\nThe current system is:\n";
        pprint_system !memory_file; print_newline ();
        Printf.printf "The defined symbols are:\n";
        pprint_dsyms dsyms; print_newline (); print_newline ();
        Printf.printf "The dependency pairs are:\n";
        pprint_dps dps; print_newline()
        end
        end


let _ = 
    if Array.length Sys.argv > 1 then
        let ic = open_in Sys.argv.(1) in 
        repl_file ic
    else 
        repl ()
        
(* let _ = repl_file () *)