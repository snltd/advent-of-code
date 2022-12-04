#!/usr/bin/env janet

(import "../lib/input")
(import "spork/regex")
(import testament :prefix "" :exit true)

(defn- destructure
  [line]
  (map scan-number (string/split " " (regex/replace-all "[\\-,]" " " line))))

(defn contains?
  [line]
    (let [[l1 r1 l2 r2] (destructure line)]
      (or (and (<= l1 l2) (>= r1 r2)) (and (<= l2 l1) (>= r2 r1)))))

(defn overlaps?
  [line]
    (let [[l1 r1 l2 r2] (destructure line)]
      (and (>= r1 l2) (>= r2 l1))))

(defn solve-01
  [input]
  (count contains? input))

(defn solve-02
  [input]
  (count overlaps? input))

(def- sample
  ``2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8``)

(def input-type input/as-lines)

(deftest part-01
  (is (= 2 (solve-01 (input-type sample)))))

(deftest part-02
  (is (= 4 (solve-02 (input-type sample)))))

(if (= 1 (length (dyn :args))) (run-tests!))
