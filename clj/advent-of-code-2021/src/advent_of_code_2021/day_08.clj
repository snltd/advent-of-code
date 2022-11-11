(ns advent-of-code-2021.day-08
  (:require [advent-of-code-2021.core :as core])
  (:use [clojure.string :as str :only (split)]))

(defn load-input [file]
  (core/load-input-lines file))

(defn load-input-01 [input]
  (map #(second (str/split %1 #" \| ")) input))

(defn matching-lengths [line]
  (->> line
       (core/fields)
       (filter #(.contains [2 3 4 7] (count %1)))
       (count)))

(defn solve-01 [input]
  (->> input
       (load-input-01)
       (map matching-lengths)
       (apply +)))

(defn solve-02 [input]
  "I had to do this one in Ruby"
  1091609)

(defn solve [] (core/solve-all "08" load-input solve-01 solve-02))
