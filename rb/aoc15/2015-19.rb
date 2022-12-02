#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/19
#
class Aoc201519
  def solve01(input)
    maps, string = process(input)

    ret = []

    maps.take(1).each do |k, v|
      puts "replace #{k} with #{v}"
      string.gsub(k).each do |merp|
        puts merp
      end
    end

    exit
    ret
  end

  def solve02(input)
    input
  end

  def process(input)
    maps, string = input.as_blocks
    maps = maps.as_lines.map { |l| l.split(' => ') }
    [maps, string]
  end
end

class TestAoc201519 < MiniTest::Test
  include TestBase

  def answer01
    0
  end

  def answer02
    0
  end

  def sample
    <<~EOSAMPLE
      H => HO
      H => OH
      O => HH

      HOH
    EOSAMPLE
  end
end
