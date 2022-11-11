(ns advent-of-code-2021.master
  (:require
      [advent-of-code-2021.day-01 :as day-01]
      [advent-of-code-2021.day-02 :as day-02]
      [advent-of-code-2021.day-03 :as day-03]
      [advent-of-code-2021.day-04 :as day-04]
      [advent-of-code-2021.day-05 :as day-05]
      [advent-of-code-2021.day-06 :as day-06]
      [advent-of-code-2021.day-07 :as day-07]))

(defn merp []
  (println "merp"))
(println "merpdddddd")
(defn -main [& args]
  (day-01/solve)
  (day-02/solve)
  (day-03/solve)
  (day-04/solve)
  (day-05/solve)
  (day-06/solve)
  (day-07/solve))
