#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202019
  def solve01(input)
    rules, messages = separate_input(input.as_blocks)

    messages.count { |m| regex(rules).match?(m) }
  end

  def separate_input(input)
    rules, messages = input.map { |l| l.split("\n") }

    rule_list = rules.each.with_object([]) do |r, aggr|
      i, r = r.split(': ')
      aggr[i.to_i] = r.delete('"')
    end

    [rule_list, messages]
  end

  def expand_rule(rule_list, index)
    rule_list[index].split.map do |r|
      ri = r.to_i

      if /^\d+$/.match?(r)
        if %w[a b].include?(rule_list[ri])
          rule_list[ri]
        else
          [expand_rule(rule_list, ri)]
        end
      else
        r
      end
    end
  end

  def regex(rule_list)
    Regexp.new('^' + expand_rule(rule_list, 0)
      .to_s.tr('[', '(')
      .tr(']', ')')
      .delete('" ,') + '$')
  end
end

class TestAoc202019 < Minitest::Test
  include TestBase

  def answer01
    2
  end

  def sample
    <<~EOINPUT
      0: 4 1 5
      1: 2 3 | 3 2
      2: 4 4 | 5 5
      3: 4 5 | 5 4
      4: "a"
      5: "b"

      ababbb
      bababa
      abbbab
      aaabbb
      aaaabbb
    EOINPUT
  end
end
