(ns advent-of-code-2021.day-01-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :as core]
            [advent-of-code-2021.day-01 :as problem]))

(def right-answer-01 7)
(def right-answer-02 5)
(defn test-input [] (problem/load-input (core/sample-input-file "01")))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (problem/solve-01 (test-input))))
    (is (= right-answer-02 (problem/solve-02 (test-input))))))
