#!/usr/bin/env janet

(import "../lib/input")
(import testament :prefix "" :exit true)

(defn common-item-01
  [line]
  (let [[h1 h2] (partition (/ (length line) 2) (string/bytes line))
        seen (zipcoll h1 (array/new-filled (length h1) true))]
    (find |(seen $) h2)))

(defn common-item-02
  [block]
  (let [seen0 (zipcoll (string/bytes (block 0)) (array/new-filled (length (block 0)) true))
        seen1 (zipcoll (string/bytes (block 1)) (array/new-filled (length (block 1)) true))]
    (find |(and (seen0 $) (seen1 $)) (string/bytes (last block)))))

(defn value-of
  [char]
  (if (< 96 char) (- char 96) (- char 38)))

(defn solve-01
  [input]
    (sum (map value-of (map common-item-01 input))))

(defn solve-02
  [input]
  (sum (map value-of (map common-item-02 (partition 3 input)))))

(def- sample
  ``vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw``)

(def input-type input/as-lines)

(deftest part-01
  (is (= 157 (solve-01 (input-type sample)))))

(deftest part-02
  (is (= 70 (solve-02 (input-type sample)))))

(if (= 1 (length (dyn :args))) (run-tests!))
