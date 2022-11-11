use std::path::PathBuf;

fn path_to_input(day: &str) -> PathBuf {
    PathBuf::from(format!("../../input/2015/{}", day))
}

pub fn input(day: &str) -> String {
    std::fs::read_to_string(path_to_input(day)).expect("could not load input")
}
