use std::path::PathBuf;

use anyhow::Result;
use fundsp::audiounit::AudioUnit64;
use fundsp::hacker::{limiter_stereo, multipass, pan, reverb_stereo, sine_hz};
use fundsp::hacker32::{min, Fade, Sequencer64, Wave64};

use crate::script::{Song, Sound};

pub fn export_wav(song: &Song, output_file: PathBuf) -> Result<()> {
    println!("-- Sequencing song");
    let sample_rate = 44100.0;
    let sequencer = sequence_song(&song, sample_rate);

    println!("-- Rendering WAV");
    render_to_wav(&song, sequencer, sample_rate, PathBuf::from(&output_file))?;

    Ok(())
}

fn instrument(hz: f64) -> impl AudioUnit64 {
    // TODO: create a more interesting sound
    sine_hz(hz) >> pan(0.0)
    // organ_hz(hz) >> moog_hz(200.0, 10.0) >> pan(0.0)
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
) -> anyhow::Result<()> {
    Wave64::render(sample_rate, song.duration, &mut audio)
        .filter(
            song.duration,
            &mut (multipass() & 0.15 * reverb_stereo(10.0, 1.0)),
        )
        .filter_latency(song.duration, &mut (limiter_stereo((5.0, 5.0))))
        .save_wav16(output)?;

    Ok(())
}
