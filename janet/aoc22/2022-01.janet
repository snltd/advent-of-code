#!/usr/bin/env janet

(import "../lib/input")
(import testament :prefix "" :exit true)

(defn solve-01
  [input]
  (apply max (map sum input)))

(defn solve-02
  [input]
  (->> (map sum input)
       (sort)
       (reverse)
       (take 3)
       (sum)))

(def- sample
  ``1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000``)

(def input-type input/as-int-blocks)

(deftest part-01
  (is (= 24000 (solve-01 (input-type sample)))))

(deftest part-02
  (is (= 45000 (solve-02 (input-type sample)))))

(if (= 1 (length (dyn :args))) (run-tests!))
