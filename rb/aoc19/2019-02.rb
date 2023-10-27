#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'
require_relative 'lib/intcode'

class Aoc201902
  def solve01(input)
    run_modified_program(input, 12, 2)
  end

  def solve02(input)
    50.upto(100) do |val1|
      1.upto(100) do |val2|
        ret = run_modified_program(input, val1, val2)
        return (val1 * 100) + val2 if ret == 19_690_720
      end
    end
  end

  def run_modified_program(input, val1, val2)
    input = input.dup.as_intcode.tap do |i|
      i[1] = val1
      i[2] = val2
    end

    computer = Intcode::Computer.new
    computer.run!(input)
    computer.prog[0]
  end
end

class TestAoc201902 < Minitest::Test
  include TestBase

  def table01
    {
      '1,0,0,0,99': 2
    }
  end
end
