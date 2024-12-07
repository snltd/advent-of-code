use crate::utils::loader::InputLines;

pub fn part_01(input: &InputLines) -> usize {
    let mut ret = 0;

    for row in input {
        ret += process_line(row);
    }

    ret
}

fn process_line(row: &str) -> usize {
    let chunks: Vec<&str> = row.split(": ").collect();
    let ck = chunks[0].parse::<usize>().unwrap();
    let nums: Vec<usize> = chunks[1]
        .split_whitespace()
        .map(|n| n.parse::<usize>().unwrap())
        .collect();

    let mut start_vec: Vec<usize> = vec![nums[0]];

    for val in nums[1..].iter() {
        let mut new_vec: Vec<usize> = Vec::new();
        for s in start_vec.iter() {
            let n_mult = s * val;
            let n_plus = s + val;

            if n_mult <= ck {
                new_vec.push(n_mult);
            }

            if n_plus <= ck {
                new_vec.push(n_plus);
            }
        }

        start_vec = new_vec;
    }

    if start_vec.contains(&ck) {
        ck
    } else {
        0
    }
}

pub fn part_02(input: &InputLines) -> usize {
    let mut ret = 0;

    for row in input {
        ret += process_line_02(row);
    }

    ret
}

fn process_line_02(row: &str) -> usize {
    let chunks: Vec<&str> = row.split(": ").collect();
    let ck = chunks[0].parse::<usize>().unwrap();
    let nums: Vec<usize> = chunks[1]
        .split_whitespace()
        .map(|n| n.parse::<usize>().unwrap())
        .collect();

    let mut start_vec: Vec<usize> = vec![nums[0]];

    for val in nums[1..].iter() {
        let mut new_vec: Vec<usize> = Vec::new();
        for s in start_vec.iter() {
            let n_mult = s * val;
            let n_plus = s + val;
            let n_concat = format!("{s}{val}").parse::<usize>().unwrap();

            if n_mult <= ck {
                new_vec.push(n_mult);
            }

            if n_plus <= ck {
                new_vec.push(n_plus);
            }

            if n_concat <= ck {
                new_vec.push(n_concat);
            }
        }

        start_vec = new_vec;
    }

    if start_vec.contains(&ck) {
        ck
    } else {
        0
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_lines;

    #[test]
    fn test_0101() {
        assert_eq!(3749, part_01(&input_as_lines("07")));
    }

    #[test]
    fn test_0102() {
        assert_eq!(11387, part_02(&input_as_lines("07")));
    }
}
