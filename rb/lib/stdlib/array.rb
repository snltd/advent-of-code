# frozen_string_literal: true

# Extentions to the Array class, to make life simpler
#
class Array
  def to_i
    map(&:to_i)
  end
end
