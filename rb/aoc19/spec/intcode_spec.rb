#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/intcode'
require_relative '../../lib/stdlib/string'

# Tests
#
class TestComputer < MiniTest::Test
  def setup
    @c = Intcode::Computer.new
  end

  def test_day02
    {
      '1,0,0,0,99': '2,0,0,0,99',
      '2,3,0,3,99': '2,3,0,6,99',
      '2,4,4,5,99,0': '2,4,4,5,99,9801',
      '1,1,1,4,99,5,6,0,99': '30,1,1,4,2,5,6,0,99'
    }.each do |input, expected|
      @c.run!(input.to_s.as_intcode)
      assert_equal(expected, @c.prog.join(','))
    end
  end

  def test_decoded_inst
    assert_equal([1, [0, 0, 0]], @c.decoded_inst(1))
    assert_equal([99, [0, 0, 0]], @c.decoded_inst(99))
    assert_equal([2, [0, 1, 0]], @c.decoded_inst(1002))
    assert_equal([4, [1, 1, 0]], @c.decoded_inst(1104))
    assert_equal([5, [1, 0, 1]], @c.decoded_inst(10_105))
  end

  def test_day05_input_same_as_output
    @c.run!('3,0,4,0,99'.as_intcode, [12_345])
    assert_equal([12_345], @c.output)
  end

  def test_day05_equals_position_mode
    prog = '3,9,8,9,10,9,4,9,99,-1,8'.as_intcode

    @c.run!(prog, [8])
    assert_equal([1], @c.output)

    @c.reset
    @c.run!(prog, [1])
    assert_equal([0], @c.output)
  end

  def test_day05_less_than_position_mode
    prog = '3,9,7,9,10,9,4,9,99,-1,8'.as_intcode

    @c.run!(prog, [7])
    assert_equal([1], @c.output)

    @c.reset
    @c.run!(prog, [9])
    assert_equal([0], @c.output)
  end

  def test_day05_equals_immediate_mode
    prog = '3,3,1108,-1,8,3,4,3,99'.as_intcode

    @c.run!(prog, [8])
    assert_equal([1], @c.output)

    @c.reset
    @c.run!(prog, [9])
    assert_equal([0], @c.output)
  end

  def test_day05_less_than_immediate_mode
    prog = '3,3,1107,-1,8,3,4,3,99'.as_intcode

    @c.run!(prog, [7])
    assert_equal([1], @c.output)

    @c.reset
    @c.run!(prog, [9])
    assert_equal([0], @c.output)
  end

  def test_day09_relative_mode_16_digit_number
    @c.run!('1102,34915192,34915192,7,4,7,99,0'.as_intcode)
    assert_equal(16, @c.output.first.to_s.length)
  end

  def test_day09_relative_mode_large_number
    prog = '104,1125899906842624,99'.as_intcode
    @c.run!(prog)
    assert_equal(1_125_899_906_842_624, @c.output.first)
  end

  def test_day09_relative_mode_quine
    prog = '109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99'
    @c.run!(prog.as_intcode)
    assert_equal(prog, @c.output.join(','))
  end
end
