# frozen_string_literal: true

module Intcode
  class Exception
    class UnknownOpcode < StandardError; end
    class UnknownMode < StandardError; end
    class EmptyInput < StandardError; end
    class Exit < StandardError; end
    class Stop < StandardError; end
  end
end
