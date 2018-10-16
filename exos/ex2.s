0≤y → true
s(x)≤0 → false
s(x)≤s(y) → x≤y
0−y → 0
s(x)−y → ifte(s(x)≤y,s(x),y)
ifte(true, s(x),y) → 0
ifte(false, s(x),y) → s(x−y)
0÷s(y) → 0
s(x)÷s(y) → s((x−y)÷s(y))
