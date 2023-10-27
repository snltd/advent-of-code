#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/1
#
class Aoc201607
  def solve01(input)
    input.as_lines.count do |ip|
      supports_tls?(ip)
    end
  end

  def solve02(input)
    input.as_lines.count do |ip|
      supports_ssl?(ip)
    end
  end

  private

  def supports_tls?(ip)
    blocks = ip.split(/[\[\]]/)
    seen_ok_abba = seen_bad_abba = false

    blocks.each_with_index do |b, i|
      if i.even? && contains_abba?(b)
        seen_ok_abba = true
      elsif i.odd? && contains_abba?(b)
        seen_bad_abba = true
      end
    end

    seen_ok_abba && !seen_bad_abba
  end

  def contains_abba?(str)
    str.chars.each_cons(4).any? { |seg| abba?(seg) }
  end

  def abba?(seg)
    seg[0] == seg[3] && seg[1] == seg[2] && seg[0] != seg[1]
  end

  def supports_ssl?(ip)
    blocks = ip.split(/[\[\]]/)
    evens = blocks.select.with_index { |_b, i| i.even? }
    odds = blocks.select.with_index { |_b, i| i.odd? }

    abas = evens.flat_map { |b| b.chars.each_cons(3).select { |s| aba?(s) } }

    abas.each do |aba|
      bab = [aba[1], aba[0], aba[1]].join
      return true if odds.any? { |o| o.include?(bab) }
    end

    false
  end

  def aba?(seg)
    seg[0] == seg[2] && seg[0] != seg[1]
  end
end

class TestAoc201607 < Minitest::Test
  include TestBase

  def table01
    {
      'abba[mnop]qrst': 1,
      'abcd[bddb]xyyx': 0,
      'aaaa[qwer]tyui': 0,
      'ioxxoj[asdfgh]zxcvbn': 1
    }
  end

  def table02
    {
      'aba[bab]xyz': 1,
      'xyx[xyx]xyx': 0,
      'aaa[kek]eke': 1,
      'zazbz[bzb]cdb': 1
    }
  end
end
