#!/usr/bin/env ruby
# frozen_string_literal: true

class Aoc202110
  PAIRS = {
    '}' => '{',
    ']' => '[',
    ')' => '(',
    '>' => '<'
  }.freeze

  SCORES = {
    '}' => 1197,
    ']' => 57,
    ')' => 3,
    '>' => 25_137
  }.freeze

  AUTO_SCORES = {
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4
  }.freeze

  def solve02(input)
    closers = input.lines.filter_map { |l| incomplete_line?(l) }.each do |l|
      l.map { |c| PAIRS.key(c) }
    end

    s = closers.map do |l|
      score = 0

      l.reverse.each do |c|
        score *= 5
        score += AUTO_SCORES[c]
      end
      score
    end

    s.sort[s.size / 2]
  end

  private

  def find_errs(str)
    stack = []

    str.each_char do |c|
      case c
      when '{', '[', '(', '<'
        stack << c
      when '}', ']', ')', '>'
        opener = stack.pop
        return c if opener != PAIRS[c]
      end
    end

    nil
  end

  def incomplete_line?(str)
    stack = []

    str.each_char do |c|
      case c
      when '{', '[', '(', '<'
        stack << c
      when '}', ']', ')', '>'
        opener = stack.pop
        return false if opener != PAIRS[c]
      end
    end

    stack
  end
end
