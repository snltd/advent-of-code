(ns advent-of-code-2021.day-09
  (:require [advent-of-code-2021.core :as core]))

(defn load-input [file]
  (core/load-input-sep-ints file #""))

(defn minimum? [numbers index]
  (and (< (get numbers index) (get numbers (dec index) 10))
       (< (get numbers index) (get numbers (inc index) 10))))

(defn line-minima [numbers row-index]
  (for [idx (range 0 (count numbers)) :when (minimum? numbers idx)]
    [idx row-index]))

(defn solve-01 [input]
  (map-indexed #(line-minima (vec %2) %1) input))

(defn solve-02 [input]
  0)

(defn solve [] (core/solve-all "09" load-input solve-01 solve-02))
