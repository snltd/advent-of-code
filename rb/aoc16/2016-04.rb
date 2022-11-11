#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/4
#
class Aoc201604
  OFFSETS = ('a'..'z').zip(1..26).to_h
  L = ('a'..'z').to_a

  def solve01(input)
    input.as_lines.sum { |l| real?(l) }.to_i
  end

  def solve02(input)
    input.as_lines.each do |room|
      cleartext, sid = decrypt(room)
      return sid.to_i if cleartext.include?('north')
    end
  end

  def decrypt(room)
    m = room.match(/^([\w-]+)-(\d+).*$/)
    name, sid, _cksum = m.captures

    [name.each_char.map { |c| rotate(c, sid.to_i) }.join, sid]
  end

  private

  def rotate(char, sid)
    return ' ' if char == '-'

    idx = (OFFSETS[char] + sid) % 26
    L[idx - 1]
  end

  def real?(room)
    m = room.match(/^([\w-]+)-(\d+)\[(\w+)\]$/)
    name, sid, cksum = m.captures

    our_cksum = name.delete('-')
                    .each_char.tally
                    .sort_by { |k, v| [-v, k] }
                    .take(cksum.length)
                    .to_h
                    .keys.sort

    their_cksum = cksum.each_char.sort
    our_cksum == their_cksum ? sid.to_i : 0
  end
end

class TestAoc201604 < MiniTest::Test
  include TestBase

  def table01
    {
      'aaaaa-bbb-z-y-x-123[abxyz]': 123,
      'a-b-c-d-e-f-g-h-987[abcde]': 987,
      'not-a-real-room-404[oarel]': 404,
      'totally-real-room-200[decoy]': 0
    }
  end

  def test_decrypt
    assert_equal(['very encrypted name', '343'],
                 @c.decrypt('qzmt-zixmtkozy-ivhz-343'))
  end
end
