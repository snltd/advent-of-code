#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202016
  def solve01(input)
    rules, _, nearby = input.as_blocks
    rules = parse_rules(rules)

    parse_tickets(nearby).each_with_object([]) do |t, aggr|
      aggr.concat(validate_ticket(t, rules))
    end.sum
  end

  def parse_rules(rules)
    rules.lines.to_h { |r| r.split(':') }.transform_values do |v|
      parse_rule(v)
    end
  end

  def parse_rule(rule)
    rule.split('or').map(&:strip).map do |r|
      low, high = r.split('-')
      Range.new(low.to_i, high.to_i).to_a
    end.flatten
  end

  def parse_tickets(tickets)
    tickets.lines.map { |t| t.split(',') }.map(&:to_i)
  end

  def validate_ticket(numbers, rules)
    numbers.reject { |n| rules.values.any? { |v| v.include?(n) } }
  end
end

class TestAoc202016 < Minitest::Test
  include TestBase

  def answer01
    71
  end

  def sample
    <<~EOINPUT
      class: 1-3 or 5-7
      row: 6-11 or 33-44
      seat: 13-40 or 45-50

      your ticket:
      7,1,14

      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
    EOINPUT
  end

  def test_parse_rules
    assert_equal({ 'class' => [1, 2, 3, 5, 6, 7],
                   'row' => [4, 5, 8, 9] },
                 @c.parse_rules("class: 1-3 or 5-7\nrow: 4-5 or 8-9"))
  end

  def test_parse_rule
    assert_equal([1, 2, 3, 4, 8, 9, 10], @c.parse_rule('1-4 or 8-10'))
  end
end
