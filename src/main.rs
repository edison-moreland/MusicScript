use std::fs;
use std::path::PathBuf;

use anyhow::Result;
use clap::Parser;
use fundsp::hacker::*;

use crate::script::run_script;
use crate::wav::export_wav;

mod script;
mod wav;

#[derive(Parser)]
struct Cli {
    script: PathBuf,
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    let source = fs::read_to_string(&cli.script)?;

    println!("-- Running script");
    let song = run_script(&source)?;

    let song_name = cli.script.file_stem().unwrap().to_str().unwrap();
    let output_file = format!("{}.wav", song_name);
    export_wav(&song, PathBuf::from(&output_file))?;

    println!(
        "-- Done. {}s generated, saved to '{}'",
        song.duration, output_file
    );

    Ok(())
}
