#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/machine_chain'

class TestMachineChain < Minitest::Test
  def setup
    @c = Intcode::MachineChain.new(5)
  end

  def test_machine_chain01
    assert_equal(
      43_210,
      @c.run('3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0'.as_intcode,
             [4, 3, 2, 1, 0])
    )
  end

  def test_machine_chain02
    assert_equal(
      54_321,
      @c.run('3,23,3,24,1002,24,10,24,1002,23,-1,23,' \
             '101,5,23,23,1,24,23,23,4,23,99,0,0'.as_intcode,
             [0, 1, 2, 3, 4])
    )
  end

  def test_machine_chain03
    assert_equal(
      65_210,
      @c.run('3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,' \
             '31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,' \
             '31,99,0,0,0'.as_intcode,
             [1, 0, 4, 3, 2])
    )
  end

  def test_feedback_chain01
    assert_equal(
      139_629_729,
      @c.feedback_loop('3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,' \
                       '27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5'.as_intcode,
                       [9, 8, 7, 6, 5])
    )
  end

  def test_feedback_chain02
    assert_equal(
      139_629_729,
      @c.feedback_loop('3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,' \
                       '27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5'.as_intcode,
                       [9, 8, 7, 6, 5])
    )
  end
end
