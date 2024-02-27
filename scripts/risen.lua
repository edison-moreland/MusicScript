-- RIP Terry A. Davis 1969-2018

-- https://github.com/mariiaan/TOSplay/blob/main/TOSSongParser.cs

w = 1
h = 0.5
q = 0.25
e = 0.125
t = 2 / 3

-- "5eDEqFFetEEFqDeCDDEetCGF"
verse_one = {
    { e, SPN(D, 5) },
    { e, SPN(E, 5) },
    { q, SPN(F, 5) },
    { q, SPN(F, 5) },
    { e * t, SPN(E, 5) },
    { e * t, SPN(E, 5) },
    { e * t, SPN(F, 5) },
    { q, SPN(D, 5) },
    { e, SPN(C, 5) },
    { e, SPN(D, 5) },
    { e, SPN(D, 5) },
    { e, SPN(E, 5) },
    { e * t, SPN(C, 5) },
    { e * t, SPN(G, 5) },
    { e * t, SPN(F, 5) },
}

-- "5eDCqDE4eAA5etEEFEDG4B5DCqF"
verse_two = {
    { e, SPN(D, 5) },
    { e, SPN(C, 5) },
    { q, SPN(D, 5) },
    { q, SPN(E, 5) },
    { e, SPN(A, 4) },
    { e, SPN(A, 4) },
    { e * t, SPN(E, 5) },
    { e * t, SPN(E, 5) },
    { e * t, SPN(F, 5) },
    { e * t, SPN(E, 5) },
    { e * t, SPN(D, 5) },
    { e * t, SPN(G, 5) },
    { e * t, SPN(B, 4) },
    { e * t, SPN(D, 5) },
    { e * t, SPN(C, 5) },
    { q, SPN(F, 5) },
}

local function play(notes)
    for _, n in ipairs(notes) do
        note(n[1], n[2])
    end
end

bpm(90 / 3)

play(verse_one)
play(verse_one)
play(verse_two)
play(verse_two)
