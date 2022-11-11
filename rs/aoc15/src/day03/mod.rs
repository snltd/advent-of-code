use std::collections::HashSet;

fn houses_visited(
    instructions: Vec<char>,
    mut visited: HashSet<(i32, i32)>,
) -> HashSet<(i32, i32)> {
    let mut pos = (0, 0);

    visited.insert(pos);

    for c in instructions {
        match c {
            '>' => pos.0 += 1,
            '<' => pos.0 -= 1,
            '^' => pos.1 += 1,
            'v' => pos.1 -= 1,
            _ => (),
        };

        visited.insert(pos);
    }

    visited
}

pub fn part01(input: String) -> usize {
    houses_visited(input.chars().collect::<Vec<char>>(), HashSet::new()).len()
}

pub fn part02(input: String) -> usize {
    let visted_by_santa = houses_visited(
        input.chars().step_by(2).collect::<Vec<char>>(),
        HashSet::new(),
    );
    houses_visited(
        input.chars().skip(1).step_by(2).collect::<Vec<char>>(),
        visted_by_santa,
    )
    .len()
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part01() {
        assert_eq!(2, part01(String::from(">")));
        assert_eq!(4, part01(String::from("^>v<")));
        assert_eq!(2, part01(String::from("^v^v^v^v^v")));
    }

    #[test]
    fn test_part02() {
        assert_eq!(3, part02(String::from("^v")));
        assert_eq!(3, part02(String::from("^>v<")));
        assert_eq!(11, part02(String::from("^v^v^v^v^v")));
    }
}
