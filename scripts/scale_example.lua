bpm(90)

-- Plays the major and minor scale for every note in the C major scale.
for _, n in ipairs(scale(C, major)) do
    for _, nn in ipairs(scale(n, major)) do
        note(1 / 4, pitch(nn, 4))
    end
    rest(1)
    for _, nn in ipairs(scale(n, minor)) do
        note(1 / 4, pitch(nn, 4))
    end
    rest(1)
end