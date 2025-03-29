use std::process::{Command, Output};
use std::fs;
use std::io::Result;

pub fn remove_file(path: &str) -> Result<()> {
    fs::remove_file(path)
}

pub fn run_command(command: &str, args: &Vec<&str>, current_dir: Option<&str>) -> Output {
    let mut cmd = Command::new(command);
    if let Some(dir) = current_dir {
        cmd.current_dir(dir);
    }
    cmd.args(args)
    .output()
    .expect("Failed to execute command")
}