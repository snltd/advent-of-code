mod day01;
mod day02;
mod day03;
//mod day04; // because it takes ages
mod day05;
mod lib;

fn main() {
    println!("01/01: {:?}", day01::part01(lib::input("01")));
    println!("01/02: {:?}", day01::part02(lib::input("01")));

    println!("02/01: {:?}", day02::part01(lib::input("02")));
    println!("02/02: {:?}", day02::part02(lib::input("02")));

    println!("03/01: {:?}", day03::part01(lib::input("03")));
    println!("03/02: {:?}", day03::part02(lib::input("03")));

    //println!("04/01: {:?}", day04::part01("iwrupvqb"));
    //println!("04/02: {:?}", day04::part02("iwrupvqb"));

    println!("05/01: {:?}", day05::part01(lib::input("05")));
    println!("05/02: {:?}", day05::part02(lib::input("05")));
}
