---@class Tuning
--- A note generation helper.
--- Given a root note it splits the octave into equal temperaments,
---  allowing the user to get any note by an offset from the root.
---@field notes number How many notes per octave
---@field root number Frequency of the root note
Tuning = {}

---@param root number Frequency of the root note
---@param notes number Number of notes per octave
---@return Tuning
function Tuning.new(root, notes)
    ---@type Tuning
    local tuning = Tuning
    tuning.notes = notes
    tuning.root = root
    setmetatable(tuning, { __index = Tuning })

    return tuning
end

--- Returns the frequency of the note at the given offset.
---@param offset number Semitone offset from the root note
---@return number
function Tuning:note(offset)
    return (self.root * math.pow(2, (1 / self.notes) * offset))
end

