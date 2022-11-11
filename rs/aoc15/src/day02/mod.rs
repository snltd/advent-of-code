#[derive(PartialEq, Debug)]
struct Parcel {
    w: i32,
    d: i32,
    h: i32,
    paper: i32,
    ribbon: i32,
}

impl Parcel {
    fn new(input: String) -> Parcel {
        let xyz = input
            .split('x')
            .map(|n| n.parse().unwrap())
            .collect::<Vec<i32>>();

        Parcel {
            w: xyz[0],
            d: xyz[1],
            h: xyz[2],
            paper: 0,
            ribbon: 0,
        }
    }

    fn smallest_side(&self) -> Vec<i32> {
        let mut s = vec![self.w, self.d, self.h];
        s.sort_unstable();
        s.truncate(2);
        s
    }

    fn paper(self) -> i32 {
        let s = &self.smallest_side();
        2 * self.w * self.d + 2 * self.w * self.h + 2 * self.h * self.d + s[0] * s[1]
    }

    fn ribbon(self) -> i32 {
        let s = &self.smallest_side();
        let smallest_perim = s[0] + s[1];
        let volume = self.w * self.d * self.h;
        2 * smallest_perim + volume
    }
}

pub fn part01(input: String) -> i32 {
    input
        .split('\n')
        .map(|p| Parcel::new(p.to_string()).paper())
        .sum()
}

pub fn part02(input: String) -> i32 {
    input
        .split('\n')
        .map(|p| Parcel::new(p.to_string()).ribbon())
        .sum()
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_area() {
        assert_eq!(58, Parcel::new(String::from("4x3x2")).paper());
        assert_eq!(43, Parcel::new(String::from("1x1x10")).paper());
    }

    #[test]
    fn test_ribbon() {
        assert_eq!(34, Parcel::new(String::from("2x3x4")).ribbon());
        assert_eq!(14, Parcel::new(String::from("1x1x10")).ribbon());
    }
}
