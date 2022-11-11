(ns advent-of-code-2021.day-01
  (:require [advent-of-code-2021.core :as core]))

(defn load-input [file]
  (core/load-input-ints file))

(defn solve-01 [input]
  (count (filter #(apply < %) (partition 2 1 input))))

(defn solve-02 [input]
  (solve-01 (map #(reduce + %) (partition 3 1 input))))

(defn solve [] (core/solve-all "01" load-input solve-01 solve-02))
