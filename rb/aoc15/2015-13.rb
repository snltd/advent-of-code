#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/13
#
class Aoc201513
  def solve01(input)
    solve_it(parse_input01(input))
  end

  def solve02(input)
    solve_it(parse_input02(input))
  end

  private

  def solve_it(input)
    input.keys.permutation.map { |perm| happiness_for(input, perm) }.max
  end

  def happiness_for(input, perm)
    people = perm << perm.first # close the circle
    people.each_cons(2).sum { |p| input[p[0]][p[1]] + input[p[1]][p[0]] }
  end

  def parse_input01(input)
    input.as_lines.map(&:split).each_with_object({}) do |bits, ret|
      person = bits[0]
      other = bits[-1][0..-2]
      val = bits[3].to_i

      ret[person] = {} unless ret.key?(person)

      val = 0 - val if bits[2] == 'lose'

      ret[person][other] = val
    end
  end

  def parse_input02(input)
    parse_input01(input).tap do |p|
      p.each { |person, _v| p[person]['me'] = 0 }
      p['me'] = p.keys.zip(Array.new(input.size, 0)).to_h
    end
  end
end

class TestAoc201513 < Minitest::Test
  include TestBase

  def answer01
    330
  end

  def sample
    <<~EOSAMPLE
      Alice would gain 54 happiness units by sitting next to Bob.
      Alice would lose 79 happiness units by sitting next to Carol.
      Alice would lose 2 happiness units by sitting next to David.
      Bob would gain 83 happiness units by sitting next to Alice.
      Bob would lose 7 happiness units by sitting next to Carol.
      Bob would lose 63 happiness units by sitting next to David.
      Carol would lose 62 happiness units by sitting next to Alice.
      Carol would gain 60 happiness units by sitting next to Bob.
      Carol would gain 55 happiness units by sitting next to David.
      David would gain 46 happiness units by sitting next to Alice.
      David would lose 7 happiness units by sitting next to Bob.
      David would gain 41 happiness units by sitting next to Carol.
    EOSAMPLE
  end
end
