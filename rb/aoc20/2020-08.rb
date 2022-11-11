#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'
require_relative '../lib/assembler'

class Aoc202008
  def solve01(input)
    asm = Assembler::Runtime.new(input.as_asm, loop_detector: true)
    asm.run!
    asm.acl
  end

  def solve02(input)
    input = input.as_asm

    input.each_with_index do |_, i|
      new_prog = modify_program(input.dup, i)
      next if new_prog.nil?

      results = run_code(new_prog)
      return results[:accumulator] if results[:completed]
    end
  end

  def modify_program(input, index)
    inst, arg = input[index]

    case inst
    when :jmp
      input[index] = [:nop, arg]
    when :nop
      input[index] = [:jmp, arg]
    else
      return nil
    end

    input
  end

  def run_code(prog)
    asm = Assembler::Runtime.new(prog, loop_detector: true)
    asm.run!
  end
end

class TestAoc202008 < MiniTest::Test
  include TestBase

  def answer01
    5
  end

  def answer02
    8
  end

  def sample
    <<~EOSAMPLE
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
    EOSAMPLE
  end
end
