use mlua::prelude::*;
use mlua::{Lua, Table};

#[derive(Debug)]
pub enum Sound {
    Rest,
    Note(f64), // hz
}

// A block of time
#[derive(Debug)]
pub struct Block {
    pub length: f64,
    // (0, 1], where 1 == a whole beat
    pub sound: Sound,
}

#[derive(Debug)]
pub struct Track {
    pub duration: f64,
    pub blocks: Vec<Block>,
}

#[derive(Debug)]
pub struct Song {
    pub duration: f64,
    pub bpm: u64,
    pub tracks: Vec<Track>,
}

const SONG_SRC: &str = include_str!("lua/song_syntax.lua");
const TUNING_SRC: &str = include_str!("lua/tuning.lua");
const PITCH_SRC: &str = include_str!("lua/pitch_notation.lua");
const TEMPLEOS_SRC: &str = include_str!("lua/templeos.lua");

fn get_block(table: Table) -> Block {
    let duration: f64 = table.get("duration").expect("Block to have duration");
    let kind: String = table.get("kind").expect("Block to have kind");

    Block {
        length: duration,
        sound: match kind.as_str() {
            "note" => {
                let freq = table
                    .get("frequency")
                    .expect("Note block to have a frequency");

                Sound::Note(freq)
            }
            "rest" => Sound::Rest,
            _ => panic!("block type doesn't exist"),
        },
    }
}

fn get_track(bpm: u64, table: Table) -> LuaResult<Track> {
    let mut track = Track {
        duration: 0.0,
        blocks: vec![],
    };

    let last_beat: f64 = table.get("lastBeat")?;
    let blocks: Table = table.get("blocks")?;

    let mut track_duration = 0.0;

    track.blocks = blocks
        .pairs()
        .map(|item: LuaResult<(isize, Table)>| {
            let (_, lua_block) = item.unwrap();
            let block = get_block(lua_block);

            track_duration += block.length;

            return block;
        })
        .collect::<Vec<Block>>();

    assert_eq!(last_beat, track_duration);

    track.duration = (60.0 / (bpm as f64)) * track_duration;

    return Ok(track);
}

fn get_song(lua: Lua) -> LuaResult<Song> {
    let mut song = Song {
        duration: 0.0,
        bpm: 0,
        tracks: vec![],
    };

    let lua_song: Table = lua.globals().get("__currentSong")?;

    song.bpm = lua_song.get("bpm")?;

    let mut max_duration: f64 = 0.0;
    let tracks: Table = lua_song.get("tracks")?;
    song.tracks = tracks
        .pairs()
        .map(|item: LuaResult<(isize, Table)>| {
            let (_, lua_track) = item.unwrap();
            let track = get_track(song.bpm, lua_track).unwrap();

            max_duration = max_duration.max(track.duration);

            return track;
        })
        .collect::<Vec<Track>>();

    song.duration = max_duration;

    return Ok(song);
}

pub fn run_script(src: &str) -> LuaResult<Song> {
    let lua = Lua::new();

    // The main builtins, this defines the song syntax
    lua.load(SONG_SRC).set_name("song_syntax.lua").exec()?;

    // Some helper libraries (more to come)
    lua.load(TUNING_SRC).set_name("tuning.lua").exec()?;
    lua.load(PITCH_SRC).set_name("pitch_notation.lua").exec()?;
    lua.load(TEMPLEOS_SRC).set_name("templeos.lua").exec()?;

    // Run script
    lua.load(src).exec()?;

    return get_song(lua);
}
