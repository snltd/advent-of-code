#!/usr/bin/env janet

(import "../lib/input")
(import "../lib/helpers")
(import testament :prefix "" :exit true)

(defn common-item-01
  [line]
  (let [[h1 h2] (partition (/ (length line) 2) (string/bytes line))
        seen (helpers/lookup-table h1)]
    (find |(seen $) h2)))

(defn common-item-02
  [block]
  (let [seen0 (helpers/lookup-table (block 0))
        seen1 (helpers/lookup-table (block 1))]
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
