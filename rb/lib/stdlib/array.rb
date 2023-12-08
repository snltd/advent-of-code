# frozen_string_literal: true

# Extentions to the Array class, to make life simpler
#
class Array
  def to_i
    map(&:to_i)
  end

  # Make a hash lookup table out of an array
  #
  def to_hash_table
    zip(Array.new(length)).to_h
  end
end
