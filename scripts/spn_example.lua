bpm(90)

song = {
    SPN(A, 4),
    SPN(C, 5),
    SPN(G, 4),
    SPN(F, 4)
}

for _, f in ipairs(song) do
    note(1, f)
end