use crate::utils::loader::InputIntGrid;
use rayon::prelude::*;
use std::collections::BTreeSet;

const PAD_VAL: usize = 99;
type Point = (usize, usize);

pub fn part_01(input: &InputIntGrid) -> usize {
    let map = padded_map(input);

    find_zeros(&map)
        .par_iter()
        .map(|p| follow_trail(&map, *p, BTreeSet::new()).len())
        .sum()
}

fn find_zeros(map: &InputIntGrid) -> Vec<Point> {
    let mut ret = Vec::new();

    for (y, row) in map.iter().enumerate() {
        for (x, c) in row.iter().enumerate() {
            if *c == 0 {
                ret.push((x, y));
            }
        }
    }

    ret
}

fn padded_map(data: &InputIntGrid) -> Vec<Vec<usize>> {
    let padded_width = data[0].len() + 2;
    let pad_row = vec![PAD_VAL; padded_width];

    let mut ret = Vec::new();
    ret.push(pad_row.clone());
    for row in data {
        let mut padded_row = Vec::new();
        padded_row.push(PAD_VAL);
        padded_row.extend(row);
        padded_row.push(PAD_VAL);
        ret.push(padded_row);
    }
    ret.push(pad_row.clone());
    ret
}

fn neighbours(point: Point) -> Vec<Point> {
    let (x, y) = point;
    vec![(x - 1, y), (x + 1, y), (x, y + 1), (x, y - 1)]
}

fn follow_trail(map: &InputIntGrid, point: Point, mut peaks: BTreeSet<Point>) -> BTreeSet<Point> {
    let my_height = map[point.1][point.0] as isize;

    for (nx, ny) in neighbours(point) {
        let neighbour_height = map[ny][nx] as isize;
        let diff = neighbour_height - my_height;
        if diff == 1 {
            if neighbour_height == 9 {
                peaks.insert((nx, ny));
            } else {
                peaks.extend(follow_trail(map, (nx, ny), peaks.clone()));
            }
        }
    }

    peaks
}

pub fn part_02(input: &InputIntGrid) -> usize {
    let map = padded_map(input);

    find_zeros(&map)
        .par_iter()
        .map(|p| follow_trail_02(&map, *p, 0))
        .sum()
}

fn follow_trail_02(map: &InputIntGrid, point: Point, mut trails: usize) -> usize {
    let my_height = map[point.1][point.0] as isize;
    for (nx, ny) in neighbours(point) {
        let neighbour_height = map[ny][nx] as isize;
        let diff = neighbour_height - my_height;
        if diff == 1 {
            if neighbour_height == 9 {
                trails += 1;
            } else {
                trails = follow_trail_02(map, (nx, ny), trails);
            }
        }
    }

    trails
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_int_grid;

    #[test]
    fn test_1001() {
        assert_eq!(36, part_01(&input_as_int_grid("10")));
    }

    #[test]
    fn test_1002() {
        assert_eq!(81, part_02(&input_as_int_grid("10")));
    }
}
