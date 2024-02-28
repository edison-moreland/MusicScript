-- This is song api
-- A user script will use the public functions to populate `currentSong`
-- After the script is ran, the runtime will load the `currentSong` global out of lua

---@alias block {duration: number, kind: string, frequency: number | nil}
---@alias track {lastBeat: number, blocks: block[]}

---@class Song
---@field bpm number
---@field currentTrack number
---@field tracks track[]
__currentSong = {
    bpm = 0,
    currentTrack = 1,
    tracks = {
        [1] = {
            lastBeat = 0,
            blocks = {}
        }
    }
}

---@return track
local function __currentTrack()
    return __currentSong.tracks[__currentSong.currentTrack]
end

---@return block
local function __noteBlock(duration, pitch)
    ---@type block
    return {
        kind = "note",
        duration = duration,
        frequency = pitch
    }
end

---@return block
local function __restBlock(duration)
    return {
        kind = "rest",
        duration = duration,
    }
end

---@param block block
local function __pushBlock(block)
    local track = __currentTrack()

    track.lastBeat = track.lastBeat + block.duration
    table.insert(track.blocks, block)
end

-- Public api below --

--- Get or set the beats per minute
---@param new number
---@return number
function bpm(new)
    if new then
        __currentSong.bpm = new
    end
    return __currentSong.bpm
end

--- Get the current beat
---@return number
function beat()
    return __currentTrack().lastBeat
end

--- Set the current track to the given index, creating a new track if it doesn't exist
---@param index number track index
function track(index)
    if __currentSong.tracks[index] == nil then
        __currentSong.tracks[index] = {
            lastBeat = 0,
            blocks = {}
        }
    end
    __currentSong.currentTrack = index
end

--- Push a note onto the song. Advances beat by duration
---@param duration number How long to play note, 1.0 == 1 beat
---@param pitch number Note pitch, in hz
function note(duration, pitch)
    __pushBlock(__noteBlock(duration, pitch))
end

--- Push a rest onto the song. Advances beat by duration
---@param duration number
function rest(duration)
    __pushBlock(__restBlock(duration))
end