# frozen_string_literal: true

require_relative 'intcode'

module Intcode
  class MachineChain
    def initialize(num)
      machines = []
      num.times { machines.<< Intcode::Computer.new(stop_on_output: true) }
      @machines = machines
    end

    def run(prog, inputs, initial_val = 0)
      @machines.reduce(initial_val) do |last_output, m|
        m.run!(prog, [inputs.shift, last_output])
        m.output.last
      end
    end

    def feedback_loop(prog, inputs)
      input = 0

      @machines.each do |m|
        m.run!(prog, [inputs.shift, input])
        input = m.output.last
      end

      loop do
        @machines.each do |m|
          m.run!(nil, [input])
          input = m.output.last
        end

        return @machines[4].output.last if @machines[4].state == :complete
      end
    end
  end
end
