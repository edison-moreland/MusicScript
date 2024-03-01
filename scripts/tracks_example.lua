bpm(90)

track(1)
for n = C, B do
    note(1, pitch(n, 4))
end

track(2)
for n = B, C, -1 do
    note(1, pitch(n, 4))
end