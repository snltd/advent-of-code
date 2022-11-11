(ns core
  (:require [clojure.string :as str]))

(def input-dir "input")
(def sample-input-dir "sample-input")

(comment
  (defn bin->dec
    "turn a binary string  into a decimal integer"
    [binary]
    (Integer/parseInt binary 2))  )

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

(comment
  (defn input->raw
    "the given file as a single string"
    [file]
    (slurp file)))

(comment
  (defn input->lines
    "the given file as a seq of lines"
    [file]
    (str/split-lines (input->raw file))))

(defn input->ints
  "the given file as a seq of integers"
  [file]
  (strings->ints (input->lines file)))

(comment
  (defn input->ints-csv
    "the given CSV file as a seq of integers"
    [file]
    (int-fields (input->raw file), #",")))

(comment
  (defn input->ints-sep
    "the given file as a seq of integers, separated by regex sep"
    [file sep]
    (map #(int-fields %1 sep) (input->lines file))))

(comment
  (defn input->blocks
    [file]
    (str/split (input->raw file) #"\n\n")))

(defn sample-input-file
  "the path to the example input file for the given day"
  ([]
   (str sample-input-dir "/" (ns-name *ns*))))

(defn test-input
  "load the test input for the calling problem"
  ([]
   (input->ints (sample-input-file)))
  ([f]
   (f (sample-input-file))))

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