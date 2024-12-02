use crate::utils::loader::InputRows;

pub fn part_01(input: &InputRows) -> i32 {
    input.iter().filter(|r| row_is_safe_01(r)).count() as i32
}

fn row_is_safe_01(row: &[i32]) -> bool {
    let mut increasing = None;

    for pair in row.windows(2) {
        let difference = pair[1] - pair[0];
        let increased = difference > 0;

        if increasing.map_or(false, |inc| inc != increased) || !(1..=3).contains(&difference.abs())
        {
            return false;
        }

        increasing = Some(increased);
    }

    true
}

pub fn part_02(input: &InputRows) -> i32 {
    input.iter().filter(|r| row_is_safe_02(r)).count() as i32
}

fn row_is_safe_02(row: &[i32]) -> bool {
    if row_is_safe_01(row) {
        return true;
    }

    for n in 0..row.len() {
        let row_with_nth_removed = [row[..n].to_vec(), row[n + 1..].to_vec()].concat();

        if row_is_safe_01(&row_with_nth_removed) {
            return true;
        }
    }

    false
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_rows;

    #[test]
    fn test_0201() {
        assert_eq!(2, part_01(&input_as_rows("02")));
    }

    #[test]
    fn test_0202() {
        assert_eq!(4, part_02(&input_as_rows("02")));
    }
}
