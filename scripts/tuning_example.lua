bpm(120)

local tuning = Tuning.new(440, 12)

-- Plays three octaves from tuning, starting one octave below root
for i = -1, 1 do
    for j = 0, (tuning.notes - 1) do
        local semitones = j + ((i - 1) * tuning.notes)
        note(0.5, tuning:note(semitones))
    end
end
