use std::collections::HashMap;
use std::hash::Hash;

pub fn frequencies<T>(input: Vec<T>) -> HashMap<T, u32>
where
    T: Eq + Hash + Copy,
{
    input.iter().copied().fold(HashMap::new(), |mut map, val| {
        map.entry(val).and_modify(|freq| *freq += 1).or_insert(1);
        map
    })
}
