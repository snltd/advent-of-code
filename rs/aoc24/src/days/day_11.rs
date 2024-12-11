use crate::utils::loader::InputWords;
use std::collections::HashMap;

type Tally = HashMap<String, usize>;

pub fn part_01(input: &InputWords) -> usize {
    let mut stones = init(input);

    for _ in 0..25 {
        stones = update_stones(&stones);
    }

    stones.values().sum()
}

pub fn part_02(input: &InputWords) -> usize {
    let mut stones = init(input);

    for _ in 0..75 {
        stones = update_stones(&stones);
    }

    stones.values().sum()
}

fn apply_rules(stone: &str) -> Vec<String> {
    if stone == "0" {
        vec!["1".to_string()]
    } else {
        let digits = stone.len();
        if digits % 2 == 0 {
            let halfway = digits / 2;
            let first_half = &stone[0..halfway];
            let mut last_half = stone[halfway..].trim_start_matches('0');

            if last_half.is_empty() {
                last_half = "0";
            }

            vec![first_half.to_string(), last_half.to_string()]
        } else {
            let num = stone.parse::<usize>().unwrap();
            vec![(num * 2024).to_string()]
        }
    }
}

fn init(input: &InputWords) -> Tally {
    let mut ret = HashMap::new();

    for num in input {
        ret.entry(num.to_string())
            .and_modify(|count| *count += 1)
            .or_insert(1);
    }

    ret
}

fn update_stones(stones: &Tally) -> Tally {
    let mut ret = HashMap::new();

    for (num, count) in stones {
        let new_nums = apply_rules(num);
        for n in new_nums {
            ret.entry(n).and_modify(|c| *c += *count).or_insert(*count);
        }
    }

    ret
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_words;

    #[test]
    fn test_1101() {
        assert_eq!(55312, part_01(&input_as_words("11")));
    }
}
