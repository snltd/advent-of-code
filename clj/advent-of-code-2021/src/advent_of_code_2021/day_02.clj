(ns advent-of-code-2021.day-02
  (:require [advent-of-code-2021.core :as core])
  (:require [clojure.string :as str :refer (split)]))

(defn load-input [file]
  (core/load-input-lines file))

(defn parse-inst [instruction]
  (let [part (str/split instruction #" ")]
    [(first part) (Integer/parseInt (second part))]))

(defn solve-01 [input]
  (loop [instructions input down 0 across 0]
    (if (empty? instructions)
      (* down across)
      (let [[inst & remaining] instructions
            [direction distance] (parse-inst inst)]
        (case direction
            "forward" (recur remaining down (+ across distance))
            "up" (recur remaining (- down distance) across)
            "down" (recur remaining (+ down distance) across))))))

(defn solve-02 [input]
  (loop [instructions input down 0 across 0 aim 0]
    (if (empty? instructions)
      (* down across)
      (let [[inst & remaining] instructions
            [direction distance] (parse-inst inst)]
        (case direction
            "forward" (recur remaining (+ down (* aim distance)) (+ across distance) aim)
            "up" (recur remaining down across (- aim distance))
            "down" (recur remaining down across (+ aim distance)))))))

(defn solve [] (core/solve-all "02" load-input solve-01 solve-02))
