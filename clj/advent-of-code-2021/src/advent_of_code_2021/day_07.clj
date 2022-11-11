(ns advent-of-code-2021.day-07
  (:require [advent-of-code-2021.core :as core]))

(defn load-input [file]
  (first (core/load-input-sep-ints file #",")))

(defn search-range
  "I'm going to use a targeted brute-force. I think the optimal point has to be
  somewhere close to the mean position of the crabs"
  [positions]
  (let [mean (quot (apply + positions) (count positions))]
    (range (- mean 2) (+ mean 3))))

(defn dists-to-point-01 [point positions]
  (->> positions
    (map #(Math/abs ( - %1 point)))
    (apply +)))

(defn dists-to-point-02 [point positions]
  (->> positions
    (map #(apply + (range 1 (inc (Math/abs ( - %1 point))))))
    (apply +)))

(defn solve-01 [input]
  (-> (sort (for [p (search-range input)] [(dists-to-point-01 p input) p]))
       first
       first))

(defn solve-02 [input]
  (-> (sort (for [p (search-range input)] [(dists-to-point-02 p input) p]))
       first
       first))

(defn solve [] (core/solve-all "07" load-input solve-01 solve-02))
