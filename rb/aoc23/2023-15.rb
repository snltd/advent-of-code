#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2023/day/15
#
class Aoc202315
  def solve01(input)
    input.strip.split(',').sum { |c| hash(c) }
  end

  def solve02(input)
    @boxes = Hash.new { |h, k| h[k] = {} }
    input.strip.split(',').each { |c| hashmap(c) }
    @boxes.sum { |n, v| box_total(n, v) }
  end

  private

  def box_total(num, box)
    box.each.with_index(1).sum { |(_l, f), i| (1 + num) * f.to_i * i }
  end

  def hash(str)
    str.each_char.inject(0) { |r, c| ((r + c.ord) * 17).remainder(256) }
  end

  def hashmap(str)
    label, focal_length = str.split(/[=-]/)
    box = hash(label)

    return @boxes[box][label] = focal_length if str.include?('=')

    @boxes[box] = @boxes[box].reject { |k, _v| k == label }
  end
end

class TestAoc202315 < Minitest::Test
  include TestBase

  def answer01
    1320
  end

  def answer02
    145
  end

  def sample
    <<~EOSAMPLE
      rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    EOSAMPLE
  end
end
