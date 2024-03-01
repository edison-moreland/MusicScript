--- Standard tuning in western music.
--- 12 notes of equal temperament with the root note A4 at 440hz
A440_12TET = Tuning.new(440, 12)

--- Give a name to all 12
C = 0
Cs = 1
Df = 1
D = 2
Ds = 3
Ef = 3
E = 4
F = 5
Fs = 6
Gf = 6
G = 7
Gs = 8
Af = 8
A = 9
As = 10
Bf = 10
B = 11

--- Returns the pitch of the given note, Ex: pitch(C, 4)
---@param note number semitone offset from C in the given octave
---@param octave number octave offset
---@return number
function pitch(note, octave)
    local C0 = -((4 * 12) + 9)

    return A440_12TET:note((C0 + (12 * octave)) + note)
end

local w = 2
local h = 1
major = { w, w, h, w, w, w, h }
minor = { w, h, w, w, h, w, w }

--- Returns a list of notes in the given scale, Ex: scale(A, minor)
---@param root number root note of the scale
---@param step number[] semitone steps for each note in the scale
function scale(root, steps)
    local scale = { root }

    local last_note = root
    for _, step in ipairs(steps) do
        last_note = last_note + step
        table.insert(scale, last_note)
    end

    return scale
end

---@type table<string, number>
local noteSemitones = {
    ["C"] = C,
    ["C#"] = Cs,
    ["Db"] = Df,
    ["D"] = D,
    ["D#"] = Ds,
    ["Eb"] = Ef,
    ["E"] = E,
    ["F"] = F,
    ["F#"] = Fs,
    ["Gb"] = Gf,
    ["G"] = G,
    ["G#"] = Gs,
    ["Ab"] = Af,
    ["A"] = A,
    ["A#"] = As,
    ["Bb"] = Bf,
    ["B"] = B
}
--- Returns the semitone value of the given note
---@param note string A single note without the octave. Ex: "A" "Bb", "C#", etc
---@return number
function semitones(note)
    return noteSemitones[note]
end