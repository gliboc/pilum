# pilum

Right now this tool allows to parse files or enter interactively
rewriting systems with rules of the form `expr → expr`, and to
extract their dependency pairs (cf. Thomas Arts, Jürgen Giesl,
_Termination of term rewriting using dependency pairs_).

The directory `exos` contains a few examples of such systems.

## Usage 

There is a pre-compiled linux executable `main.exe` which 
can be run as `./main.exe <filename>` or `./main.exe` in order to 
either load an example file or try the REPL.

The normal way to build this executable is by using [dune](https://github.com/ocaml/dune) with
the commands `dune build ./main.exe` and `dune exec ./main.exe`
(with, or without arguments)

## Todo

- create a grammar for rewriting systems in Coq
- translate the parsed systems into this grammar
- generate a Coq file in order to prove termination using high-level libraries (try [color](http://color.inria.fr/))
