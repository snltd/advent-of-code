# Make a hash lookup table out of an array
#
def hash_table(arr)
  arr.chars.zip(Array.new(arr.length)).to_h
end
