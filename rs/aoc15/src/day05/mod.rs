use itertools::Itertools;
use regex::Regex;
use std::collections::HashSet;

fn is_nice_01(word: &str) -> bool {
    has_three_vowels(word) && has_repeated_letter(word) && !has_forbidden_words(word)
}

fn has_three_vowels(word: &str) -> bool {
    Regex::new(r"[aeiou]").unwrap().captures_iter(word).count() >= 3
}

fn has_forbidden_words(word: &str) -> bool {
    Regex::new(r"ab|cd|pq|xy").unwrap().is_match(word)
}

fn has_repeated_letter(word: &str) -> bool {
    let mut last = '\n';

    for c in word.chars() {
        if c == last {
            return true;
        }
        last = c;
    }

    false
}

fn is_nice_02(word: &str) -> bool {
    has_repeated_pair(word) && has_split_pair(word)
}

fn has_repeated_pair(word: &str) -> bool {
    let mut seen: HashSet<(char, char)> = HashSet::new();
    let mut last = ('\n', '\n');

    for (a, b) in word.chars().tuple_windows() {
        if (a, b) != last && seen.contains(&(a, b)) {
            return true;
        }

        seen.insert((a, b));
        last = (a, b);
    }

    false
}

fn has_split_pair(word: &str) -> bool {
    for (a, b, c) in word.chars().tuple_windows() {
        if a == c && a != b {
            return true;
        }
    }

    false
}

pub fn part01(input: String) -> usize {
    input.lines().filter(|l| is_nice_01(l)).count()
}

pub fn part02(input: String) -> usize {
    input.lines().filter(|l| is_nice_02(l)).count()
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_is_nice_01() {
        assert!(is_nice_01("ugknbfddgicrmopn"));
        assert!(is_nice_01("aaa"));
        assert!(!is_nice_01("jchzalrnumimnmhp"));
        assert!(!is_nice_01("haegwjzuvuyypxyu"));
        assert!(!is_nice_01("dvszwmarrgswjxmb"));
    }

    #[test]
    fn test_is_nice_02() {
        assert!(is_nice_02("qjhvhtzxzqqjkmpb"));
        assert!(is_nice_02("xxyxx"));
        assert!(!is_nice_02("uurcxstgmygtbstg"));
        assert!(!is_nice_02("ieodomkazucvgmuy"));
    }
}
