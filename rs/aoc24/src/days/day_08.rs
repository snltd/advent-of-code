use crate::utils::loader::InputChars;
use itertools::Itertools;
use std::collections::HashMap;
use std::collections::HashSet;

type Point = (isize, isize);

pub fn find_chars(map: &InputChars) -> HashMap<char, Vec<Point>> {
    let mut ret: HashMap<char, Vec<Point>> = HashMap::new();

    for (y, row) in map.iter().enumerate() {
        for (x, c) in row.iter().enumerate() {
            if c != &'.' {
                ret.entry(*c).or_default().push((x as isize, y as isize));
            }
        }
    }

    ret
}

fn valid_point(point: Point, x_max: isize, y_max: isize) -> bool {
    (0..x_max).contains(&point.0) && (0..y_max).contains(&point.1)
}

pub fn part_01(input: &InputChars) -> usize {
    let map = input;
    let char_map = find_chars(map);
    let mut antinodes: HashSet<Point> = HashSet::new();
    let x_max = map[0].len() as isize;
    let y_max = map.len() as isize;

    for (_char, indices) in char_map {
        for pair in indices.iter().combinations(2) {
            let x_diff = pair[1].0 - pair[0].0;
            let y_diff = pair[1].1 - pair[0].1;

            let antinode_0 = (pair[0].0 - x_diff, pair[0].1 - y_diff);
            let antinode_1 = (pair[1].0 + x_diff, pair[1].1 + y_diff);

            if valid_point(antinode_0, x_max, y_max) {
                antinodes.insert(antinode_0);
            }

            if valid_point(antinode_1, x_max, y_max) {
                antinodes.insert(antinode_1);
            }
        }
    }

    antinodes.len()
}

pub fn part_02(input: &InputChars) -> usize {
    let map = input;
    let char_map = find_chars(map);
    let mut antinodes: HashSet<Point> = HashSet::new();
    let x_max = map[0].len() as isize;
    let y_max = map.len() as isize;

    for (_char, indices) in char_map {
        for pair in indices.iter().combinations(2) {
            let x_diff = pair[1].0 - pair[0].0;
            let y_diff = pair[1].1 - pair[0].1;

            (0..100).for_each(|i| {
                let antinode_0 = (pair[0].0 - i * x_diff, pair[0].1 - i * y_diff);
                if valid_point(antinode_0, x_max, y_max) {
                    antinodes.insert(antinode_0);
                }
            });

            (0..100).for_each(|i| {
                let antinode_1 = (pair[0].0 + i * x_diff, pair[0].1 + i * y_diff);
                if valid_point(antinode_1, x_max, y_max) {
                    antinodes.insert(antinode_1);
                }
            });
        }
    }

    antinodes.len()
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_chars;

    #[test]
    fn test_0801() {
        assert_eq!(14, part_01(&input_as_chars("08")));
    }

    #[test]
    fn test_0802() {
        assert_eq!(34, part_02(&input_as_chars("08")));
    }
}
