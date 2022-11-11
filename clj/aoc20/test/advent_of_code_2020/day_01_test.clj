(ns advent-of-code-2020.day-01-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2020.core :as core]
            [advent-of-code-2020.day-01 :refer :all]))

(def right-answer-01 514579)
(def right-answer-02 241861950)

(comment deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01
           (solve (load-input-ints (core/sample-input-file "01")) 2) )))
    (is (= right-answer-02
           (solve (load-input-ints (core/sample-input-file "01")) 3) )))
