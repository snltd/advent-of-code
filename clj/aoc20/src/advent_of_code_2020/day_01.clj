(ns advent-of-code-2020.day-01
 (:require [clojure.math.combinatorics :as combo]
           [advent-of-code-2020.core :as core]))

(defn numbers-summing-to
  "Returns a seq of seqs, length l of combinations of input which sum to the
  given number. "
  [input sum l]
  (first (filter #(= sum (reduce + %)) (combo/combinations input l))))

(defn solve-for-n
  [input n]
    (reduce * (numbers-summing-to input 2020 n))
  )

(defn solve-01
  [input-file]
    (solve-for-n (core/load-input-ints input-file) 2)
  )

(defn solve-02
  [input-file]
    (solve-for-n (core/load-input-ints input-file) 3)
  )

(defn solve
  []
  (core/solve-all "01" solve-01 solve-02))
