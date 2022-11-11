//use md5;
extern crate crypto;
use crypto::md5::Md5;
use crypto::digest::Digest;

fn solve(key: &str, start_str: &str) -> u32 {
    let mut c = 333333;
    let mut hasher = Md5::new();

    loop {
        hasher.input_str(format!("{}{}", key, c).as_str());
        let hash_result = hasher.result_str();
        
        if hash_result.starts_with(start_str) {
            return c;
        }

        hasher.reset();
        c += 1;
    }
}

pub fn part01(input: &str) -> u32 {
    solve(input, "00000")
}

pub fn part02(input: &str) -> u32 {
    solve(input, "000000")
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part01() {
        assert_eq!(609043, part01("abcdef"));
        assert_eq!(1048970, part01("pqrstuv"));
    }
}