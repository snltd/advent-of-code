use crate::utils::loader::InputLines;

type Letters = Vec<char>;

pub fn part_01(input: &InputLines) -> i32 {
    let width: i32 = input[0].len() as i32 + 2;
    let padded_lines: Vec<String> = input.iter().map(|l| format!(".{}.", l)).collect();
    let padded_input: String = padded_lines.join("");
    let letters: Letters = padded_input.chars().collect();
    let mut found = 0;

    for i in 0..=letters.len() {
        for offset in [1, width, width - 1, width + 1] {
            if offset_search(&letters, i, offset) {
                found += 1;
            }

            if offset_search(&letters, i, -offset) {
                found += 1;
            }
        }
    }

    found
}

fn offset_search(letters: &Letters, index: usize, offset: i32) -> bool {
    [(0, &'X'), (1, &'M'), (2, &'A'), (3, &'S')]
        .iter()
        .all(|(m, c)| letter_at(letters, (index as i32 + m * offset) as usize, c))
}

fn letter_at(letters: &Letters, index: usize, desired: &char) -> bool {
    match letters.get(index) {
        Some(c) => c == desired,
        None => false,
    }
}

pub fn part_02(input: &InputLines) -> i32 {
    let width = input[0].len() + 2;
    let padded_lines: Vec<String> = input.iter().map(|l| format!(".{}.", l)).collect();
    let padded_input: String = padded_lines.join("");
    let letters: Letters = padded_input.chars().collect();
    let mut found: i32 = 0;

    for i in 0..=letters.len() {
        found += mas_search(&letters, i, width);
    }

    found
}

fn mas_search(letters: &Letters, index: usize, width: usize) -> i32 {
    let mut matches = 0;
    let arrangements = [
        [
            (0, &'M'),
            (2, &'S'),
            (width + 1, &'A'),
            (2 * width, &'M'),
            (2 * width + 2, &'S'),
        ],
        [
            (0, &'M'),
            (2, &'M'),
            (width + 1, &'A'),
            (2 * width, &'S'),
            (2 * width + 2, &'S'),
        ],
        [
            (0, &'S'),
            (2, &'S'),
            (width + 1, &'A'),
            (2 * width, &'M'),
            (2 * width + 2, &'M'),
        ],
        [
            (0, &'S'),
            (2, &'M'),
            (width + 1, &'A'),
            (2 * width, &'S'),
            (2 * width + 2, &'M'),
        ],
    ];

    for a in arrangements {
        if a.iter().all(|(m, c)| letter_at(letters, index + m, c)) {
            matches += 1;
        }
    }
    matches
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_lines;

    #[test]
    fn test_0401() {
        assert_eq!(18, part_01(&input_as_lines("04")));
    }

    #[test]
    fn test_0402() {
        assert_eq!(9, part_02(&input_as_lines("04")));
    }
}
