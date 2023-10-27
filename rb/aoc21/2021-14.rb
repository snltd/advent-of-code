#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202114
  def solve01(input)
    template, pair_rules = input.split("\n\n")

    @pairs = pair_rules.split("\n").each_with_object({}) do |p, aggr|
      adj, ins = p.split(' -> ')
      aggr[adj.chars] = ins
    end

    chain = template.chars

    10.times { chain = expand(chain) }

    freqs = chain.tally.values.sort
    freqs.last - freqs.first
  end

  private

  def expand(chain)
    ret = []

    chain.each_cons(2).with_index do |p, i|
      to_ins = @pairs[p]

      if i.zero?
        ret << [p[0], to_ins, p[1]] if to_ins
      elsif to_ins
        ret << [to_ins, p[1]]
      end
    end

    ret.flatten
  end
end

class TestAoc202114 < Minitest::Test
  include TestBase

  def answer01
    1588
  end

  def sample
    <<~EOSAMPLE
      NNCB

      CH -> B
      HH -> N
      CB -> H
      NH -> C
      HB -> C
      HC -> B
      HN -> C
      NN -> C
      BH -> H
      NC -> B
      NB -> B
      BN -> B
      BB -> N
      BC -> B
      CC -> N
      CN -> C
    EOSAMPLE
  end
end
