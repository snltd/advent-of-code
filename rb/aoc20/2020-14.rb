#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202014
  def solve01(input)
    mi = MaskedInterpreter.new(input)
    mi.run
    mi.memsums
  end

  def solve02(input)
    mi = MaskedInterpreter2.new(input)
    mi.run
    mi.memsums
  end
end

class TestAoc202014 < Minitest::Test
  include TestBase

  def answer01
    165
  end

  def answer02
    208
  end

  def sample01
    <<~EOINPUT
      mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      mem[8] = 11
      mem[7] = 101
      mem[8] = 0
    EOINPUT
  end

  def sample02
    <<~EOINPUT
      mask = 000000000000000000000000000000X1001X
      mem[42] = 100
      mask = 00000000000000000000000000000000X0XX
      mem[26] = 1
    EOINPUT
  end
end

class MaskedInterpreter
  attr_reader :mem, :prog

  def initialize(prog = '')
    @prog = prog
    @mask = nil
    @mem = {}
  end

  def memsums
    mem.values.sum
  end

  def run
    prog.split("\n").each do |line|
      line.start_with?('mask') ? update_mask(line) : run_inst(line)
    end
  end

  def run_inst(line)
    matches = line.match(/\[(\d+)\] = (\d+)/)
    @mem[matches[1]] = masked_num(@mask, matches[2]).to_i(2)
  end

  def update_mask(line)
    @mask = line.split.last
  end

  def masked_num(mask, num)
    full_bin(num).each_char.with_index.with_object([]) do |(c, i), s|
      s << (%w[0 1].include?(mask[i]) ? mask[i] : c)
    end.join
  end

  def full_bin(num)
    format('%036d', num.to_i.to_s(2))
  end
end

class MaskedInterpreter2 < MaskedInterpreter
  def run_inst(line)
    matches = line.match(/\[(\d+)\] = (\d+)/)
    addr = expand_floats([masked_num(@mask, matches[1])]).map { |a| a.to_i(2) }
    addr.each { |a| @mem[a] = matches[2].to_i }
  end

  def expand_floats(bits)
    new = bits.map { |b| [b.sub('X', '0'), b.sub('X', '1')] }.flatten
    return new unless new.first.include?('X')

    expand_floats(new)
  end

  def masked_num(mask, num)
    full_bin(num).each_char.with_index.with_object([]) do |(c, i), s|
      s << case mask[i]
           when '0'
             c
           when '1'
             1
           else
             'X'
           end
    end.join
  end
end

class TestMaskedInterpreter < Minitest::Test
  attr_reader :c

  def setup
    @c = MaskedInterpreter.new
  end

  def test_masked_num
    mask = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X'

    assert_equal('000000000000000000000000000001001001',
                 c.masked_num(mask, 11))

    assert_equal('000000000000000000000000000001100101',
                 c.masked_num(mask, 101))

    assert_equal('000000000000000000000000000001000000',
                 c.masked_num(mask, 64))
  end

  def test_full_bin
    assert_equal('000000000000000000000000000000001011', c.full_bin(11))
    assert_equal('000000000000000000000000000001100101', c.full_bin(101))
    assert_equal('000000000000000000000000000001000000', c.full_bin(64))
  end
end

class TestMaskedInterpreter2 < Minitest::Test
  attr_reader :c

  def setup
    @c = MaskedInterpreter2.new
  end

  def test_masked_num
    mask = '000000000000000000000000000000X1001X'

    assert_equal('000000000000000000000000000000X1101X',
                 c.masked_num(mask, 42))
  end

  def test_expand_floats
    assert_equal(%w[000000000000000000000000000000011010
                    000000000000000000000000000000011011
                    000000000000000000000000000000111010
                    000000000000000000000000000000111011],
                 c.expand_floats(['000000000000000000000000000000X1101X']))
  end

  def test_full_bin
    assert_equal('000000000000000000000000000000101010', c.full_bin(42))
    assert_equal('000000000000000000000000000000011010', c.full_bin(26))
    assert_equal('000000000000000000000000000000011011', c.full_bin(27))
  end
end
