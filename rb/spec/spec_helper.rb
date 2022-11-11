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
    skip if slow_test?('01')

    table01.each { |input, val| assert_equal(val, @c.solve01(input.to_s)) } if respond_to?(:table01)

    if respond_to?(:answer01)
      if respond_to?(:sample)
        assert_equal(answer01, @c.solve01(sample))
      elsif respond_to?(:sample01)
        assert_equal(answer01, @c.solve01(sample01))
      end
    end
  end

  def test_part02
    skip if slow_test?('02')

    table02.each { |input, val| assert_equal(val, @c.solve02(input.to_s)) } if respond_to?(:table02)

    if respond_to?(:answer02)
      if respond_to?(:sample)
        assert_equal(answer02, @c.solve02(sample))
      elsif respond_to?(:sample02)
        assert_equal(answer02, @c.solve02(sample02))
      end
    end
  end

  private

  def problem_class
    self.class.name.sub('Test', '')
  end

  def slow_test?(part)
    respond_to?(:slow_test) && slow_test.include?(part)
  end
end
