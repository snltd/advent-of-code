#!/usr/bin/env ruby

# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/constants'
require_relative '../lib/runner'
require_relative '../lib/stdlib/time'

class TestAllAnswers < MiniTest::Test
  def test_all_answers
    ROOT.parent.join('answers').children.sort.each do |year_file|
      year = year_file.basename.to_s

      File.read(year_file).each_line do |q|
        problem, answer01, answer02, skip = q.split

        if skip
          print_test(year, problem, 0, 'SKIPPED')
          next
        end

        time_and_test(year, problem, 1, answer01)
        time_and_test(year, problem, 2, answer02)
      end
    end
  end

  private

  # Print a bar which gives a very rough indication of how long a problem took
  # to solve. (For the machine, not for me.)
  #
  def bar(duration)
    width = 78
    char = '#'
    too_long = 2 # this gets the full bar

    return if duration.is_a?(String)

    return "#{char * width}>>"  if duration > too_long

    (char * (duration * 400))[0..(width - 5)]
  end

  def time_and_test(year, problem, part, answer)
    return if answer.nil?

    t_start = Time.right_now
    answer = answer.to_i if answer.match?(/^\d+$/)
    assert_equal(answer,
                 Runner.new(year, problem, part).solve!,
                 "error on #{year}-#{problem} part #{part}")
    print_test(year, problem, part, (Time.right_now - t_start).round(3))
  end

  def print_test(year, problem, part, duration)
    puts format('%<year>4d-%<day>02d-%<part>02d %<duration>9s %<bar>s',
                year: year.to_i,
                day: problem.to_i,
                part: part.to_i,
                duration: duration,
                bar: bar(duration))
  end
end
