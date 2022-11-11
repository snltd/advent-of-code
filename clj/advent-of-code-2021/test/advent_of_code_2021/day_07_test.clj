(ns advent-of-code-2021.day-07-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :as core]
            [advent-of-code-2021.day-07 :as problem]))

(def right-answer-01 37)
(def right-answer-02 168)
(defn test-input [] (problem/load-input (core/sample-input-file "07")))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (problem/solve-01 (test-input))))
    (is (= right-answer-02 (problem/solve-02 (test-input))))))
