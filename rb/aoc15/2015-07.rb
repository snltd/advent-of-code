#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Circuit
  attr_reader :instructions

  def initialize(input)
    @instructions = parse(input)
    @cache = {}
  end

  def parse(input)
    input.split("\n")
         .to_h { |l| l.split(' -> ').reverse }
         .transform_keys { |k| k.match?(/\d/) ? k.to_i : k.to_sym }
         .transform_values do |v|
           v.split.map { |p| /\d/.match?(p) ? p.to_i : p.to_sym }
         end
  end

  def part01
    solve(:a)
  end

  def part02(value)
    @instructions[:b] = value
    solve(:a)
  end

  def solve(gate)
    inst = @instructions[gate]

    return gate if gate.is_a?(Integer)
    return inst if inst.is_a?(Integer)

    @cache[gate] = do_gate(inst) unless @cache.key?(gate)
    @cache[gate]
  end

  def do_gate(inst)
    if inst.size == 1
      solve(inst[0])
    elsif inst[1] == :AND
      solve(inst[0]) & solve(inst[2])
    elsif inst[1] == :OR
      solve(inst[0]) | solve(inst[2])
    elsif inst[1] == :LSHIFT
      solve(inst[0]) << inst[2].to_i
    elsif inst[1] == :RSHIFT
      solve(inst[0]) >> inst[2].to_i
    elsif inst[0] == :NOT
      ~solve(inst[1])
    end
  end
end

# https://adventofcode.com/2015/day/1
#
class Aoc201507
  def solve01(input)
    Circuit.new(input).part01
  end

  def solve02(input)
    Circuit.new(input).part02(Circuit.new(input).part01)
  end
end
