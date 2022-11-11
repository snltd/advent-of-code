#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202111
  ADJACENT = [[-1, -1], [0, -1], [1, -1],
              [-1, 0],           [1, 0],
              [-1, 1], [0, 1], [1, 1]].freeze

  def solve01(input)
    input = input.split("\n").map { |l| l.each_char.map(&:to_i) }
    flashes = 0
    @xlim = input.first.size
    @ylim = input.size

    100.times do
      input = increase_all(input)
      flashers(input).each { |point| input = flash(input, point) }
      input, f = reset_flashers(input)
      flashes += f
    end

    flashes
  end

  def solve02(input)
    input = input.split("\n").map { |l| l.each_char.map(&:to_i) }
    @xlim = input.first.size
    @ylim = input.size
    all = @xlim * @ylim

    1.upto(1000) do |i|
      input = increase_all(input)
      flashers(input).each { |point| input = flash(input, point) }
      input, f = reset_flashers(input)
      return i if f == all
    end
  end

  def adjacent_to(x, y)
    ADJACENT.map { |ax, ay| [x + ax, y + ay] }
            .select { |nx, ny| nx >= 0 && nx < @xlim && ny >= 0 && ny < @ylim }
  end

  def increase_all(input)
    input.map { |l| l.map { |v| v + 1 } }
  end

  def flashers(input)
    input.each_with_index.with_object([]) do |(row, y), ret|
      row.each_with_index { |o, x| ret.<< [x, y] if o > 9 }
    end
  end

  def flash(input, point, _flashed = [])
    new_flashers = adjacent_to(*point).each.with_object([]) do |(x, y), aggr|
      input[y][x] += 1
      aggr.<<([x, y]) if input[y][x] == 10
    end

    input.tap { new_flashers.each { |pt| flash(input, pt) } }
  end

  def reset_flashers(input)
    ret = 0

    input.each_with_index do |row, y|
      row.each_with_index do |o, x|
        if o > 9
          input[y][x] = 0
          ret += 1
        end
      end
    end

    [input, ret]
  end
end

class TestAoc202111 < MiniTest::Test
  include TestBase

  def answer01
    1656
  end

  def answer02
    195
  end

  def sample
    <<~EOSAMPLE
      5483143223
      2745854711
      5264556173
      6141336146
      6357385478
      4167524645
      2176841721
      6882881134
      4846848554
      5283751526
    EOSAMPLE
  end
end
