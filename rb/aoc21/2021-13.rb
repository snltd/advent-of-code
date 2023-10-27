#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

# Transparent Origami
#
class Aoc202113
  def solve01(input)
    dots, instructions = input.split("\n\n")
    paper = setup_paper(dots)
    axis, num = instructions.lines.first.split.last.split('=')
    paper = axis == 'x' ? fold_x(paper, num.to_i) : fold_y(paper, num.to_i)
    paper.flatten.count { |c| c == '#' }
  end

  def solve02(input)
    dots, instructions = input.split("\n\n")
    paper = setup_paper(dots)

    instructions.lines.map { |i| i.split.last }.each do |i|
      axis, num = i.split('=')
      paper = axis == 'x' ? fold_x(paper, num.to_i) : fold_y(paper, num.to_i)
    end

    puts paper.map(&:join)
  end

  private

  def setup_paper(dots)
    paper = []
    lines = dots.split("\n")

    x_max = lines.map { |l| l.split(',').first.to_i }.max
    y_max = lines.map { |l| l.split(',').last.to_i }.max

    (y_max + 1).times { paper << Array.new(x_max + 1, '.') }

    lines.each_with_object(paper) do |l, aggr|
      x, y = l.split(',').map(&:to_i)
      aggr[y][x] = '#'
    end
  end

  def fold_x(paper, num)
    target = paper.map { |row| row[0...num] }
    folded = paper.map { |row| row[num..].reverse }
    merge_folds(target, folded)
  end

  def fold_y(paper, num)
    merge_folds(paper[0...num], paper[num..].reverse)
  end

  def merge_folds(one, other)
    one.map.with_index do |row, i|
      row.map.with_index { |e, j| e == '#' || other[i][j] == '#' ? '#' : '.' }
    end
  end
end

class TestAoc202113 < Minitest::Test
  include TestBase

  def answer01
    17
  end

  def sample
    <<~EOSAMPLE
      6,10
      0,14
      9,10
      0,3
      10,4
      4,11
      6,0
      6,12
      4,1
      0,13
      10,12
      3,4
      3,0
      8,4
      1,10
      2,14
      8,10
      9,0

      fold along y=7
      fold along x=5
    EOSAMPLE
  end
end
