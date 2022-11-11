(ns advent-of-code-2021.day-06
  (:require [advent-of-code-2021.core :as core]))

(defn load-input [file]
  (frequencies (core/load-input-csv-ints file)))

(defn modify-fish-states [states]
  { 0 (get states 1 0)
    1 (get states 2 0)
    2 (get states 3 0)
    3 (get states 4 0)
    4 (get states 5 0)
    5 (get states 6 0)
    6 (+ (get states 0 0) ( get states 7 0))
    7 (get states 8 0)
    8 (get states 0 0)
  })

(defn solve-for-gens [input generations]
  (loop [fish input generations generations]
    (if (zero? generations)
      (apply + (vals fish))
      (recur (modify-fish-states fish) (dec generations)))))

(defn solve-01 [input]
  (solve-for-gens input 80))

(defn solve-02 [input]
  (solve-for-gens input 256))

(defn solve [] (core/solve-all "06" load-input solve-01 solve-02))
