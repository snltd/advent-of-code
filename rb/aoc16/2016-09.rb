#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/9
#
class Aoc201609
  def solve01(input)
    uncompress(input)
  end

  def solve02(input)
    uncompress(input, true)
  end

  private

  def uncompress(str, v2 = false)
    state = nil
    num_buffer = +''
    repeat_buffer = +''
    ret = i = 0

    while i < str.length
      c = str[i]
      i += 1

      if c == '('
        state = :in_marker
      elsif state == :in_marker
        if c == 'x'
          state = :in_repeat
        else
          num_buffer << c
        end
      elsif state == :in_repeat
        if c == ')'
          state = nil
          pattern = str[i...(i + num_buffer.to_i)]

          ret += if v2
                   repeat_buffer.to_i * uncompress(pattern, true)
                 else
                   pattern.length * repeat_buffer.to_i
                 end

          i += num_buffer.to_i
          num_buffer = +''
          repeat_buffer = +''
        else
          repeat_buffer << c
        end
      else
        ret += 1
      end
    end

    ret
  end
end

class TestAoc201609 < Minitest::Test
  include TestBase

  def table01
    {
      ADVENT: 6,
      'A(1x5)BC': 7,
      '(3x3)XYZ': 9,
      'A(2x2)BCD(2x2)EFG': 11,
      '(6x1)(1x3)A': 6,
      'X(8x2)(3x3)ABCY': 18
    }
  end

  def table02
    {
      ADVENT: 6,
      '(3x3)XYZ': 9,
      'X(8x2)(3x3)ABCY': 20,
      '(27x12)(20x12)(13x14)(7x10)(1x12)A': 241_920,
      '(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN': 445
    }
  end
end
