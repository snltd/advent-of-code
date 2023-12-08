#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2023/day/08
#
class Aoc202308
  def solve01(input)
    steps, nodes = input.as_blocks
    nodes = process(nodes)

    node = 'AAA'
    count = 0

    loop do
      steps.each_char do |s|
        node = s == 'L' ? nodes[node][0] : nodes[node][1]
        count += 1
        return count if node == 'ZZZ'
      end
    end
  end

  def solve02(input)
    steps, nodes = input.as_blocks
    nodes = process(nodes)
    tally = {}

    nodes.keys.select { |k| k.end_with?('A') }.map do |node|
      tally[node] = traverse(node, steps, nodes)
    end

    tally.values.lcm
  end

  def traverse(node, steps, nodes)
    count = 0

    loop do
      steps.each_char do |s|
        node = s == 'L' ? nodes[node][0] : nodes[node][1]
        count += 1
        return count if node.end_with?('Z')
      end
    end
  end

  def process(input)
    input.as_lines.to_h do |l|
      bits = l.split(/[^[\w]]+/)
      [bits[0], bits[1..2]]
    end
  end
end

class TestAoc202308 < Minitest::Test
  include TestBase

  def answer01
    6
  end

  def answer02
    6
  end

  def sample01
    <<~EOSAMPLE
      LLR

      AAA = (BBB, BBB)
      BBB = (AAA, ZZZ)
      ZZZ = (ZZZ, ZZZ)
    EOSAMPLE
  end

  def sample02
    <<~EOSAMPLE
      LR

      11A = (11B, XXX)
      11B = (XXX, 11Z)
      11Z = (11B, XXX)
      22A = (22B, XXX)
      22B = (22C, 22C)
      22C = (22Z, 22Z)
      22Z = (22B, 22B)
      XXX = (XXX, XXX)
    EOSAMPLE
  end
end
