use crate::utils::loader::InputRows;

pub fn part_01(input: InputRows) -> usize {
    0
}

pub fn part_02(input: InputRows) -> usize {
    0
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_rows;

    #[test]
    fn test_0101() {
        assert_eq!(-1, part_01(&input_as_rows("01")));
    }

    #[test]
    fn test_0102() {
        assert_eq!(-1, part_02(&input_as_rows("01")));
    }
}
