#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc201912
  PAIRS = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]].freeze

  def solve01(input)
    energy_of_system(input.as_lines, 1000)
  end

  def input_to_pos(input)
    input.map { |r| r.scan(/=([\d\-]+)/).map { |p| p[0].to_i } }
  end

  def update_velocity(pos, vel, a, b)
    0.upto(2) do |n|
      if pos[a][n] > pos[b][n]
        vel[a][n] -= 1
        vel[b][n] += 1
      elsif pos[a][n] < pos[b][n]
        vel[a][n] += 1
        vel[b][n] -= 1
      end
    end

    [pos, vel]
  end

  def apply_gravity(pos, vel)
    PAIRS.each { |a, b| pos, vel = update_velocity(pos, vel, a, b) }

    [pos, vel]
  end

  def apply_velocity(pos, vel)
    0.upto(3) { |m| 0.upto(2) { |n| pos[m][n] += vel[m][n] } }

    [pos, vel]
  end

  def potential_energy(pos)
    pos.map { |m| m.sum(&:abs) }
  end

  def kinetic_energy(vel)
    vel.map { |m| m.sum(&:abs) }
  end

  def total_energy(pos, vel)
    pe = potential_energy(pos)
    ke = kinetic_energy(vel)

    0.upto(3).sum { |n| pe[n] * ke[n] }
  end

  def energy_of_system(input, iterations)
    pos = input_to_pos(input)
    vel = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]

    iterations.times do
      pos, vel = apply_gravity(pos, vel)
      pos, vel = apply_velocity(pos, vel)
    end

    total_energy(pos, vel)
  end
end
