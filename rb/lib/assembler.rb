# frozen_string_literal: true

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

      { accumulator: acl, completed: completed, error: error || nil }
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

      @execlist.<< pc if @loop_detector_enabled

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
