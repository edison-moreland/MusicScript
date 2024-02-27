-- Implements the `Play` functions from TempleOS
-- RIP Terry A. Davis 1969-2018

-- References:
-- https://github.com/cia-foundation/TempleOS/blob/c26482bb6ad3f80106d28504ec5db3c6a360732c/Adam/Snd/SndMusic.HC#L98
-- https://github.com/mariiaan/TOSplay/blob/main/TOSSongParser.cs

TempleOS = {}

--- Sets the song bps
---@param bps number Beats per second
function TempleOS.Tempo(bps)
    bpm(bps * 60)
end

---@param value string
---@param cases table<string, function>
---@param default function
local function switch(value, cases, default)
    for v, f in pairs(cases) do
        local match = value:match(v)
        if match then
            f(match)
            return
        end
    end
    default()
end

--- Play a tune!
--- Check the TempleOS source under references for the syntax
---@param song string
function TempleOS.Play(song)
    local octave = 4
    local duration = 1
    for i = 1, #song do
        local char = song:sub(i, i)
        switch(char, {
            ["[0-9]"] = function(o)
                octave = tonumber(o)
            end,
            ["[A-G]"] = function(n)
                note(4 * duration, SPN(NoteSemitones(n), octave))
            end,
            ["%#"] = function()
                -- TODO: The previous note was a sharp
            end,
            ["b"] = function()
                -- TODO: The previous note was a flat
            end,
            ["w"] = function()
                duration = 1
            end,
            ["h"] = function()
                duration = 0.5
            end,
            ["q"] = function()
                duration = 0.25
            end,
            ["e"] = function()
                duration = 0.125
            end,
            ["t"] = function()
                duration = duration * (2 / 3)
            end,
            ["%."] = function()
                duration = duration * 1.5
            end
        }, function()
            error("fuck me!")
        end)
    end
end