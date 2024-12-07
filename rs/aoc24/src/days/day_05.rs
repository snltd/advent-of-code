use crate::utils::loader::InputBlocks;
use rayon::prelude::*;
use std::collections::HashSet;

type Rules = HashSet<(usize, usize)>;
type Update = Vec<usize>;

pub fn part_01(input: &InputBlocks) -> usize {
    let rules = rules_from(&input[0]);
    let updates = updates_from(&input[1]);
    updates.par_iter().map(|u| check_update(u, &rules)).sum()
}

fn check_update(update: &Update, rules: &Rules) -> usize {
    let last = update.len();
    for i in 0..last {
        let head = &update[i];
        let tail = &update[i + 1..last];

        for n in tail.iter() {
            if !rules.contains(&(*head, *n)) {
                return 0;
            }
        }
    }

    let middle_index = (update.len() - 1) / 2;
    update[middle_index]
}

fn rules_from(raw: &str) -> Rules {
    raw.lines()
        .map(|l| {
            (
                l[0..2].parse::<usize>().unwrap(),
                l[3..=4].parse::<usize>().unwrap(),
            )
        })
        .collect()
}

fn updates_from(raw: &str) -> Vec<Update> {
    raw.lines()
        .map(|l| l.split(',').map(|n| n.parse::<usize>().unwrap()).collect())
        .collect()
}

pub fn part_02(input: &InputBlocks) -> usize {
    let rules = rules_from(&input[0]);
    let updates = updates_from(&input[1]);

    let bad_updates: Vec<&Update> = updates
        .par_iter()
        .filter(|u| check_update(u, &rules) == 0)
        .collect();

    bad_updates
        .par_iter()
        .map(|u| reorder_update(u, &rules))
        .sum()
}

fn reorder_update(update: &Update, rules: &Rules) -> usize {
    let mut new_update = update.clone();

    loop {
        for i in 0..update.len() - 1 {
            if !rules.contains(&(new_update[i], new_update[i + 1])) {
                new_update.swap(i, i + 1);
                let result = check_update(&new_update, rules);

                if result > 0 {
                    return result;
                }
            }
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_blocks;

    #[test]
    fn test_0501() {
        assert_eq!(143, part_01(&input_as_blocks("05")));
    }

    #[test]
    fn test_0502() {
        assert_eq!(123, part_02(&input_as_blocks("05")));
    }
}
