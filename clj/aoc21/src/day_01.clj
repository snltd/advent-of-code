(ns day-01
  (:require [core] 
            [clojure.test :refer [deftest testing is]]))

(defn load-input [file]
  (core/load-input-ints file))

(defn solve-01 [input]
  (count (filter #(apply < %) (partition 2 1 input))))

(defn solve-02 [input]
  (solve-01 (map #(reduce + %) (partition 3 1 input))))

(defn solve [] (core/solve-all "01" load-input solve-01 solve-02))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= 7 (solve-01 (core/test-input)))
    (is (= 5 (solve-02 (core/test-input)))))))