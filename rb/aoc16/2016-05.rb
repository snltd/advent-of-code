#!/usr/bin/env ruby

# frozen_string_literal: true

require 'digest'
require_relative '../lib/base'

# https://adventofcode.com/2016/day/5
#
class Aoc201605
  def solve01(input)
    i = 0
    @winners = []
    ret = +''

    loop do
      d = Digest::MD5.hexdigest("#{input}#{i}")

      if d.start_with?('00000')
        ret << d[5]
        @winners << i
        return ret if ret.length == 8
      end

      i += 1
    end
  end

  def solve02(input)
    ret = +'________'
    i = 0

    if @winners
      @winners.each do |i|
        d = Digest::MD5.hexdigest("#{input}#{i}")
        idx = d[5]
        ret[idx.to_i] = d[6] if ret[idx.to_i] == '_' && idx.match?(/[0-7]/)
      end

      i = @winners.last + 1
    end

    loop do
      d = Digest::MD5.hexdigest("#{input}#{i}")

      if d.start_with?('00000')
        idx = d[5]
        ret[idx.to_i] = d[6] if ret[idx.to_i] == '_' && idx.match?(/[0-7]/)

        return ret unless ret.include?('_')
      end

      i += 1
    end
  end
end

class TestAoc201605 < Minitest::Test
  include TestBase

  def answer01
    '18f47a30'
  end

  def sample
    'abc'
  end

  def answer02
    '05ace8e3'
  end
end
