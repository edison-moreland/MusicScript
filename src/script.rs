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
pub struct Song {
    pub bpm: u64,
    pub duration: f64,
    // seconds
    pub blocks: Vec<Block>,
}

const SONG_SRC: &str = include_str!("lua/song_syntax.lua");
const TUNING_SRC: &str = include_str!("lua/tuning.lua");
const PITCH_SRC: &str = include_str!("lua/pitch_notation.lua");
const TEMPLEOS_SRC: &str = include_str!("lua/templeos.lua");

fn get_song(lua: Lua) -> LuaResult<Song> {
    let mut song = Song {
        bpm: 0,
        duration: 0.0,
        blocks: vec![],
    };

    let lua_song: Table = lua.globals().get("__currentSong")?;

    song.bpm = lua_song.get("bpm")?;

    let last_beat: f64 = lua_song.get("lastBeat")?;

    let blocks: Table = lua_song.get("blocks")?;

    let mut total_duration: f64 = 0.0;
    song.blocks = blocks
        .pairs()
        .map(|item: LuaResult<(isize, Table)>| {
            let (_, lua_block) = item.unwrap();

            let duration: f64 = lua_block.get("duration").expect("Block to have duration");
            let kind: String = lua_block.get("kind").expect("Block to have kind");

            total_duration += duration;

            Block {
                length: duration,
                sound: match kind.as_str() {
                    "note" => {
                        let freq = lua_block
                            .get("frequency")
                            .expect("Note block to have a frequency");

                        Sound::Note(freq)
                    }
                    "rest" => Sound::Rest,
                    _ => panic!("FUCK YOU FUCK YOU FUCK YOU"),
                },
            }
        })
        .collect::<Vec<Block>>();

    assert_eq!(last_beat, total_duration);

    song.duration = (60.0 / (song.bpm as f64)) * total_duration;

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
