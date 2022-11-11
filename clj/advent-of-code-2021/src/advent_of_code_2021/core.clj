(ns advent-of-code-2021.core
  (:use [clojure.string :as str :only (split-lines split trim)]))

(def input-dir "input")
(def sample-input-dir "test/advent_of_code_2021/input")

(defn bin->dec
  "turn a string of binary into a decimal integer"
  [binary]
  (Integer/parseInt binary 2))

(defn strings->ints
  "turn a list of strings which look like numbers into a list of actual numbers"
  [lines]
  (map #(Integer/parseInt %) lines))

(defn fields
  "break a regex-delimeter string into an array of fields"
  ([string]
   (fields string #" +"))
  ([string sep]
   (str/split (str/trim string) sep)))

(defn int-fields
  "break a  string into an array of fields, which are ints"
  ([string]
   (strings->ints (fields string #" +")) )
  ([string, sep]
   (strings->ints (fields string sep))))

(defn input-file
  "the path to the input file for the given day"
  ([day]
   (str input-dir "/" day))
  ([day part]
   (str input-dir "/" day part)))

(defn sample-input-file
  "the path to the example input file for the given day"
  ([day]
   (str sample-input-dir "/" day))
  ([day part]
   (str sample-input-dir "/" day part)))

(defn load-input-raw
  "the given file as a single string"
  [file]
  (slurp file))

(defn load-input-lines
  "the given file as a seq of lines"
  [file]
  (str/split-lines (load-input-raw file)))

(defn load-input-ints
  "the given file as a seq of integers"
  [file]
  (strings->ints (load-input-lines file)))

(defn load-input-csv-ints
  "the given file as a seq of integers, when it's a comma-separated list"
  [file]
  (int-fields (load-input-raw file), #","))

(defn load-input-sep-ints
  "the given file as a seq of integers, separated by regex sep"
  [file sep]
  (map #(int-fields %1 sep) (load-input-lines file)))

(defn load-input-blocks
  [file]
   (str/split (load-input-raw file) #"\n\n"))

(defn display-answer [day part fn-load-input fn-solve]
  (let [ts (. System (nanoTime))
        answer (->> day
                    (input-file)
                    (fn-load-input)
                    (fn-solve))
        elapsed (/ (- (. System (nanoTime)) ts) 1e6)]
    (printf "day %s %d/2: \033[1;37m%15d\033[0m (%.2fms)\n"
            day part answer elapsed)))

(defn solve-all [day fn-load-input fn-solve-01 fn-solve-02]
  (display-answer day 1 fn-load-input fn-solve-01)
  (display-answer day 2 fn-load-input fn-solve-02)
  (println))
