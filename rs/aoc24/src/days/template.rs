use crate::utils::loader::InputChars;

pub fn part_01(input: &InputChars) -> usize {
    0
}

pub fn part_02(input: &InputChars) -> usize {
    0
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_chars;

    #[test]
    fn test_0X01() {
        assert_eq!(0, part_01(&input_as_chars("0X")));
    }

    // #[test]
    // fn test_0X02() {
    //     assert_eq!(-1, part_02(&input_as_chars("0X")));
    // }
}
