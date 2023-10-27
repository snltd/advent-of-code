#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/07
#
class Aoc202207
  def solve01(input)
    dir_sizes(input.as_lines).select { |_k, v| v <= 100_000 }.values.sum
  end

  def solve02(input)
    sizes = dir_sizes(input.as_lines)
    unused = 70_000_000 - sizes[:/]
    required = 30_000_000 - unused
    sizes.select { |_k, v| v >= required }.values.min
  end

  def newdir(cwd, arg)
    return ['/'] if arg == '/'
    return cwd[0..-2] if arg == '..'

    cwd << arg
  end

  def parents(cwd)
    0.upto(cwd.length).filter_map { |i| cwd[0...i].join('-').to_sym }
  end

  def dir_sizes(input)
    cwd = []

    input.each.with_object(Hash.new(0)) do |l, ret|
      toks = l.split

      if toks[1] == 'cd'
        cwd = newdir(cwd, toks[2])
      elsif toks[0].match?(/\d/)
        parents(cwd).each { |k| ret[k] += toks[0].to_i }
      end
    end
  end
end

class TestAoc202207 < Minitest::Test
  include TestBase

  def answer01
    95_437
  end

  def answer02
    24_933_642
  end

  def sample
    <<~EOSAMPLE
      $ cd /
      $ ls
      dir a
      14848514 b.txt
      8504156 c.dat
      dir d
      $ cd a
      $ ls
      dir e
      29116 f
      2557 g
      62596 h.lst
      $ cd e
      $ ls
      584 i
      $ cd ..
      $ cd ..
      $ cd d
      $ ls
      4060174 j
      8033020 d.log
      5626152 d.ext
      7214296 k
    EOSAMPLE
  end
end
