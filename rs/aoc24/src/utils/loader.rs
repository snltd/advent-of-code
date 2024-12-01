use std::env::current_dir;
use std::fs::read_to_string;
use std::path::PathBuf;

pub type InputLines = Vec<String>;
pub type InputCols = Vec<Vec<i32>>;

fn input(day: &str) -> PathBuf {
    let pwd = current_dir().unwrap();

    for d in pwd.ancestors() {
        let path = if cfg!(test) {
            d.join("test_input").join(day)
        } else {
            d.join("input").join("2024").join(day)
        };

        if path.exists() {
            return path;
        }
    }
    panic!("Could not find input");
}

pub fn raw_input(day: &str) -> String {
    read_to_string(input(day))
        .expect("could not load input")
        .trim()
        .into()
}

pub fn input_as_lines(day: &str) -> InputLines {
    raw_input(day).lines().map(|l| l.into()).collect()
}

pub fn input_as_cols(day: &str) -> InputCols {
    let rows: Vec<Vec<i32>> = input_as_lines(day)
        .iter()
        .map(|l| {
            l.split_whitespace()
                .map(|n| n.parse::<_>().unwrap())
                .collect()
        })
        .collect();

    let column_count = rows[0].len();

    (0..column_count)
        .map(|i| rows.iter().map(|row| row[i]).collect())
        .collect()
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_input_as_lines() {
        let result = input_as_lines("01");
        assert_eq!("3   4", result[0]);
        assert_eq!(6, result.len());
    }

    #[test]
    fn test_input_as_cols() {
        assert_eq!(
            vec![vec![3, 4, 2, 1, 3, 3], vec![4, 3, 5, 3, 9, 3]],
            input_as_cols("01")
        );
    }
}
