use crate::utils::loader::InputChars;

fn expand_input(input: &InputChars) -> Vec<isize> {
    let mut ret: Vec<isize> = Vec::new();
    let mut is_data = true;
    let mut file_id = 0;

    for c in input[0].iter() {
        let num = c.to_string().parse::<usize>().unwrap();

        if is_data {
            ret.extend(vec![file_id; num]);
            file_id += 1;
        } else {
            ret.extend(vec![-1; num]);
        }

        is_data = !is_data;
    }

    ret
}

fn holes(expanded_input: &[isize]) -> Vec<usize> {
    expanded_input
        .iter()
        .enumerate()
        .filter_map(|(i, &v)| if v == -1 { Some(i) } else { None })
        .collect()
}

fn files(expanded_input: &[isize]) -> Vec<usize> {
    expanded_input
        .iter()
        .enumerate()
        .filter_map(|(i, &v)| if v != -1 { Some(i) } else { None })
        .collect()
}

fn checksum(expanded: &[isize]) -> usize {
    let mut ret = 0;

    for (i, &v) in expanded.iter().enumerate() {
        if v == -1 {
            break;
        }
        ret += i * v as usize;
    }

    ret
}

pub fn part_01(input: &InputChars) -> usize {
    let mut expanded = expand_input(input);
    let mut files = files(&expanded);

    for i in holes(&expanded) {
        let last_file_index = files.pop().unwrap();
        if i < last_file_index {
            expanded.swap(i, last_file_index);
        }
    }

    checksum(&expanded)
}

type Hole = (usize, usize); // start, length
type File = (usize, usize, usize); // start, length, value

fn expand_input_02(input: &InputChars) -> (Vec<File>, Vec<Hole>) {
    let mut files: Vec<File> = Vec::new();
    let mut holes: Vec<Hole> = Vec::new();
    let mut is_data = true;
    let mut file_id = 0;
    let mut index = 0;

    for c in input[0].iter() {
        let length = c.to_string().parse::<usize>().unwrap();

        if is_data {
            files.push((index, length, file_id));
            index += length;
            file_id += 1;
        } else {
            holes.push((index, length));
            index += length;
        }

        is_data = !is_data;
    }

    files.reverse();
    (files, holes)
}

pub fn part_02(input: &InputChars) -> usize {
    let (files, mut holes) = expand_input_02(input);
    let files: Vec<File> = files
        .iter()
        .map(|f| {
            let (mut file_start, file_length, file_value) = f;

            for (i, h) in holes.iter().enumerate() {
                let (hole_start, hole_length) = h;

                if hole_start < &file_start && hole_length >= file_length {
                    file_start = *hole_start;
                    if file_length == hole_length {
                        holes.remove(i);
                    } else {
                        let new_hole_length = hole_length - file_length;
                        let new_hole_start = hole_start + hole_length - new_hole_length;
                        holes[i] = (new_hole_start, new_hole_length);
                    }
                    break;
                }
            }
            (file_start, *file_length, *file_value)
        })
        .collect();

    let mut ret = 0;
    for f in files {
        let (file_start, file_length, file_value) = f;
        (file_start..(file_start + file_length)).for_each(|v| ret += v * file_value);
    }
    ret
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::utils::loader::input_as_chars;

    #[test]
    fn test_0901() {
        assert_eq!(1928, part_01(&input_as_chars("09")));
    }

    #[test]
    fn test_0902() {
        assert_eq!(2858, part_02(&input_as_chars("09")));
    }
}
