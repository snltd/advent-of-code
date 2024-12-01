mod days;
mod utils;
use utils::loader::input_as_cols;

fn main() {
    println!("01/01: {:?}", days::day_01::part_01(input_as_cols("01")));
    println!("01/02: {:?}", days::day_01::part_02(input_as_cols("01")));
}
