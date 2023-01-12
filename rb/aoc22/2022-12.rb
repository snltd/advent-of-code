#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'
require_relative '../lib/grid'

# https://adventofcode.com/2022/day/12
#
class Aoc202212
  def solve01(input)
    g = Grid.new(input)
    @start = g.grid.index('S')
    @finish = g.grid.index('E')
    p @start
    p @finish
    queue = [0]
    g.grid[@start] = 'a'
    g.grid[@finish] = 'z'

    visit(g, queue)
  end

  def visit(g, queue, visited = {}, steps = 0)
    #puts "queue is #{queue}"
    #puts "  visited is #{visited}"
    pos = queue.shift
    puts "  pos is #{pos}"

    visited[pos] = true

    p = g.at(pos)

    return steps if pos == @finish

    moves = g.neighbours4(pos).select { |n| can_move?(p, g.at(n)) }.reject { |m| visited.key?(m) }


    puts "potential moves from #{p} are #{g.vals_of(moves)}"
      moves.each do |m|
      visited[m] = true
      queue.<< m
    end

    #p moves

    unless moves.empty?
      puts "adding step"
      steps +=1
      #puts "   + step"
    end

    visit(g, queue, visited, steps)
  end

  def can_move?(here, there)
    puts "comparing #{here} and #{there}"
    there == here || there <= here.next #|| there == 'E' && here == 'z'
  end

  def solve02(input)
    input
    0
  end
end

class TestAoc202212 < MiniTest::Test
  include TestBase

  def answer01
    31
  end

  def answer02
    0
  end

  def sample
    <<~EOSAMPLE
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
    EOSAMPLE
  end
end
