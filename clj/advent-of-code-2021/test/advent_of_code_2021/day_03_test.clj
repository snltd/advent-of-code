(ns advent-of-code-2021.day-03-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :as core]
            [advent-of-code-2021.day-03 :as problem]))

(def right-answer-01 198)
(def right-answer-02 230)
(defn test-input [] (problem/load-input (core/sample-input-file "03")))

(deftest ones-or-zeroes-test
  (testing "count the ones in a given column of the input"
    (is (= \0 (problem/ones-or-zeroes (test-input) 4 >)))
    (is (= \1 (problem/ones-or-zeroes (test-input) 4 <)))
    (is (= \0 (problem/ones-or-zeroes (test-input) 0 <)))
    (is (= \1 (problem/ones-or-zeroes (test-input) 0 >)))))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (problem/solve-01 (test-input))))
    (is (= right-answer-02 (problem/solve-02 (test-input))))))

(deftest oxygen-generator-rating-test
  (testing "oxygen generator is reporting correctly"
    (is (= 23 (problem/oxygen-generator-rating (test-input))))))

(deftest co2-scrubber-rating
  (testing "CO2 scrubber is reporting correctly"
    (is (= 10 (problem/co2-scrubber-rating (test-input))))))

(deftest filter-test
  (testing "only keep elements which have the right bit in the right place"
    (is (= ["10110" "10111"]
           (problem/filter-input-by-bit-at-idx ["10110" "10111" "10101"] 3 \1)))
    (is (= ["10111"]
           (problem/filter-input-by-bit-at-idx ["10110" "10111" ] 4 \1)))))
