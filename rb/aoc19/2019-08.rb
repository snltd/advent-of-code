#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc201908
  WIDTH = 25
  HEIGHT = 6

  def solve01(input)
    layers = image_to_layers(input, WIDTH, HEIGHT)

    counts = layers.map do |l|
      l.chars.each_with_object(Hash.new(0)) do |e, sum|
        sum[e] += 1
      end
    end

    zero_counts = counts.map { |c| [c['0'], c] }
    fewest_zeros = zero_counts.min_by { |a, _b| a }[1]
    fewest_zeros['1'] * fewest_zeros['2']
  end

  def solve02(input)
    layers = image_to_layers(input, WIDTH, HEIGHT).map(&:chars)

    # Rotate the "image" anticlockwise, and select the first non-transparent
    # pixel on each "row".
    #
    combined = layers.transpose.reverse.map do |layer|
      layer.find { |p_val| p_val != '2' }
    end

    # I'm reversing the colours because I use a dark-on-light terminal.
    #
    combined.reverse.each_slice(WIDTH) do |row|
      puts row.join.tr('1', "\u2588").tr('0', ' ')
    end

    nil
  end

  private

  def image_to_layers(raw, x, y)
    regex = Regexp.new("\\d{#{x * y}}")
    raw.scan(regex)
  end
end
