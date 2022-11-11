#!/usr/bin/env ruby

# frozen_string_literal: true

require 'json'
require_relative '../lib/base'

# https://adventofcode.com/2015/day/12
#
class Aoc201512
  def solve01(input)
    input.split(/[^-\d]/).sum(&:to_i)
  end

  def solve02(input)
    filter_node(JSON.parse(input))
  end

  def filter_node(node, sum = 0)
    case node
    when Integer
      return sum + node
    when Array
      node.each { |n| sum = filter_node(n, sum) }
    when Hash
      return sum if node.key?('red') || node.value?('red')

      node.each { |_k, v| sum = filter_node(v, sum) }
    end

    sum
  end
end

class TestAoc201512 < MiniTest::Test
  include TestBase

  def test_filter_node1
    assert_equal(1, @c.filter_node(1))
    assert_equal(3, @c.filter_node([1, 2]))

    assert_equal(
      6,
      @c.filter_node(
        {
          a: 1,
          b: [2, 3]
        }
      )
    )

    assert_equal(
      21,
      @c.filter_node(
        {
          a: {
            aa: [1, 2],
            bb: {
              'red' => 100
            },
            cc: [3, 4, 'red']
          },
          b: [5, 6]
        }
      )
    )
  end
end
