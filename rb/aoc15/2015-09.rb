#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/9
#
class Aoc201509
  def solve01(input)
    input = process(input)
    @routes = routes(input)
    @routes.min
  end

  def solve02(input)
    return @routes.max if @routes

    input = process(input)
    routes(input).max
  end

  private

  def routes(input)
    input.keys.map(&:first).uniq.permutation.map { |p| paths(input, p) }
  end

  def paths(input, route)
    route.each_cons(2).map { |pair| input[pair] }.sum
  end

  def process(input)
    input.as_lines.map(&:split).each.with_object({}) do |e, ret|
      ret[[e[0], e[2]]] = e[4].to_i
      ret[[e[2], e[0]]] = e[4].to_i
    end
  end
end

class TestAoc201509 < MiniTest::Test
  include TestBase

  def answer01
    605
  end

  def answer02
    982
  end

  def sample
    <<~EOSAMPLE
      London to Dublin = 464
      London to Belfast = 518
      Dublin to Belfast = 141
    EOSAMPLE
  end
end
