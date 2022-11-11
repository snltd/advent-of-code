pub fn part01(instructions: String) -> i32 {
    let ups = instructions.matches('(').count() as i32;
    let downs = instructions.matches(')').count() as i32;
    ups - downs
}

pub fn part02(instructions: String) -> usize {
    let mut floor = 0;
    
    for (i, c) in instructions.chars().enumerate() {
        if c == '(' {
            floor += 1;
        } else {
            floor -= 1;
        }

        if floor == -1 {
            return i + 1;
        }
    }

    999
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part01() {
        assert_eq!(part01(String::from("(())")), 0);
        assert_eq!(part01(String::from("()()")), 0);
        assert_eq!(part01(String::from("(((")), 3);
        assert_eq!(part01(String::from("(()(()(")), 3);
        assert_eq!(part01(String::from("))(((((")), 3);
        assert_eq!(part01(String::from("())")), -1);
        assert_eq!(part01(String::from("))(")), -1);
        assert_eq!(part01(String::from(")))")), -3);
        assert_eq!(part01(String::from(")())())")), -3);
    }

    #[test]
    fn test_part02() {
        assert_eq!(part02(String::from(")")), 1);
        assert_eq!(part02(String::from("()())")), 5);
    }
}