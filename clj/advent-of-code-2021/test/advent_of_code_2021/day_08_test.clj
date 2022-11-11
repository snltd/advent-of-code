(ns advent-of-code-2021.day-08-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :as core]
            [advent-of-code-2021.day-08 :as problem]))

(def right-answer-01 26)
(def right-answer-02 1091609)
(defn test-input [] (problem/load-input (core/sample-input-file "08")))

(deftest matching-lengths-test
  (testing "counts the words with the given lengths"
    (is (= 2 (problem/matching-lengths "fdgacbe cefdb cefbgd gcbe")))))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (problem/solve-01 (test-input))))
    (is (= right-answer-02 (problem/solve-02 (test-input))))))
