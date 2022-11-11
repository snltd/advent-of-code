#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'
require_relative 'lib/intcode'

class Aoc201905
  def solve01(input)
    solve_it(input, 1)
  end

  def solve02(input)
    solve_it(input, 5)
  end

  private

  def solve_it(input, val)
    computer = Intcode::Computer.new
    computer.run!(input.as_intcode, [val])
    computer.output.last
  end
end
