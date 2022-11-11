(ns advent-of-code-2021.day-09-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :as core]
            [advent-of-code-2021.day-09 :as problem]))

(def right-answer-01 nil)
(def right-answer-02 0)
(defn test-input [] (problem/load-input (core/sample-input-file "09")))

(comment deftest minimum?
  (testing "does the number have higher values on either side?"
    (is (true? (problem/minimum? [3 2 5] 1)))
    (is (true? (problem/minimum? [0 2] 0)))
    (is (true? (problem/minimum? [5 2] 1)))
    (is (false? (problem/minimum? [3 6 5] 1)))
    (is (false? (problem/minimum? [3 2] 0)))
    (is (false? (problem/minimum? [1 2] 1)))))

(comment deftest line-minima-test
  (testing "find the numbers with higher numbers on either side"
    (is (= '([1 2] [9 2])
           (problem/line-minima [2 1 9 9 9 4 3 2 1 0] 2)
           ))))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (problem/solve-01 (test-input))))
    (is (= right-answer-02 (problem/solve-02 (test-input))))))
