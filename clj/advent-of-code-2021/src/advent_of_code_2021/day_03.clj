(ns advent-of-code-2021.day-03
  (:require [advent-of-code-2021.core :as core])
  (:use [clojure.string :as str :only (split)]))

(defn load-input [file]
  (core/load-input-lines file))

(defn most-of
  "are there more 1s or more 0s?"
  [input offset op]
  (loop [lines input
         ones 0
         zeros 0]
    (let [[line & remains] lines]
    (if (empty? lines)
      (if (op ones zeros) \1 \0)
      (if (= \1 (get line offset))
       (recur remains (inc ones) zeros)
       (recur remains ones (inc zeros)))))))

(defn ones-or-zeroes
  "given a list of binary strings and an index, returns the most or least common
  value at the given offset. Set op to > to get the most common value, and <
  for the least"

  [input offset op]
  (loop [[line & remains] input
         ones 0
         zeros 0]
    (if (empty? remains)
      (if (op ones zeros) \1 \0)
      (if (= \1 (get line offset))
       (recur remains (inc ones) zeros)
       (recur remains ones (inc zeros))))))

(defn decimal-from-columns
  [input op]
  (core/bin->dec
    (str/join
      ""
      (map-indexed
        (fn [idx _] (ones-or-zeroes input idx op))
          (str/split (first input) #"")))))

(defn filter-input-by-bit-at-idx [input idx bit]
  (filter #(= bit (get %1 idx)) input))

(defn rating-wrapper [input op]
  (core/bin->dec
    (first
      (loop [numbers input
             idx 0]
        (if (= 1 (count numbers))
          numbers
          (recur (filter-input-by-bit-at-idx numbers idx (most-of numbers idx op)) (inc idx)))))))

(defn oxygen-generator-rating [input]
  (rating-wrapper input >=))

(defn co2-scrubber-rating [input]
  (rating-wrapper input <))

(defn solve-01 [input]
  (* (decimal-from-columns input >) (decimal-from-columns input <)))

(defn solve-02 [input]
  (* (oxygen-generator-rating input) (co2-scrubber-rating input)))

(defn solve [] (core/solve-all "03" load-input solve-01 solve-02))
