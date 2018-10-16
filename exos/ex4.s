concat(cons(u, v), y) -> cons(u, concat(v, y))
Fewer⊥(x, ⊥) -> false
Fewer⊥(⊥, cons(w, z)) -> true
Fewer⊥(cons(u, v), cons(w, z)) -> Fewer⊥(concat(u, v), concat(w, z))