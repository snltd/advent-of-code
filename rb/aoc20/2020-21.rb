#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative '../lib/base'

class Aoc202021
  def solve01(input)
    possibles = Hash.new(Set.new)
    all_ingredients = Set.new

    # For each ingredient, make a list of every allergen it may be
    #
    foods = input.as_lines.map { |f| parse_food(f) } # .each do |f|

    all_allergens = foods.each.with_object([]) do |f, aggr|
      aggr.<< f[:allergens]
    end.flatten.uniq

    isolate_allergen(foods, all_allergens)
  end

  def isolate_allergen(foods, all_allergens, solved = {})
    return solved if all_allergens.empty?

    # for each allergen
    all_allergens.each do |allergen|
      # get the ingredients of every food with that allergen
      ingredient_lists_with_allergen = foods.select { |f| f[:allergens].include?(allergen) }.map { |f| f[:ingredients] }

      # and see what ingredients they have in common

      ingredient_lists_with_allergen.flatten.uniq.each do |ingredient|
        seen_in_all = []

        if ingredient_lists_with_allergen.all? { |list| list.include?(ingredient) }
          puts 'cunt'
          seen_in_all.<< ingredient
        end

        break(2) if seen_in_all.size == 1
      end
    end

    solved[allergen] = ingredient
    puts "#{allergen} must be #{ingredient}"
    # pp "=================================="
    # pp foods
    # pp "=================================="
    foods = foods.map do |f|
      f.transform_values do |v|
        v - [ingredient, allergen]
      end
    end
    # puts "++++++++++++++++++++++++++"
    # pp new_foods
    # puts "++++++++++++++++++++++++++"
    all_allergens -= [allergen]
    # isolate_allergen(new_foods, allergens, solved)
  end

  #     return 5
  #       f[:ingredients].each do |i|
  #         possibles[i] += f[:allergens]
  #
  #         all_allergens += Set.new(f[:allergens])
  #         all_ingredients.<< i
  #       end
  #     end
  #
  #     # For each allergen, make a list of every ingredient which could possibly
  #     # contain it.
  #     input.map { |f| parse_food(f) }.each do |f|
  #       f[:allergens].each do |a|
  #         possibles[a] += f[:ingredients]
  #         all_allergens.<< a
  #         all_ingredients += f[:ingredients]
  #       end
  #     end
  #
  #     pp possibles
  #     pp all_ingredients
  #     pp all_allergens
  #     exit
  #     all_ingredients.sort.uniq.each do |i|
  #       c= possibles.values.count { |v| v.include?(i) }
  #       puts "#{i} -> #{c}"
  #     end

  def parse_food(food)
    m = food.match(/(.*) \(contains (.*)\)/)

    { ingredients: m[1].split.map(&:to_sym),
      allergens: m[2].split(/[,\s]+/).map(&:to_sym) }
  end
end

class TestAoc202021 < MiniTest::Test
  include TestBase

  def _answer01
    5
  end

  def sample
    <<~EOINPUT
      mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
      trh fvjkl sbzzf mxmxvkd (contains dairy)
      sqjhc fvjkl (contains soy)
      sqjhc mxmxvkd sbzzf (contains fish)
    EOINPUT
  end

  def _test_parse_food
    assert_equal(
      { ingredients: %i[mxmxvkd kfcds sqjhc nhms],
        allergens: %i[dairy fish] },
      @c.parse_food('mxmxvkd kfcds sqjhc nhms (contains dairy, fish)')
    )
  end
end
