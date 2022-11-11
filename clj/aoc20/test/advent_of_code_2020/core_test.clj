(ns advent-of-code-2020.core-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2020.core :refer :all]))

(deftest load-input-test
  (testing "should return a list of strings"
    (is (= ["123" "456" "789"]
           (load-input-raw "test/advent_of_code_2020/resources/data")))))

(deftest load-input-int-test
  (testing "should return a list of ints"
    (is (= [123 456 789]
           (load-input-ints "test/advent_of_code_2020/resources/data")))))

(deftest to-int-test
  (testing "should return a list of ints"
    (is (= [123 456 789]
           (to-int ["123" "456" "789"])))))
