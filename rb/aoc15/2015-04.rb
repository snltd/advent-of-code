#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

require 'digest'

# https://adventofcode.com/2015/day/4
# The Ideal Stocking Stuffer
#
class Aoc201504
  def solve01(input)
    hash(input, 5)
  end

  def solve02(input)
    hash(input, 6)
  end

  private

  def hash(key, zeros)
    n = 1
    match = '0' * zeros

    loop do
      h = Digest::MD5.hexdigest("#{key}#{n}")
      return n if h.start_with?(match)

      n += 1
    end
  end
end

# Tests
#
class TestAoc201504 < Minitest::Test
  include TestBase

  def table01
    {
      abcdef: 609_043,
      pqrstuv: 1_048_970
    }
  end

  def slow_test
    ['01']
  end
end
