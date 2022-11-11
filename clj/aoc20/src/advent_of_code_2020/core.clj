(ns advent-of-code-2020.core
  (:use [clojure.string :as str :only (split-lines)]))

(def input-dir "/home/rob/work/advent-of-code-2020/input")
(def sample-input-dir "/home/rob/work/advent-of-code-2020/spec/input")

(defn to-int
  "turn a list of strings which look like numbers into a list of actual numbers"
  [lines]
  (map #(Integer/parseInt %) lines))

(defn load-input-raw
  "return the given file as a list of lines"
  [file]
  (str/split-lines (slurp file)))

(defn load-input-ints
  "return the given file as a list of integers"
  [file]
  (to-int (load-input-raw file)))

(defn input-file
  ([day]
   (str input-dir "/" day))
  ([day part]
   (str input-dir "/" day part) ))

(defn sample-input-file
  ([day]
   (str sample-input-dir "/" day))
  ([day part]
   (str sample-input-dir "/" day part) ))

(defn solve-all
  [day fn-solve-01 fn-solve-02]
  (println "day" day "1/2:" (fn-solve-01 (input-file day)))
  (println "day" day "2/2:" (fn-solve-02 (input-file day))))
