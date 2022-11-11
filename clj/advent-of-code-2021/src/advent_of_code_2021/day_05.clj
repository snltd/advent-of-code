(ns advent-of-code-2021.day-05
  (:require [advent-of-code-2021.core :as core])
  (:use [clojure.string :as str :only (join)])
  )

(defn unordered-range [a b]
  (if (> b a) (range a (inc b)) (range a (dec b) -1)))

(defn process-vector [line do-diags?]
  (let [[[x1 y1] [x2 y2]] (partition 2 (core/int-fields line #"[, \->]+"))]
    (cond
      (= x1 x2) (for [y (unordered-range y1 y2)] (str/join "," [x1 y]))
      (= y1 y2) (for [x (unordered-range x1 x2)] (str/join "," [x y1]))
      :else (if do-diags?
              (map #(str/join "," %1)
                (map vector (unordered-range x1 x2) (unordered-range y1 y2)))
              []))))

(defn load-input [file]
  (core/load-input-lines file))

(defn solver [input do-diags?]
  (count
    (keys
      (filter (fn [[_k v]] (> v 1) )
        (frequencies (flatten (map #(process-vector %1 do-diags?) input)))))))

(defn solve-01 [input] (solver input false))

(defn solve-02 [input] (solver input true))

(defn solve [] (core/solve-all "05" load-input solve-01 solve-02))
