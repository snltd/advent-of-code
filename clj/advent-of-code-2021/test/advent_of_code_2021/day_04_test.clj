(ns advent-of-code-2021.day-04-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :as core]
            [advent-of-code-2021.day-04 :as problem]))

(def right-answer-01 4512)
(def right-answer-02 1924)
(defn test-input [] (problem/load-input (core/sample-input-file "04")))

(def test-grid
  [[22 13 17 11 0]
   [8 2 23 4 24]
   [21 9 14 16 7]
   [6 10 3 18 5]
   [1 12 20 15 19]])

(deftest get-numbers-test
  (testing "get an array of the caller's numbers"
    (is (= [7 4 9 5 11 17 23 2 0 14 21 24 10 16 13 6 15 25 12 22 18 20 8 19 3 26 1]
           (problem/get-numbers (test-input))))))

(deftest block->card-test
  (testing "get from a string input an array of arrays describing a bingo card"
    (is (= test-grid
   (problem/block->card "22 13 17 11  0\n 8  2 23  4 24\n21  9 14 16  7\n 6 10  3 18  5\n 1 12 20 15 19")))))

(deftest cross-off-number-row-test
  (testing "turn the given number into a nil"
    (is (= [1 nil 3] (problem/cross-off-number-row [1 2 3] 2))))
  (testing "leave the row as-is if the number's not there"
    (is (= [1 2 3] (problem/cross-off-number-row [1 2 3] 4)))))

(deftest cross-off-number-test
  (testing "turn 5 into a nil"
    (is (= [[22 13 17 11 0]
            [8 2 23 4 24]
            [21 9 14 16 7]
            [6 10 3 18 nil]
            [1 12 20 15 19]]
           (problem/cross-off-number test-grid 5))))
  (testing "leave the grid as-is if the number's not there"
    (is (= test-grid (problem/cross-off-number test-grid 50)))))

(deftest check-winner?-test
  (testing "no winner, continue the game"
    (is (false? (problem/winner? [[nil 2] [3 nil]])))
    (is (false? (problem/winner? [[1 2] [3 4]]))))
  (testing "winner by row"
    (is (true? (problem/winner? [[nil nil] [1 2]]))))
  (testing "winner by column"
    (is (true? (problem/winner? [[nil 2] [nil 4]])))))

(deftest rotate-test
  (testing "a card is rotated so columns become rows"
    (is (= [[1 3] [2 4]] (problem/rotate [[1 2] [3 4]])))))

(deftest winner-row-test
  (testing "winner winner chicken dinner"
    (is (true? (problem/winner-row [nil nil nil]))))
  (testing "better luck next time"
    (is (false? (problem/winner-row [nil 2 nil])))))

(deftest sum-card
  (testing "the non-nil values should sum correctly"
    (is (= 5 (problem/sum-card [[nil nil] [2 3]])))))

(deftest solve-test
  (testing "get correct value from example data"
    (is (= right-answer-01 (problem/solve-01 (test-input))))
    (is (= right-answer-02 (problem/solve-02 (test-input))))))
