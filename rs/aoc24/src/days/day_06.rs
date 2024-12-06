use crate::utils::loader::InputChars;
use std::collections::HashSet;

struct InputMap {
    data: Vec<char>,
    width: usize,
}

impl InputMap {
    fn new(data: &InputChars) -> Self {
        let width = data[0].len() + 2;
        Self {
            data: padded_map(data, 'x'),
            width,
        }
    }

    fn place_obstacle_at(&mut self, index: usize) {
        self.data[index] = '#'
    }

    fn remove_obstacle_at(&mut self, index: usize) {
        self.data[index] = '.'
    }

    fn index_of_char(&self, char: char) -> usize {
        self.data.iter().position(|c| c == &char).unwrap()
    }

    pub fn char_at(&self, index: usize) -> char {
        self.data[index]
    }

    pub fn move_guard(&self, index: usize, direction: Direction) -> (usize, Direction) {
        match direction {
            Direction::Up => {
                if self.data[index - self.width] == '#' {
                    (index, Direction::Right)
                } else {
                    (index - self.width, direction)
                }
            }
            Direction::Down => {
                if self.data[index + self.width] == '#' {
                    (index, Direction::Left)
                } else {
                    (index + self.width, direction)
                }
            }
            Direction::Left => {
                if self.data[index - 1] == '#' {
                    (index, Direction::Up)
                } else {
                    (index - 1, direction)
                }
            }
            Direction::Right => {
                if self.data[index + 1] == '#' {
                    (index, Direction::Down)
                } else {
                    (index + 1, direction)
                }
            }
        }
    }
}

#[derive(Debug)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

fn padded_map(data: &InputChars, pad_char: char) -> Vec<char> {
    let padded_width = data[0].len() + 2;
    let pad_row = vec![pad_char; padded_width];

    let mut ret = Vec::new();
    ret.extend(&pad_row);
    for row in data {
        ret.push(pad_char);
        ret.extend(row);
        ret.push(pad_char);
    }
    ret.extend(&pad_row);
    ret
}

pub fn part_01(input: &InputChars) -> usize {
    let map = InputMap::new(input);
    let mut index = map.index_of_char('^');
    let mut direction = Direction::Up;
    let mut visited: HashSet<usize> = HashSet::new();

    loop {
        visited.insert(index);
        (index, direction) = map.move_guard(index, direction);

        if map.char_at(index) == 'x' {
            break;
        }
    }

    visited.len()
}

pub fn part_02(input: &InputChars) -> usize {
    let mut map = InputMap::new(input);
    let mut index = map.index_of_char('^');
    let mut direction = Direction::Up;
    let mut path: HashSet<usize> = HashSet::new();

    loop {
        (index, direction) = map.move_guard(index, direction);
        if map.char_at(index) == 'x' {
            break;
        }

        path.insert(index);
    }

    let mut causes_loop = 0;
    let start = map.index_of_char('^');

    for i in path.iter() {
        map.place_obstacle_at(*i);
        let mut index = start;
        let mut direction = Direction::Up;
        let mut steps = 0;

        loop {
            (index, direction) = map.move_guard(index, direction);

            if steps == 5300 {
                causes_loop += 1;
                break;
            }

            if map.char_at(index) == 'x' {
                break;
            }

            steps += 1;
        }

        map.remove_obstacle_at(*i);
    }

    causes_loop
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_chars;

    #[test]
    fn test_0601() {
        assert_eq!(41, part_01(&input_as_chars("06")));
    }

    #[test]
    fn test_0602() {
        assert_eq!(6, part_02(&input_as_chars("06")));
    }
}
