--- Standard tuning in western music.
--- 12 notes of equal temperament with the root note A4 at 440hz
A440_12TET = Tuning.new(440, 12)

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

---@type table<string, number>
local noteSemitones = {
    ["C"] = C,
    ["Cs"] = Cs,
    ["Df"] = Df,
    ["D"] = D,
    ["Ds"] = Ds,
    ["Ef"] = Ef,
    ["E"] = E,
    ["F"] = F,
    ["Fs"] = Fs,
    ["Gf"] = Gf,
    ["G"] = G,
    ["Gs"] = Gs,
    ["Af"] = Af,
    ["A"] = A,
    ["As"] = As,
    ["Bf"] = Bf,
    ["B"] = B
}

--- Scientific Pitch Notation
---@param note number 0-12
---@param octave number 0-9
---@return number
function SPN(note, octave)
    local C0 = -((4 * 12) + 9)

    return A440_12TET:note((C0 + (12 * octave)) + note)
end

--- Give a semitone valuable suitable for SPN for the given note
---@param note string A single note without the octave. Ex: "A" "Bb", "C#", etc
---@return number
function NoteSemitones(note)
    return noteSemitones[note]
end