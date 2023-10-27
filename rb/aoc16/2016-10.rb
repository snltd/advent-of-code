#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/10
#
class Aoc201610
  def solve01(input)
    @bots = {}
    @outputs = {}
    @answer = nil
    iterate(input.parsed, true)
    @answer
  end

  def solve02(input)
    @bots = {}
    @outputs = {}
    iterate(input.parsed)
    @outputs[0] * @outputs[1] * @outputs[2]
  end

  def iterate(input, return_on_answer = false)
    return if (return_on_answer && @answer) || input.empty?

    input.each do |inst|
      if inst.first == 'value'
        set_value(inst[5], inst[1])
        input.delete(inst)
      elsif transfer(inst)
        input.delete(inst)
      end
    end

    iterate(input)
  end

  def transfer(inst)
    bot = inst[1]

    return nil unless @bots.key?(bot) && @bots[bot].count == 2

    low_target = inst[6]
    high_target = inst[11]

    @answer = bot if @bots[bot].min == 17 && @bots[bot].max == 61

    if inst[5] == 'output'
      @outputs[low_target] = @bots[bot].min
    else
      set_value(low_target, @bots[bot].min)
    end

    if inst[10] == 'output'
      @outputs[high_target] = @bots[bot].max
    else
      set_value(high_target, @bots[bot].max)
    end

    @bots[bot] = []
  end

  def set_value(bot, value)
    if @bots.key?(bot)
      @bots[bot] << value.to_i
    else
      @bots[bot] = [value.to_i]
    end
  end
end
