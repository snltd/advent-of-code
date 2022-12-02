#!/usr/bin/env janet

(import "../lib/input")
(import testament :prefix "" :exit true)

(def table-01
  (struct
    "A X" (+ 1 3)
    "A Y" (+ 2 6)
    "A Z" (+ 3 0)
    "B X" (+ 1 0)
    "B Y" (+ 2 3)
    "B Z" (+ 3 6)
    "C X" (+ 1 6)
    "C Y" (+ 2 0)
    "C Z" (+ 3 3)))

# X  lose
# Y  draw
# Z  win
(def table-02
  (struct
    "A X" (+ 0 3)
    "A Y" (+ 3 1)
    "A Z" (+ 6 2)
    "B X" (+ 0 1)
    "B Y" (+ 3 2)
    "B Z" (+ 6 3)
    "C X" (+ 0 2)
    "C Y" (+ 3 3)
    "C Z" (+ 6 1)))

(defn solve-01
  [input]
  (+ ;(map table-01 input)))

(defn solve-02
  [input]
  (+ ;(map table-02 input)))

(def- sample
  ``A Y
    B X
    C Z``)

(def input-type input/as-lines)

(deftest part-01
  (is (= 15 (solve-01 (input-type sample)))))

(deftest part-02
  (is (= 12 (solve-02 (input-type sample)))))

(if (= 1 (length (dyn :args))) (run-tests!))
