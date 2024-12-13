mod days;
mod utils;
use std::time::Instant;
use utils::loader::{
    input_as_blocks, input_as_chars, input_as_cols, input_as_int_grid, input_as_lines,
    input_as_rows, input_as_words, raw_input,
};

fn run_and_time<F, T>(label: &str, f: F)
where
    F: FnOnce() -> T,
    T: std::fmt::Debug,
{
    let start = Instant::now();
    let result = f();
    let duration = start.elapsed();
    println!("{}: {:<25?} [{:?}]", label, result, duration);
}

fn main() {
    run_and_time("01/01", || days::day_01::part_01(input_as_cols("01")));
    run_and_time("01/02", || days::day_01::part_02(input_as_cols("01")));

    run_and_time("02/01", || days::day_02::part_01(&input_as_rows("02")));
    run_and_time("02/02", || days::day_02::part_02(&input_as_rows("02")));

    run_and_time("03/01", || days::day_03::part_01(&raw_input("03")));
    run_and_time("03/02", || days::day_03::part_02(&raw_input("03")));

    run_and_time("04/01", || days::day_04::part_01(&input_as_lines("04")));
    run_and_time("04/02", || days::day_04::part_02(&input_as_lines("04")));

    run_and_time("05/01", || days::day_05::part_01(&input_as_blocks("05")));
    run_and_time("05/02", || days::day_05::part_02(&input_as_blocks("05")));

    run_and_time("06/01", || days::day_06::part_01(&input_as_chars("06")));
    run_and_time("06/02", || days::day_06::part_02(&input_as_chars("06")));

    run_and_time("07/01", || days::day_07::part_01(&input_as_lines("07")));
    run_and_time("07/02", || days::day_07::part_02(&input_as_lines("07")));

    run_and_time("08/01", || days::day_08::part_01(&input_as_chars("08")));
    run_and_time("08/02", || days::day_08::part_02(&input_as_chars("08")));

    run_and_time("09/01", || days::day_09::part_01(&input_as_chars("09")));
    run_and_time("09/02", || days::day_09::part_02(&input_as_chars("09")));

    run_and_time("10/01", || days::day_10::part_01(&input_as_int_grid("10")));
    run_and_time("10/02", || days::day_10::part_02(&input_as_int_grid("10")));

    run_and_time("11/01", || days::day_11::part_01(&input_as_words("11")));
    run_and_time("11/02", || days::day_11::part_02(&input_as_words("11")));

    run_and_time("12/01", || days::day_12::part_01(&input_as_chars("12")));
    run_and_time("12/02", || days::day_12::part_02(&input_as_chars("12")));

    run_and_time("13/01", || days::day_13::part_01(&input_as_blocks("13")));
    run_and_time("13/02", || days::day_13::part_02(&input_as_blocks("13")));
}
