mod days;
mod utils;
use utils::loader::input_as_cols;
use utils::loader::input_as_lines;
use utils::loader::input_as_rows;
use utils::loader::raw_input;

fn main() {
    println!("01/01: {:?}", days::day_01::part_01(input_as_cols("01")));
    println!("01/02: {:?}", days::day_01::part_02(input_as_cols("01")));

    println!("02/01: {:?}", days::day_02::part_01(&input_as_rows("02")));
    println!("02/02: {:?}", days::day_02::part_02(&input_as_rows("02")));

    println!("03/01: {:?}", days::day_03::part_01(&raw_input("03")));
    println!("03/02: {:?}", days::day_03::part_02(&raw_input("03")));

    println!("04/01: {:?}", days::day_04::part_01(&input_as_lines("04")));
    println!("04/02: {:?}", days::day_04::part_02(&input_as_lines("04")));
}
