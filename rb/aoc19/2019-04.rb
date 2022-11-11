#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc201904
  def solve01(input)
    candidates(input).count do |n|
      a = n.chars
      a.sort == a
    end
  end

  def solve02(input)
    candidates(input).count do |n|
      a = n.chars
      a.sort == a && still_okay?(a)
    end
  end

  private

  def candidates(input)
    lower, upper = input.split('-').map(&:to_i)
    lower.upto(upper).map(&:to_s).reject { |n| n.squeeze == n }
  end

  def still_okay?(num_arr)
    counts = num_arr.each_with_object(Hash.new(0)) do |e, sum|
      sum[e] += 1
    end

    counts.value?(2)
  end
end
