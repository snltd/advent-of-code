(ns advent-of-code-2021.day-05-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :as core]
            [advent-of-code-2021.day-05 :as problem]))

(def right-answer-01 5)
(def right-answer-02 12)
(defn test-input [] (problem/load-input (core/sample-input-file "05")))

(deftest unordered-range-test
  (testing "we get the same range regardless of the argument order, and the range
           is inclusive of the upper bound"
    (is (= (range 1 6) (problem/unordered-range 1 5)))
    (is (= (range 5 0 -1) (problem/unordered-range 5 1)))))

(deftest process-vector-diagonals-test
  (testing "vector coords are correctly turned into lists of all their points"
    (is (empty? (problem/process-vector "1,1 -> 3,3" false)))
    (is (= ["1,1" "1,2" "1,3"] (problem/process-vector "1,1 -> 1,3" true)))
    (is (= ["9,7" "8,7" "7,7"] (problem/process-vector "9,7 -> 7,7" true)))
    (is (= ["9,7" "8,8" "7,9"] (problem/process-vector "9,7 -> 7,9" true)))
    (is (= ["1,1" "2,2" "3,3"] (problem/process-vector "1,1 -> 3,3" true)))))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (problem/solve-01 (test-input))))
    (comment is (= right-answer-02 (problem/solve-02 (test-input))))))
