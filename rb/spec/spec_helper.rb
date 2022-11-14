# frozen_string_literal: true

require defined?(RUNNER) ? 'minitest' : 'minitest/autorun'

# We are given example values to test our code. In 2015 we got multiple
# examples. To test them, define a map #table 01 of the form
# { 'input1': 'output1' }, and all its inputs will be run through #solve01
# and compared with the expected outputs.
#
# If all you are given is a sample answer, as in later years, put it in
# #answer01, and the test methods will load sample input and push it through
# #solve01, verifying the answer. For part 2, sub 01 with 02.
#
# If a part takes a long time to solve (like that MD5 one in 2015) define
# it as '01' or '02' in an array in #slow_test, and the test will be skipped.
#
module TestBase
  def setup
    @c = Object.const_get(problem_class).new
    post_setup if respond_to?(:post_setup)
  end

  def test_part01
    test_part('01')
  end

  def test_part02
    test_part('02')
  end

  private

  def test_part(part)
    skip if slow_test?(part)

    table = "table#{part}".to_sym
    solver = "solve#{part}".to_sym
    answer = "answer#{part}".to_sym

    if respond_to?(table)
      send(table).each do |input, val|
        assert_equal(val, @c.send(solver, input.to_s))
      end
    end

    if respond_to?(answer)
      if @c.method(solver).arity == -2
        assert_equal(send(answer), @c.send(solver, sample_data(part), sample_val))
      else
        assert_equal(send(answer), @c.send(solver, sample_data(part)))
      end
    end
  end

  def sample_data(part)
    respond_to?(:sample) ? sample : send("sample#{part}")
  end

  def problem_class
    self.class.name.sub('Test', '')
  end

  def slow_test?(part)
    respond_to?(:slow_test) && slow_test.include?(part)
  end
end
