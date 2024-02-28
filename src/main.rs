use anyhow::Result;
use clap::Parser;
use fundsp::hacker::*;
use std::fs;
use std::path::PathBuf;

use crate::script::{run_script, Song, Sound};

mod script;

#[derive(Parser)]
struct Cli {
    script: PathBuf,
}

fn instrument(hz: f64) -> impl AudioUnit64 {
    // TODO: create a more interesting sound
    sine_hz(hz) >> pan(0.0)
}

fn sequence_song(song: &Song, sample_rate: f64) -> impl AudioUnit64 {
    let mut sequencer = Sequencer64::new(true, 2);
    sequencer.set_sample_rate(sample_rate);

    let beat_duration = 60.0 / song.bpm as f64;

    for track in &song.tracks {
        let mut current_time: f64 = 0.0;
        for block in &track.blocks {
            let block_duration = beat_duration * block.length;

            if let Sound::Note(hz) = block.sound {
                sequencer.push(
                    current_time,
                    current_time + block_duration,
                    Fade::Smooth,
                    min(0.05, block_duration),
                    min(0.05, block_duration),
                    Box::new(instrument(hz)),
                );
            }
            current_time += block_duration
        }
    }

    return sequencer;
}

fn render_to_wav(
    song: &Song,
    mut audio: impl AudioUnit64,
    sample_rate: f64,
    output: PathBuf,
) -> Result<()> {
    Wave64::render(sample_rate, song.duration, &mut audio)
        .filter(
            song.duration,
            &mut (multipass() & 0.15 * reverb_stereo(10.0, 1.0)),
        )
        .filter_latency(song.duration, &mut (limiter_stereo((5.0, 5.0))))
        .save_wav16(output)?;

    Ok(())
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    let source = fs::read_to_string(&cli.script)?;

    println!("-- Running script");
    let song = run_script(&source)?;

    println!("-- Sequencing song");
    let sample_rate = 44100.0;
    let sequencer = sequence_song(&song, sample_rate);

    println!("-- Rendering WAV");
    let song_name = cli.script.file_stem().unwrap().to_str().unwrap();
    let output_file = format!("{}.wav", song_name);
    render_to_wav(&song, sequencer, sample_rate, PathBuf::from(&output_file))?;

    println!(
        "-- Done. {}s generated, saved to '{}'",
        song.duration, output_file
    );

    Ok(())
}
