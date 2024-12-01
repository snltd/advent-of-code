use crate::utils::helpers::frequencies;
use crate::utils::loader::InputCols;

pub fn part_01(input: InputCols) -> i32 {
    let mut left = input[0].clone();
    let mut right = input[1].clone();
    left.sort();
    right.sort();

    (0..left.len()).map(|i| (left[i] - right[i]).abs()).sum()
}

pub fn part_02(input: InputCols) -> i32 {
    let freq_l = frequencies(input[0].clone());
    let freq_r = frequencies(input[1].clone());

    let mut ret = 0;

    for (num, count) in freq_l {
        if let Some(other_col) = freq_r.get(&num) {
            ret += num * count as i32 * *other_col as i32;
        }
    }

    ret
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_cols;

    #[test]
    fn test_0101() {
        assert_eq!(11, part_01(input_as_cols("01")));
    }

    #[test]
    fn test_0102() {
        assert_eq!(31, part_02(input_as_cols("01")));
    }
}
