(ns advent-of-code-2021.day-04
  (:require [advent-of-code-2021.core :as core])
  (:require [clojure.string :as str :alias (split split-lines)]))

(defn load-input [file]
  (core/load-input-blocks file))

(defn get-numbers [input]
  (core/strings->ints (str/split (first input) #",")))

(defn block->card [block]
  (map core/int-fields (str/split-lines block)))

(defn cross-off-number-row [row number]
  (for [n row] (when-not (= n number) n)))

(defn cross-off-number [card number]
  (map #(cross-off-number-row %1 number) card))

(defn winner-row [row]
  (every? nil? row))

(defn rotate [card]
  (apply map list card))

(defn winner?
  "we have a winner if any row or column is all nil"
  [card]
  (or (not-every? false? (map winner-row card))
      (not-every? false? (map winner-row (rotate card)))))

(defn sum-card [card]
  (apply + (filter some? (flatten card))))

(defn beat-the-squid [numbers cards]
  (loop [n numbers
         c cards]
    (let [[number & remaining] n
          nc (map #(cross-off-number %1 number) c)
          winners (not-empty (filter winner? nc))]

      (if winners
        (* number (sum-card winners))
        (recur remaining nc)))))

(defn lose-to-the-squid [numbers cards]
  (loop [n numbers
         c cards]
    (let [[number & remaining] n
          nc (map #(cross-off-number %1 number) c)
          winners (not-empty (filter winner? nc))]

      (if (= (count winners) (count cards))
        (beat-the-squid [number] (remove winner? c))
        (recur remaining nc)))))

(defn solve-01 [input]
  (beat-the-squid (get-numbers input) (map block->card (rest input))))

(defn solve-02 [input]
  (lose-to-the-squid (get-numbers input) (map block->card (rest input))))

(defn solve [] (core/solve-all "04" load-input solve-01 solve-02))
