# frozen_string_literal: true

require_relative 'constants'

# Solve a given problem
#
class Runner
  def initialize(year, day, part)
    @year = year
    @day = day
    @part = part

    require ROOT.join(problem_file)
    @c = Object.const_get(problem_class).new
  end

  def solve!
    case @part
    when 1
      @c.solve01(input) if @c.respond_to?(:solve01)
    when 2
      @c.solve02(input) if @c.respond_to?(:solve02)
    else
      puts "unsolved problem #{@year}-#{@day}"
    end
  end

  def solve_and_print!
    case @part
    when 1
      printer(1, @c.solve01(input)) if @c.respond_to?(:solve01)
    when 2
      printer(2, @c.solve02(input)) if @c.respond_to?(:solve02)
    else
      printer(1, @c.solve01(input)) if @c.respond_to?(:solve01)
      printer(2, @c.solve02(input)) if @c.respond_to?(:solve02)
    end
  end

  private

  def printer(part, solution)
    puts "#{@year}-#{@day} part 0#{part}    #{solution}"
  end

  def input
    File.read(input_file).strip
  end

  def input_file
    ROOT.parent.join('input', @year, @day)
  end

  def problem_class
    "Aoc#{@year}#{@day}"
  end

  def problem_file
    "aoc#{@year[2..3]}/#{@year}-#{@day}"
  end
end
