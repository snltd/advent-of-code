#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202006
  def solve01(input)
    input.as_chunks.sum { |answers| yeses(answers) }
  end

  def solve02(input)
    input.as_chunks.sum { |q| unanimous_yeses(q) }
  end

  def yeses(answers)
    answers.gsub(/\s+/, '').chars.uniq.size
  end

  def unanimous_yeses(answers)
    people = answers.split("\n")
    all_answers(answers).count { |q| people.all? { |p| p.include?(q) } }
  end

  def all_answers(answers)
    answers.gsub(/\s+/, '').chars.uniq
  end
end

class TestAoc202006 < MiniTest::Test
  include TestBase

  def answer01
    11
  end

  def answer02
    6
  end

  def sample
    <<~EOSAMPLE
      abc

      a
      b
      c

      ab
      ac

      a
      a
      a
      a

      b
    EOSAMPLE
  end

  def test_yeses
    assert_equal(3, @c.yeses('abc'))
    assert_equal(3, @c.yeses("a\nb\nc"))
    assert_equal(3, @c.yeses("ab\nac"))
    assert_equal(1, @c.yeses("a\na\na\na"))
    assert_equal(1, @c.yeses('b'))
  end

  def test_all_answers
    assert_equal(%w[a b c], @c.all_answers("a\nab\nac"))
  end

  def test_unanimous_yeses
    assert_equal(3, @c.unanimous_yeses('abc'))
    assert_equal(0, @c.unanimous_yeses("a\nb\nc"))
    assert_equal(1, @c.unanimous_yeses("ab\nac"))
    assert_equal(1, @c.unanimous_yeses("a\na\na\na"))
    assert_equal(1, @c.unanimous_yeses('b'))
  end
end
