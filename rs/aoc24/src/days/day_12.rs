use crate::utils::loader::InputChars;
use std::collections::BTreeSet;

const PAD_VAL: char = '+';
type Point = (usize, usize);
type Area = BTreeSet<Point>;

pub fn part_01(input: &InputChars) -> usize {
    let grid = Grid::new(input);
    let mut seen: Area = BTreeSet::new();
    let mut ret = 0;

    for y in 1..grid.height() {
        for x in 1..grid.width() {
            let point = (x, y);
            if !seen.contains(&point) {
                let a = get_area(&grid, point, BTreeSet::new());
                let p = perimeter_from_area(&grid, &a);
                seen.extend(&a);
                ret += a.len() * p;
            }
        }
    }

    ret
}

struct Grid {
    data: Vec<Vec<char>>,
}

impl Grid {
    pub fn new(data: &InputChars) -> Self {
        Self {
            data: Self::padded_map(data),
        }
    }

    fn width(&self) -> usize {
        self.data[0].len() - 1
    }

    fn height(&self) -> usize {
        self.data.len() - 1
    }

    fn neighbours(&self, point: Point) -> Vec<Point> {
        let (x, y) = point;
        vec![(x, y - 1), (x + 1, y), (x, y + 1), (x - 1, y)]
    }

    fn char_at(&self, point: Point) -> char {
        self.data[point.1][point.0]
    }

    fn padded_map(data: &InputChars) -> Vec<Vec<char>> {
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
}

fn get_area(grid: &Grid, point: Point, mut aggr: Area) -> Area {
    let my_char = grid.char_at(point);
    aggr.insert(point);

    for p in grid.neighbours(point) {
        if grid.char_at(p) == my_char && !aggr.contains(&p) {
            aggr.extend(get_area(grid, p, aggr.clone()));
        }
    }

    aggr
}

fn perimeter_from_area(grid: &Grid, area: &Area) -> usize {
    let mut ret = 0;

    for point in area {
        let my_char = grid.char_at(*point);
        for p in grid.neighbours(*point) {
            if grid.char_at(p) != my_char {
                ret += 1;
            }
        }
    }

    ret
}

pub fn part_02(input: &InputChars) -> usize {
    let grid = Grid::new(input);
    let mut seen: Area = BTreeSet::new();
    let mut ret = 0;

    for y in 1..grid.height() {
        for x in 1..grid.width() {
            let point = (x, y);
            if !seen.contains(&point) {
                let a = get_area(&grid, point, BTreeSet::new());
                seen.extend(&a);
                let sides = count_sides(&a, grid.width(), grid.height());
                ret += sides * a.len();
            }
        }
    }

    ret
}

fn contiguous_blocks(nums: &Vec<usize>) -> usize {
    if nums.is_empty() {
        return 0;
    }

    let min = *nums.iter().min().unwrap();
    let mut blocks = 1;
    let mut last = min - 1;

    for i in nums {
        if i - last != 1 {
            blocks += 1;
        }
        last = *i;
    }

    blocks
}

fn count_sides(area: &Area, width: usize, height: usize) -> usize {
    let mut ret = 0;

    for row in 1..=height {
        let cells_in_y_with_no_cell_above: Vec<usize> = area
            .iter()
            .filter(|&&(x, y)| y == row && !area.contains(&(x, (y as isize - 1) as usize)))
            .cloned()
            .map(|t| t.0)
            .collect();

        ret += contiguous_blocks(&cells_in_y_with_no_cell_above)
    }

    for row in 1..=height {
        let cells_in_y_with_no_cell_below: Vec<usize> = area
            .iter()
            .filter(|&&(x, y)| y == row && !area.contains(&(x, (y as isize + 1) as usize)))
            .cloned()
            .map(|t| t.0)
            .collect();

        ret += contiguous_blocks(&cells_in_y_with_no_cell_below);
    }

    for col in 1..=width {
        let cells_in_x_with_no_cell_left: Vec<usize> = area
            .iter()
            .filter(|&&(x, y)| x == col && !area.contains(&((x as isize - 1) as usize, y)))
            .cloned()
            .map(|t| t.1)
            .collect();

        ret += contiguous_blocks(&cells_in_x_with_no_cell_left);
    }

    for col in 1..=width {
        let cells_in_x_with_no_cell_right: Vec<usize> = area
            .iter()
            .filter(|&&(x, y)| x == col && !area.contains(&((x as isize + 1) as usize, y)))
            .cloned()
            .map(|t| t.1)
            .collect();

        ret += contiguous_blocks(&cells_in_x_with_no_cell_right);
    }

    ret
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_chars;

    #[test]
    fn test_1201() {
        assert_eq!(1930, part_01(&input_as_chars("12")));
    }

    #[test]
    fn test_1202() {
        assert_eq!(80, part_02(&input_as_chars("12-01")));
        assert_eq!(236, part_02(&input_as_chars("12-02")));
        assert_eq!(368, part_02(&input_as_chars("12-03")));
        assert_eq!(436, part_02(&input_as_chars("12-04")));
        assert_eq!(1206, part_02(&input_as_chars("12")));
    }
}
