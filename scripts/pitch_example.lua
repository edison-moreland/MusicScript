bpm(90)

song = {
    pitch(A, 4),
    pitch(C, 5),
    pitch(G, 4),
    pitch(F, 4)
}

for _, f in ipairs(song) do
    note(1, f)
end