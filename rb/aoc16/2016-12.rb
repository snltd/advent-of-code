#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/12
#
class Aoc201612
  def solve01(input)
    run_prog(input.parsed, 'a' => 0, 'b' => 0, 'c' => 0, 'd' => 0)
  end

  def solve02(input)
    run_prog(input.parsed, 'a' => 0, 'b' => 0, 'c' => 1, 'd' => 0)
  end

  private

  def run_prog(prog, reg)
    i = 0

    while i < prog.length
      tok = prog[i]
      i += 1

      case tok.first
      when 'cpy'
        reg[tok.last] = tok[1].is_a?(Integer) ? tok[1] : reg[tok[1]]
      when 'inc'
        reg[tok.last] += 1
      when 'dec'
        reg[tok.last] -= 1
      when 'jnz'
        flag = tok[1].is_a?(Integer) ? tok[1] : reg[tok[1]]
        i += (tok.last - 1) unless flag.zero?
      end
    end

    reg['a']
  end
end

class TestAoc201612 < Minitest::Test
  include TestBase

  def answer01
    42
  end

  def sample
    <<~EOSAMPLE
      cpy 41 a
      inc a
      inc a
      dec a
      jnz a 2
      dec a
    EOSAMPLE
  end
end
