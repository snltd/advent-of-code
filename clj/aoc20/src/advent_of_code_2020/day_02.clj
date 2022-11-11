(ns advent-of-code-2020.day-02
 (:require [advent-of-code-2020.core :as core])
 (:use [clojure.string :as str :only (split)]))

(defn parse-range
  "return numbers a and b from a string of the form a-b"
  [a-b]
   (vec (map #(Integer/parseInt %) (str/split a-b #"-"))))

(defn unpack-input
  "turn raw input into a data structure"
  [raw]
  (let [[a-b letter password] (str/split raw #"[ :]+")
        [lower upper] (parse-range a-b)]
    {:letter letter
     :lower lower
     :upper upper
     :password password }))

(defn load-input
  "load the puzzle input and convert it to a map of data"
  [file]
  (map unpack-input (core/load-input-raw file)))

(defn valid-password-01?
  "does the given letter appear in password the requisitve number of times?"
  [input]
   (let [{:keys [letter upper lower password]} input
         cnt (count (filter #(= letter %) (str/split password #"")))]
     (and (>= cnt lower) (<= cnt upper))))

(defn valid-password-02?
  "does the given letter occur at the right point in the password"
  [input]
  (let [{:keys [letter upper lower password]} input
        p1 (get password (dec lower))
        p2 (get password (dec upper))]
    (= 1 (count (filter #(= letter (str %)) [p1 p2])))))

(defn solve-01
  [input-file]
  (count (filter valid-password-01? (load-input input-file))))

(defn solve-02
  [input-file]
  (count (filter valid-password-02? (load-input input-file))))

(defn solve
  []
  (core/solve-all "02" solve-01 solve-02))
