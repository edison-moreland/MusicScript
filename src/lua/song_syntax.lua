-- This is song api
-- A user script will use the public functions to populate `currentSong`
-- After the script is ran, the runtime will load the `currentSong` global out of lua

---@alias block {duration: number, kind: string, frequency: number | nil}

---@class Song
---@field bpm number
---@field lastBeat number
---@field blocks block[]
currentSong = {
    bpm = 0,
    lastBeat = 0,
    blocks = {}
}

---@return block
local function noteBlock(duration, pitch)
    ---@type block
    return {
        kind = "note",
        duration = duration,
        frequency = pitch
    }
end

---@return block
local function restBlock(duration)
    return {
        kind = "rest",
        duration = duration,
    }
end

---@param block block
local function pushBlock(block)
    currentSong.lastBeat = currentSong.lastBeat + block.duration
    table.insert(currentSong.blocks, block)
end

-- Public api below --

--- Get or set the beats per minute
---@param new number
---@return number
function bpm(new)
    if new then
        currentSong.bpm = new
    end
    return currentSong.bpm
end

--- Get the current beat
---@return number
function beat()
    return currentSong.lastBeat
end

--- Push a note onto the song. Advances beat by duration
---@param duration number How long to play note, 1.0 == 1 beat
---@param pitch number Note pitch, in hz
function note(duration, pitch)
    pushBlock(noteBlock(duration, pitch))
end

--- Push a rest onto the song. Advances beat by duration
---@param duration number
function rest(duration)
    pushBlock(restBlock(duration))
end