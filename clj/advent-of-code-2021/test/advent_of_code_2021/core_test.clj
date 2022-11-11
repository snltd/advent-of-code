(ns advent-of-code-2021.core-test
  (:require [clojure.test :refer :all]
            [advent-of-code-2021.core :refer :all]))

(deftest load-input-blocks-test
  (testing "should return a list of strings"
    (is (= "22 13 17 11  0\n 8  2 23  4 24\n21  9 14 16  7\n 6 10  3 18  5\n 1 12 20 15 19"
          (second (load-input-blocks (sample-input-file "04")))))
    (is (= 4 (count ( load-input-blocks (sample-input-file "04")))))))

(deftest load-input-lines-test
  (testing "should return a list of strings"
    (is (= ["123" "456" "789"]
           (load-input-lines "test/advent_of_code_2021/resources/data")))))

(deftest load-input-int-test
  (testing "should return a list of ints"
    (is (= [123 456 789]
           (load-input-ints "test/advent_of_code_2021/resources/data")))))

(deftest load-input-sep-ints-test
  (testing "should return a list of ints"
    (is (= [16 1 2 0 4 2 7 1 2 14]
           (first (load-input-sep-ints (sample-input-file "07") #","))))
    (is (= [2 1 9 9 9 4 3 2 1 0]
           (first (load-input-sep-ints (sample-input-file "09") #""))))))

(deftest strings->ints-test
  (testing "should return a list of ints"
    (is (= [123 456 789]
           (strings->ints ["123" "456" "789"])))))

(deftest fields-test
  (testing "should return an array of fields"
    (is (= ["f1" "f2" "f3" "f4"] (fields " f1    f2  f3 f4"    )))))

(deftest int-fields-test
  (testing "should return an array of fields, as integers"
    (is (= [1 13 26 111] (int-fields "  1 13   26 111")))))

(deftest bin->dec-test
  (testing "should convert binary strings to decimal ints"
    (is (= 23 (bin->dec "10111")))))
