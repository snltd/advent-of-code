#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/2
# Day 2: Bathroom Security
#
class Aoc201602
  def solve01(input)
    solve_it(input, keypad01).to_i
  end

  def solve02(input)
    solve_it(input, keypad02)
  end

  private

  def keypad01
    {
      '1' => { D: '4', R: '2' },
      '2' => { L: '1', D: '5', R: '3' },
      '3' => { L: '2', D: '6' },
      '4' => { U: '1', R: '5', D: '7' },
      '5' => { U: '2', R: '6', D: '8', L: '4' },
      '6' => { U: '3', L: '5', D: '9' },
      '7' => { U: '4', R: '8' },
      '8' => { L: '7', U: '5', R: '9' },
      '9' => { L: '8', U: '6' }
    }
  end

  def keypad02
    {
      '1' => { D: '3' },
      '2' => { D: '6', R: '3' },
      '3' => { U: '1', L: '2', R: '4', D: '7' },
      '4' => { L: '3', D: '8' },
      '5' => { R: '6' },
      '6' => { U: '2', R: '7', D: 'A', L: '5' },
      '7' => { U: '3', R: '8', D: 'B', L: '6' },
      '8' => { U: '4', R: '9', D: 'C', L: '7' },
      '9' => { L: '8' },
      'A' => { U: '6', R: 'B' },
      'B' => { U: '7', R: 'C', D: 'D', L: 'A' },
      'C' => { L: 'B', U: '8' },
      'D' => { U: 'B' }
    }
  end

  def solve_it(input, keypad)
    num = '5'

    input.as_lines.each.with_object((+'')) do |line, code|
      line.each_char { |c| num = keypad[num].fetch(c.to_sym, num) }
      code.<< num
    end
  end
end

class TestAoc201602 < MiniTest::Test
  include TestBase

  def sample01
    <<~EOSAMPLE
      ULL
      RRDDD
      LURDL
      UUUUD
    EOSAMPLE
  end
  alias sample02 sample01

  def answer01
    1985
  end

  def answer02
    '5DB3'
  end
end
