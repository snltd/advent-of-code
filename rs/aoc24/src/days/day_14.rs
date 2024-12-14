use crate::utils::loader::InputLines;
use lazy_static::lazy_static;
use regex::Regex;
use std::ops::Rem;

type Point = (isize, isize);
type Velocity = (isize, isize);

#[derive(Debug)]
struct Robot {
    start: Point,
    velocity: Velocity,
}

lazy_static! {
    static ref EXTRACT_NUM: Regex = Regex::new(r"-?\d+").unwrap();
}

pub fn part_01(input: &InputLines) -> usize {
    solver_01(input, 101, 103, 100)
}

fn solver_01(input: &InputLines, width: isize, height: isize, moves: isize) -> usize {
    let xdiv = (width - 1) / 2;
    let ydiv = (height - 1) / 2;
    let mut quadrants = [0, 0, 0, 0];

    parse_input(input).iter().for_each(|robot| {
        let (ex, ey) = pos_in_n(robot.start, robot.velocity, width, height, moves);
        if ex < xdiv && ey < ydiv {
            quadrants[0] += 1;
        } else if ex > xdiv && ey < ydiv {
            quadrants[1] += 1;
        } else if ex < xdiv && ey > ydiv {
            quadrants[2] += 1;
        } else if ex > xdiv && ey > ydiv {
            quadrants[3] += 1;
        }
    });

    quadrants.iter().product()
}

fn print_grid(points: Vec<Point>, width: isize, height: isize) {
    for y in 0..height {
        let mut row = vec![' '; width as usize];
        for x in 0..width {
            if points.contains(&(x, y)) {
                row[x as usize] = '*';
            }
        }
        let row_str: String = row.into_iter().collect();
        println!("{}", row_str);
    }
}

pub fn part_02(input: &InputLines) -> usize {
    let width = 101;
    let height = 103;

    let mut lowest_danger = 9999999999999;

    for i in 2000..12000 {
        let danger = solver_01(input, width, height, i);

        if danger < lowest_danger {
            println!("lowest danger is at {}", i);
            lowest_danger = danger;
            let points: Vec<Point> = parse_input(input)
                .iter()
                .map(|robot| pos_in_n(robot.start, robot.velocity, width, height, i))
                .collect();
            print_grid(points, width, height);
        }
    }

    0
}

fn pos_in_n(start: Point, velocity: Velocity, width: isize, height: isize, moves: isize) -> Point {
    let vx = if velocity.0.is_negative() {
        width + velocity.0
    } else {
        velocity.0
    };

    let final_x = (start.0 + moves * vx).rem(width);

    let vy = if velocity.1.is_negative() {
        height + velocity.1
    } else {
        velocity.1
    };

    let final_y = (start.1 + moves * vy).rem(height);

    (final_x, final_y)
}

fn parse_input(raw: &InputLines) -> Vec<Robot> {
    raw.iter()
        .map(|line| {
            let nums: Vec<isize> = EXTRACT_NUM
                .find_iter(line)
                .filter_map(|m| m.as_str().parse::<isize>().ok())
                .collect();

            Robot {
                start: (nums[0], nums[1]),
                velocity: (nums[2], nums[3]),
            }
        })
        .collect()
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_lines;

    #[test]
    fn test_1401() {
        assert_eq!(12, solver_01(&input_as_lines("14"), 11, 7, 100));
    }
}
