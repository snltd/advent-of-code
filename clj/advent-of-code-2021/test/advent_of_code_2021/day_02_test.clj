(ns advent-of-code-2021.day-02-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :as core]
            [advent-of-code-2021.day-02 :as problem]))

(def right-answer-01 150)
(def right-answer-02 900)
(defn test-input [] (problem/load-input (core/sample-input-file "02")))

(deftest parst-inst-test
  (testing "get an instruction and a value"
    (is (= ["forward" 5] (problem/parse-inst "forward 5")))))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (problem/solve-01 (test-input))))
    (is (= right-answer-02 (problem/solve-02 (test-input))))))
