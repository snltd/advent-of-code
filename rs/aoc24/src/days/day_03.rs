use regex::Regex;

pub fn part_01(input: &str) -> i32 {
    let rx = Regex::new(r"mul\((\d+),(\d+)\)").unwrap();
    let mut total = 0;

    for (_, [a, b]) in rx.captures_iter(input).map(|c| c.extract()) {
        total += a.parse::<i32>().unwrap() * b.parse::<i32>().unwrap();
    }

    total
}

pub fn part_02(input: &str) -> i32 {
    let rx = Regex::new(r"(?s)don't\(\).*?do\(\)").unwrap();
    part_01(&rx.replace_all(input, ""))
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_0301() {
        assert_eq!(
            161,
            part_01("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
        );
    }

    #[test]
    fn test_0302() {
        assert_eq!(
            48,
            part_02("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
        );
    }
}
