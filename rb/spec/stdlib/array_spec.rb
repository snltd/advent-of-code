#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/stdlib/array'

# Test array extensions
#
class TestArray < MiniTest::Test
  def test_to_i
    assert_equal([1, 2, 3], %w[1 2 3].to_i)
    assert_equal([1, 2, 3], [1, 2, 3].to_i)
    assert_equal([], [].to_i)
  end
end
