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

class TestAoc202008 < Minitest::Test
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

module Assembler
  #
  # Load and parse assembler code. In its own module as I suspect we'll be
  # revisiting it.
  #
  class Runtime
    attr_reader :prog, :pc, :acl, :completed

    def initialize(input = [], options = {})
      setup(input, options)
    end

    def run!
      begin
        execute_instruction(prog[pc]) while pc < prog.size
        @completed = true
      rescue LoopDetected
        error = "loop detected at index #{pc}"
        debug error
      end

      { accumulator: acl, completed:, error: error || nil }
    end

    private

    # INSTRUCTION - increment the program counter only
    # @param _arg [ignored]
    def nop(_arg)
      @pc += 1
    end

    # INSTRUCTION - add @arg to the accumulator value, and increment the PC
    # @param arg [Integer]
    def acc(arg)
      @acl += arg
      @pc += 1
    end

    # INSTRUCTION - modify the PC by the value of @arg
    # @param arg [Integer]
    def jmp(arg)
      @pc += arg
    end

    def execute_instruction(instruction)
      raise LoopDetected if @execlist.include?(pc)

      @execlist << pc if @loop_detector_enabled

      inst, arg = instruction
      debug "PC: #{pc} INST: #{inst} ARG: #{arg} ACL: #{acl}"
      send(inst, arg)
    end

    def setup(input, options)
      @prog = input
      @pc = 0 # program counter - offset in prog array
      @acl = 0 # accumulator
      @execlist = [] # Executed instructions. Used by loop detector
      @loop_detector_enabled = options[:loop_detector]
      @debug = options[:debug]
      @completed = false
    end

    def debug(msg)
      return unless @debug

      puts msg
    end
  end

  class LoopDetected < RuntimeError; end
end
