#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/14
#
class Aoc201514
  STEPS = 2503

  def solve01(input)
    parse(input).map { |r| distance(*r, STEPS) }.max
  end

  def solve02(input)
    input = parse(input)
    points = Array.new(input.size, 0)

    1.upto(STEPS) do |t|
      dist = input.map { |r| distance(*r, t) }
      leader_dist = dist.max

      dist.each_index.select { |i| dist[i] == leader_dist }
          .each { |i| points[i] += 1 }
    end

    points.max
  end

  private

  def parse(input)
    input.as_lines.map { |x| x.split.to_i.reject(&:zero?) }
  end

  def distance(speed, fly_time, rest_time, target)
    complete, part = target.divmod(fly_time + rest_time)
    part = fly_time if part > fly_time
    (complete * speed * fly_time) + (part * speed)
  end
end

class TestAoc201514 < Minitest::Test
  include TestBase

  def answer01
    2660
  end

  def answer02
    1564
  end

  def sample
    <<~EOSAMPLE
      Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
      Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    EOSAMPLE
  end
end
