#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc201906
  def solve01(input)
    sum_of_all_paths(orbit_tree(input))
  end

  def solve02(input)
    hops_between(orbit_tree(input), 'YOU', 'SAN')
  end

  private

  def sum_of_all_paths(tree)
    tree.keys.sum { |v| trace_path(tree, v) }
  end

  def orbit_tree(input)
    input.split.each_with_object({}) do |l, aggr|
      parent, id = l.split(')')
      aggr[id] = parent
    end
  end

  def trace_path(tree, node, hops = 0)
    orbits = tree[node]
    return hops if orbits.nil?

    trace_path(tree, orbits, hops + 1)
  end

  def trace_path02(tree, node, path = [])
    orbits = tree[node]
    return path if orbits.nil?

    trace_path02(tree, orbits, path.<<(orbits))
  end

  def hops_between(tree, first, second)
    p1 = trace_path02(tree, first)
    p2 = trace_path02(tree, second)

    common = (p1 & p2).first
    (p1.index(common) + p2.index(common))
  end
end

class TestAoc201906 < Minitest::Test
  include TestBase

  def answer01
    42
  end

  def sample01
    <<~EOSAMPLE
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
    EOSAMPLE
  end

  def answer02
    4
  end

  def sample02
    <<~EOSAMPLE
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
      K)YOU
      I)SAN
    EOSAMPLE
  end
end
