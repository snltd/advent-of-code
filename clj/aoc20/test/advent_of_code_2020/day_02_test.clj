(ns advent-of-code-2020.day-02-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2020.core :as core]
            [advent-of-code-2020.day-02 :refer :all]))

(def right-answer-01 2)
(def right-answer-02 1)

(deftest unpack-input-test
  (testing "get correct data structure from input"
    (is (= {:letter "a" :lower 1 :upper 3 :password "abcde"}
           (unpack-input "1-3 a: abcde")))))

(deftest parse-range-test
  (testing "get a range from a string of the form a-b"
    (is (= [1 10]
        (parse-range "1-10")
           ))))

(deftest valid-password-01-test
  (testing "does the given letter appear in password the requisitve number of times?"
    (is (true?  (valid-password-01? (unpack-input "1-3 a: abcde"))))
    (is (false?  (valid-password-01? (unpack-input "1-3 b: cdefg"))))))

(deftest solve-01-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (solve-01 (core/sample-input-file "02"))))))

(deftest solve-02-test
  (testing "get correct value from example data"
    (is (= right-answer-02 (solve-02 (core/sample-input-file "02"))))))
