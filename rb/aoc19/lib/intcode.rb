# frozen_string_literal: true

require_relative 'exception'
require_relative '../../lib/stdlib/string'

module Intcode
  #
  # Intcode computer. To be extended as required, but must remain
  # backward-compatible.
  #
  # rubocop:disable Metrics/ClassLength
  class Computer
    attr_reader :pc, :prog, :output, :state

    # Params [Hash] keys
    #
    def initialize(params = {})
      @params = default_params(params)
      @state = :initializing
      @stored_state = {}
      reset
    end

    def default_params(params)
      {
        debug: false,
        stop_on_output: false
      }.merge(params)
    end

    def reset
      @output = []
    end

    # @param program [Array[Integer]]
    # @param input
    #
    def run!(prog, input = nil)
      if @stored_state.empty?
        debug 'initializing new program and pc'
        @prog = prog.dup
        @pc = 0
        @relative_base = 0
      else
        @prog = @stored_state[:prog]
        @pc = @stored_state[:pc]
        @relative_base = @stored_state[:relative_base]
        debug "RESUMING #{object_id} at #{@pc}"
      end

      @input = input
      @state = :running

      loop do
        opcode, params = decoded_inst(@prog[@pc])
        debug "pc: #{@pc}   opcode #{opcode}   params #{params}"
        dispatch(opcode, params)
      end
    rescue Intcode::Exception::UnknownOpcode => e
      puts "unknown opcode #{e} at #{@pc}"
      dump_prog_and_exit
    rescue Intcode::Exception::Exit
      debug "exit at #{@pc}"
      @state = :complete
    rescue Intcode::Exception::EmptyInput
      puts "empty input at #{@pc}"
      dump_prog_and_exit
    rescue Intcode::Exception::Stop
      @state = :stopped
      store_state
      debug "STOPPING #{object_id} at #{@pc}"
    rescue Intcode::Exception::UnknownMode => e
      puts "unexpected mode #{e} at #{@pc}"
      dump_prog_and_exit
      # rescue StandardError => e
      # warn "Unhandled Error at #{@pc}"
      # dump_prog_and_exit
      # puts e
    end

    def store_state
      @stored_state = {
        prog: @prog,
        pc: @pc,
        relative_base: @relative_base
      }
    end

    # Parameter modes are stored in the same value as the instruction's
    # opcode. The opcode is a two-digit number based only on the ones and tens
    # digit of the value, that is, the opcode is the rightmost two digits of
    # the first value in an instruction. Parameter modes are single digits,
    # one per parameter, read right-to-left from the opcode: the first
    # parameter's mode is in the hundreds digit, the second parameter's mode
    # is in the thousands digit, the third parameter's mode is in the
    # ten-thousands digit, and so on. Any missing modes are 0.
    #
    # @return [Array[Int, Array]] [opcode, [params]] the opcode, along with
    # the argument parameters in the correct order
    #
    def decoded_inst(inst)
      bits = format('%05d', inst).split('', 4).map(&:to_i)
      [bits[3], [bits[2], bits[1], bits[0]]]
    end

    private

    def dispatch(inst, params)
      case inst
      when 1
        opcode1(params)
      when 2
        opcode2(params)
      when 3
        opcode3(params)
      when 4
        opcode4(params)
      when 5
        opcode5(params)
      when 6
        opcode6(params)
      when 7
        opcode7(params)
      when 8
        opcode8(params)
      when 9
        opcode9(params)
      when 99
        raise Intcode::Exception::Exit
      else
        raise Intcode::Exception::UnknownOpcode, inst
      end
    end

    # @return [Integer] value at given offset from @pc
    # @param offset [Integer] offset from @pc which we wish to know value of
    # @param mode [Integer] parameter mode, as described above
    def offset_val(offset, mode)
      arg_addr = @pc + offset               # where is the arg?
      arg_value = @prog.fetch(arg_addr, 0)  # the value of the arg

      case mode
      when 0 # position mode
        @prog.fetch(arg_value, 0)
      when 1 # immediate mode
        arg_value
      when 2 # relative mode
        @prog.fetch(@relative_base + arg_value, 0)
      else
        raise Intcode::Exception::UnknownMode, mode
      end
    end

    def ioffset_val(offset, mode)
      arg_addr = @pc + offset
      arg_value = @prog.fetch(arg_addr, 0)

      case mode
      when 1, 0
        arg_value
      when 2
        @relative_base + arg_value
      else
        raise Intcode::Exception::UnknownMode, mode
      end
    end

    # Opcode 1 ADDS TOGETHER numbers read from two positions and stores the
    # result in a third position. The three integers immediately after the
    # opcode tell you these three positions
    #
    def opcode1(params = [])
      v1 = offset_val(1, params.shift)
      v2 = offset_val(2, params.shift)
      result = v1 + v2
      addr = ioffset_val(3, params.shift)
      debug "opcode1: #{v1} + #{v2} = #{result} -> #{addr}"
      @prog[addr] = result
      @pc += 4
    end

    # Opcode 2 works exactly like opcode 1, except it MULTIPLIES the two
    # inputs instead of adding them. Again, the three integers after the
    # opcode indicate where the inputs and outputs are, not their values.
    #
    def opcode2(params = [])
      v1 = offset_val(1, params.shift)
      v2 = offset_val(2, params.shift)
      result = v1 * v2
      addr = ioffset_val(3, params.shift)
      debug "opcode2: #{v1} * #{v2} = #{result} -> #{addr}"
      @prog[addr] = result
      @pc += 4
    end

    # Opcode 3 takes a single integer as input and saves it to the position
    # given by its only parameter.
    #
    def opcode3(params)
      val = @input.shift
      debug "opcode3: read #{val} from input"
      raise Intcode::Exception::EmptyInput if val.nil?

      @prog[ioffset_val(1, params[0])] = val
      @pc += 2
    end

    # Opcode 4 outputs the value of its only parameter
    #
    def opcode4(params)
      val = offset_val(1, params[0])
      debug "opcode4: appending #{val} to output"
      @output.<< val
      @pc += 2
      raise Intcode::Exception::Stop if @params[:stop_on_output]
    end

    # Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets
    # the instruction pointer to the value from the second parameter.
    # Otherwise, it does nothing.
    def opcode5(params)
      if offset_val(1, params[0]).zero?
        debug 'opcode5: pass'
        @pc += 3
      else
        new_pc = offset_val(2, params[1])
        debug "opcode5: setting pc to #{new_pc}"
        @pc = new_pc
      end
    end

    # Opcode 6 is jump-if-false: if the first parameter is zero, it sets the
    # instruction pointer to the value from the second parameter. Otherwise,
    # it does nothing.
    #
    def opcode6(params)
      if offset_val(1, params[0]).zero?
        new_pc = offset_val(2, params[1])
        debug "opcode6: setting pc to #{new_pc}"
        @pc = new_pc
      else
        debug 'opcode6: pass'
        @pc += 3
      end
    end

    # Opcode 7 is less than: if the first parameter is less than the second
    # parameter, it stores 1 in the position given by the third parameter.
    # Otherwise, it stores 0.
    #
    def opcode7(params)
      v1 = offset_val(1, params[0])
      v2 = offset_val(2, params[1])
      addr = ioffset_val(3, params[2])

      val = v1 < v2 ? 1 : 0
      str = v1 < v2 ? '<' : '>='

      debug "opcode 7: writing #{val} to #{addr} because #{v1} #{str} #{v2}"
      @prog[addr] = val
      @pc += 4
    end

    # Opcode 8 is equals: if the first parameter is equal to the second
    # parameter, it stores 1 in the position given by the third parameter.
    # Otherwise, it stores 0.
    #
    def opcode8(params)
      v1 = offset_val(1, params[0])
      v2 = offset_val(2, params[1])
      addr = ioffset_val(3, params[2])
      val = v1 == v2 ? 1 : 0
      str = v1 == v2 ? '==' : '!='

      debug "opcode 8: writing #{val} to #{addr} because #{v1} #{str} #{v2}"
      @prog[addr] = val
      @pc += 4
    end

    # Opcode 9 adjusts the relative base by the value of its only parameter.
    # The relative base increases (or decreases, if the value is negative) by
    # the value of the parameter.
    #
    def opcode9(params)
      val = offset_val(1, params.shift)
      debug "opcode 9: adjusting relative_base by #{val}"
      @relative_base += val
      @pc += 2
    end

    # --- DEBUG STUFF --------------------------------------------------------

    def debug(msg)
      puts msg if @params[:debug] == true
    end

    def dump_prog_and_exit
      puts '------ FATAL ERROR : PROGRAM FOLLOWS ---------'
      @prog.each_with_index { |inst, i| puts "#{i} #{inst}" }
      exit 1
    end
  end
  # rubocop:enable Metrics/ClassLength
end
