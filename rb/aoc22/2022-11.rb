#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/11
#
class Aoc202211
  def solve01(input)
    solve_it(input, 20)
  end

  def solve02(input)
    solve_it(input, 10_000, use_lcm: true)
  end

  # rubocop:disable Metrics/AbcSize
  def solve_it(input, iterations, use_lcm: false)
    monkeys = input.as_blocks.map { |b| parse(b) }
    inspections = Array.new(monkeys.size, 0)
    lcm = monkeys.map { |m| m[:divisor] }.inject(:*) if use_lcm

    iterations.times do
      monkeys.each_with_index do |m, i|
        until m[:items].empty?
          wl = m[:items].shift
          inspections[i] += 1
          wl = m[:op].call(wl)
          wl = use_lcm ? wl % lcm : wl / 3
          monkeys[m[:test].call(wl)][:items] << wl
        end
      end
    end

    inspections.sort.reverse.take(2).inject(:*)
  end

  # rubocop:disable Lint/UnusedBlockArgument
  # rubocop:disable Security/Eval
  def parse(block)
    raw = block.as_lines.map { |l| l.strip.split(': ') }

    divisor = raw[3].last.split.last.to_i

    {
      items: raw[1].last.split(/[, ]+/).map(&:to_i),
      op: ->(old) { eval(raw[2].last.split(' = ').last) },
      test: lambda do |val|
        ((val % divisor).zero? ? raw[4] : raw[5]).last.split.last.to_i
      end,
      divisor:
    }
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Security/Eval
  # rubocop:enable Lint/UnusedBlockArgument
end

class TestAoc202211 < Minitest::Test
  include TestBase

  def answer01
    10_605
  end

  def answer02
    2_713_310_158
  end

  def sample
    <<~EOSAMPLE
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3

      Monkey 1:
        Starting items: 54, 65, 75, 74
        Operation: new = old + 6
        Test: divisible by 19
          If true: throw to monkey 2
          If false: throw to monkey 0

      Monkey 2:
        Starting items: 79, 60, 97
        Operation: new = old * old
        Test: divisible by 13
          If true: throw to monkey 1
          If false: throw to monkey 3

      Monkey 3:
        Starting items: 74
        Operation: new = old + 3
        Test: divisible by 17
          If true: throw to monkey 0
          If false: throw to monkey 1
    EOSAMPLE
  end
end
