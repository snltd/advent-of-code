#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/3
# Squares With Three Sides
#
class Aoc201603
  def solve01(input)
    input.as_lines.count { |t| possible?(*t.split.map(&:to_i).sort) }
  end

  def solve02(input)
    input.as_lines.each_slice(3).sum do |block|
      block.map { |b| b.split.map(&:to_i) }.transpose.count do |t|
        possible?(*t.sort)
      end
    end
  end

  private

  def possible?(a, b, c)
    (a + b) > c
  end
end
