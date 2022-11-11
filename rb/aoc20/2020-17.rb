#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202017
  def solve01(input)
    @input = input.as_raw_char_grid
    @neighbour_cache = {}
    actives = []

    @input.each.with_index do |row, i|
      row.each.with_index do |cell, j|
        actives.<<([i, j, 0]) if cell == '#'
      end
    end.flatten.compact

    6.times { actives = cycle(actives) }

    actives.count
  end

  # This is rubbish. It takes for ever.
  #
  def solve02(input)
    @input = input.as_raw_char_grid
    @neighbour_cache = {}
    actives = []

    @input.each.with_index do |row, i|
      row.each.with_index { |cell, j| actives.<<([i, j, 0, 0]) if cell == '#' }
    end.flatten.compact

    6.times { actives = cycle02(actives) }

    actives.count
  end

  private

  def neighbours(coords)
    matrix = [-1, 0, 1].repeated_permutation(coords.size).uniq

    matrix.map! { |n| [n, coords].transpose.map(&:sum) }.reject do |p|
      p == coords
    end
  end

  def neighbours02(coords)
    matrix = [-1, 0, 1].repeated_permutation(coords.size).uniq

    matrix.map! { |n| [n, coords].transpose.map(&:sum) }.reject do |p|
      p == coords
    end
  end

  def directions(dimensions)
    [-1, 0, 1].repeated_permutation(dimensions)
              .reject { |pos| pos == [0] * dimensions }
  end

  def cycle(actives)
    new_actives = []

    actives.each do |c|
      if @neighbour_cache.key?(c)
        nc = @neighbour_cache[c]
      else
        nc = neighbours(c)
        @neighbour_cache[c] = nc
      end

      an = (nc & actives).count
      new_actives.<< c if [2, 3].include?(an)
    end

    (all_cubes(actives) - actives).each do |c|
      an = (neighbours(c) & actives).count
      new_actives.<< c if an == 3
    end

    new_actives
  end

  def cycle02(actives)
    new_actives = []

    actives.each do |c|
      if @neighbour_cache.key?(c)
        nc = @neighbour_cache[c]
      else
        nc = neighbours(c)
        @neighbour_cache[c] = nc
      end
      an = (nc & actives).size
      new_actives.<< c if [2, 3].include?(an)
    end

    (all_cubes02(actives) - actives).each do |c|
      an = (neighbours(c) & actives).size
      new_actives.<< c if an == 3
    end

    new_actives
  end

  def all_cubes(actives)
    x, y, z = limits(actives)

    x.each.with_object([]) do |x1, aggr|
      y.each do |y1|
        z.each do |z1|
          aggr.<< [x1, y1, z1]
        end
      end
    end
  end

  def all_cubes02(actives)
    x, y, z, w = limits(actives)

    x.each.with_object([]) do |x1, aggr|
      y.each do |y1|
        z.each do |z1|
          w.each do |w1|
            aggr.<< [x1, y1, z1, w1]
          end
        end
      end
    end
  end

  def limits(actives)
    0.upto(actives.first.size - 1).with_object([]) do |i, aggr|
      x = actives.map { |a| a[i] }
      aggr.<< Range.new(x.min - 1, x.max + 1).to_a
    end
  end

  def initial_grid
    new_grid('.', dimensions).tap do |grid|
      indices = Array.new(dimensions - 2) { 0 }

      @input.each_with_index do |line, y|
        line.chars.each_with_index do |char, x|
          *tail, head = indices.dup + [y, x]
          grid.dig(*tail).store(head, char)
        end
      end
    end
  end
end

class TestAoc202017 < MiniTest::Test
  include TestBase

  def answer01
    112
  end

  def answer02
    848
  end

  def sample
    <<~EOINPUT
      .#.
      ..#
      ###
    EOINPUT
  end
end
