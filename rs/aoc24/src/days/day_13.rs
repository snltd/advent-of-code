use crate::utils::loader::InputBlocks;
use lazy_static::lazy_static;
use regex::Regex;

lazy_static! {
    static ref EXTRACT_NUM: Regex = Regex::new(r"\d+").unwrap();
}

#[derive(Debug)]
struct Problem {
    prize_x: f64,
    prize_y: f64,
    a_x: f64,
    b_x: f64,
    a_y: f64,
    b_y: f64,
}

pub fn part_01(input: &InputBlocks) -> usize {
    solve_problem(input, 0_f64)
}

pub fn part_02(input: &InputBlocks) -> usize {
    solve_problem(input, 10000000000000_f64)
}

fn solve_problem(input: &InputBlocks, final_add_on: f64) -> usize {
    parse_input(input)
        .iter()
        .map(|block| {
            let (a, b) = solve(block, final_add_on);

            if a.round() == a && b.round() == b {
                3 * a as usize + b as usize
            } else {
                0
            }
        })
        .sum()
}

fn solve(p: &Problem, final_add_on: f64) -> (f64, f64) {
    let prize_x = p.prize_x + final_add_on;
    let prize_y = p.prize_y + final_add_on;

    let b: f64 = (prize_y * p.a_x - prize_x * p.a_y) / (p.b_y * p.a_x - p.b_x * p.a_y);
    let a: f64 = (prize_y - b * p.b_y) / p.a_y;

    (a, b)
}

fn extract_num_pair(line: &str) -> Vec<f64> {
    EXTRACT_NUM
        .find_iter(line)
        .filter_map(|m| m.as_str().parse::<f64>().ok())
        .collect()
}

fn parse_input(input: &InputBlocks) -> Vec<Problem> {
    input
        .iter()
        .map(|block| {
            let lines: Vec<&str> = block.lines().collect();

            let l0 = extract_num_pair(lines[0]);
            let l1 = extract_num_pair(lines[1]);
            let l2 = extract_num_pair(lines[2]);

            Problem {
                a_x: l0[0],
                a_y: l0[1],
                b_x: l1[0],
                b_y: l1[1],
                prize_x: l2[0],
                prize_y: l2[1],
            }
        })
        .collect()
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_blocks;

    #[test]
    fn test_1301() {
        assert_eq!(480, part_01(&input_as_blocks("13")));
    }
}
