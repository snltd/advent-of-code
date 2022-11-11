# frozen_string_literal: true

# We always load input into memory as a big string. These methods give us a
# nice, readable way of turning that input into something more convenient.
#
class String
  def as_lines
    split("\n")
  end

  def as_ints
    split("\n").map { |l| l.strip.to_i }
  end

  def as_raw_char_grid
    split("\n").map(&:chars)
  end

  # @return [Array] plain text chunks, which were originally separated by
  #   blank lines. (NOT newlines!)
  #
  def as_chunks
    split(/^\s*$/).compact.map(&:strip)
  end

  def as_blocks
    split(/\n\n/)
  end

  # Assembler input, from 2020-08
  # @return [Array[Symbol, Integer] [instruction, value]
  #
  def as_asm
    as_lines.map do |l|
      instruction, arg = l.split
      [instruction.to_sym, arg.to_i]
    end
  end

  def as_intcode
    split(',').map(&:to_i)
  end

  # tokenises each line, and turns tokens which look like ints into ints
  def parsed
    as_lines.map { |l| l.split.map { |c| c.match?(/\d/) ? c.to_i : c } }
  end
end
