#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

REQUIRED_FIELDS = [
  'byr', # (Birth Year)
  'iyr', # (Issue Year)
  'eyr', # (Expiration Year)
  'hgt', # (Height)
  'hcl', # (Hair Color)
  'ecl', # (Eye Color)
  'pid' # (Passport ID)
].freeze

class Aoc202004
  def solve01(input)
    input.as_chunks.count { |passport| check(passport) }
  end

  def solve02(input)
    input.as_chunks.count { |passport| valid?(passport) }
  end

  def check(passport)
    required_fields?(passport)
  end

  def required_fields?(passport)
    (REQUIRED_FIELDS - hashified(passport).keys).empty?
  end

  def hashified(passport)
    passport.split(/\s+/).to_h { |field| field.split(':') }
  end

  def valid?(passport)
    Passport.new(passport).valid?
  end
end

class TestAoc202004 < MiniTest::Test
  include TestBase

  def answer01
    2
  end

  def sample
    <<~EOSAMPLE
      ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      byr:1937 iyr:2017 cid:147 hgt:183cm

      iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      hcl:#cfa07d byr:1929

      hcl:#ae17e1 iyr:2013
      eyr:2024
      ecl:brn pid:760753108 byr:1931
      hgt:179cm

      hcl:#cfa07d eyr:2025 pid:166559648
      iyr:2011 ecl:brn hgt:59in
    EOSAMPLE
  end

  def test_check_passport
    assert @c.check("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\n" \
                    'byr:1937 iyr:2017 cid:147 hgt:183cm')

    refute @c.check("iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\n" \
                    'hcl:#cfa07d byr:1929')

    assert @c.check("hcl:#ae17e1 iyr:2013\n" \
                    "eyr:2024\n" \
                    "ecl:brn pid:760753108 byr:1931\n" \
                    'hgt:179cm')

    refute @c.check("hcl:#cfa07d eyr:2025 pid:166559648\n" \
                    'iyr:2011 ecl:brn hgt:59in')
  end

  # rubocop:disable Metrics/MethodLength
  def test_valid?
    refute @c.valid?("eyr:1972 cid:100\n" \
                     'hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926')

    refute @c.valid?("iyr:2019\n" \
                     "hcl:#602927 eyr:1967 hgt:170cm\n" \
                     'ecl:grn pid:012533040 byr:1946')

    refute @c.valid?("hcl:dab227 iyr:2012\n" \
                     'ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277')

    refute @c.valid?("hgt:59cm ecl:zzz\n" \
                     "eyr:2038 hcl:74454a iyr:2023\n" \
                     'pid:3556412378 byr:2007')

    assert @c.valid?('pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 ' \
                     "byr:1980\n" \
                     'hcl:#623a2f')

    assert @c.valid?("eyr:2029 ecl:blu cid:129 byr:1989\n" \
                     'iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm')

    assert @c.valid?("hcl:#888785\n" \
                     "hgt:164cm byr:2001 iyr:2015 cid:88\n" \
                     "pid:545766238 ecl:hzl\n" \
                     'eyr:2022')

    assert @c.valid?('iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 ' \
                     'eyr:2021 pid:093154719')
  end
  # rubocop:enable Metrics/MethodLength
end

# Breaks a passport string up into a hash, and provides methods to validate
# each field
#
class Passport
  attr_reader :passport

  def initialize(passport)
    @passport = hashified(passport)
  end

  def hashified(passport)
    passport.split(/\s+/).to_h { |field| field.split(':') }
  end

  def valid?
    REQUIRED_FIELDS.all? do |field|
      send("valid_#{field}?", passport[field]) if passport.key?(field)
    end
  end

  def valid_byr?(val)
    val.to_i.between?(1920, 2002)
  end

  def valid_iyr?(val)
    val.to_i.between?(2010, 2020)
  end

  def valid_eyr?(val)
    val.to_i.between?(2020, 2030)
  end

  def valid_hgt?(val)
    if val.end_with?('cm')
      val.to_i.between?(150, 193)
    elsif val.end_with?('in')
      val.to_i.between?(59, 76)
    end
  end

  def valid_hcl?(val)
    val.match?(/^#[0-9a-f]{6}$/)
  end

  def valid_pid?(val)
    val.match?(/^[0-9]{9}$/)
  end

  def valid_ecl?(val)
    %w[amb blu brn gry grn hzl oth].include?(val)
  end
end

# Unnecessary because we test the interface above, but these were written
# first, to build the thing tested above. Might as well leave them in.
#
class PassportTest < MiniTest::Test
  def setup
    @c = Passport.new(sample_data)
  end

  def test_valid_byr?
    assert @c.valid_byr?(2002)
    refute @c.valid_byr?(2003)
  end

  def test_valid_hgt?
    assert @c.valid_hgt?('60in')
    assert @c.valid_hgt?('190cm')
    refute @c.valid_hgt?('190in')
    refute @c.valid_hgt?('190')
  end

  def test_valid_hcl?
    assert @c.valid_hcl?('#123abc')
    refute @c.valid_hcl?('#123abz')
    refute @c.valid_hcl?('123abc')
  end

  def test_valid_ecl?
    assert @c.valid_ecl?('brn')
    refute @c.valid_ecl?('wat')
  end

  def test_valid_pid?
    assert @c.valid_pid?('000000001')
    refute @c.valid_pid?('0123456789')
  end

  private

  def sample_data
    'pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f'
  end
end
