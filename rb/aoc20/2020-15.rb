#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202015
  def solve01(input)
    solve_for(input.as_lines.first.split(',').map(&:to_i), 2020)
  end

  def solve_for(list, stop_at)
    return list.last if list.size == stop_at

    last = list.pop # modifies list!
    new = list.include?(last) ? list.size - list.rindex(last) : 0

    solve_for(list.append(last, new), stop_at)
  end

  def solve02(input)
    @target = 30_000_000
    solve_for02(input.as_lines.first, @target)
  end

  def solve_for02(input, stop_at)
    numeric_input = input.split(',').map(&:to_i)
    @memo = setup_memo(numeric_input)

    last_number = numeric_input.last

    Range.new(numeric_input.size, stop_at, true).each do |i|
      last_number = process(last_number, i)
    end

    last_number
  end

  def setup_memo(numeric_input)
    numeric_input[0..-2].each.with_index(1).with_object([]) do |(n, i), a|
      a[n.to_i] = i
    end
  end

  def process(num, index)
    next_num = @memo[num].nil? ? 0 : index - @memo[num]
    @memo[num] = index
    next_num
  end
end

class TestAoc202015 < MiniTest::Test
  include TestBase

  def table01
    {
      '1,3,2': 1,
      '2,1,3': 10,
      '1,2,3': 27,
      '2,3,1': 78,
      '3,2,1': 438,
      '3,1,2': 1836
    }
  end

  def table02
    {
      '0,3,6': 175_594
      # '1,3,2': 2578,
      # '2,1,3': 3544142,
      # '1,2,3': 261214,
      # '2,3,1': 6895259,
      # '3,2,1': 18,
      # '3,1,2': 362
    }
  end

  def test_setup_memo
    assert_equal([1, nil, nil, 2], @c.setup_memo(%w[0 3 6]))
  end
end
