#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc201901
  def solve01(input)
    input.as_ints.sum { |n| (n / 3.0).floor - 2 }
  end

  def solve02(input)
    input.as_ints.sum { |n| fuel_required(n) }
  end

  def fuel_required(mass, aggr = 0)
    req = (mass / 3.0).floor - 2
    req.positive? ? fuel_required(req, aggr + req) : aggr
  end
end

class TestAoc201901 < MiniTest::Test
  include TestBase

  def table01
    {
      '12': 2,
      '14': 2,
      '1969': 654,
      '100756': 33_583
    }
  end

  def table02
    {
      '14': 2,
      '1969': 966,
      '100756': 50_346
    }
  end
end
