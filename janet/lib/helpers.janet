(defn lookup-table
  "make a lookup table from an array"
  [arr]
  (zipcoll arr (array/new-filled (length arr) true)))

(defn each-cons
  "nasty recursive implementation of Ruby's Enumerable#each_cons"
  [window arr &opt i ret]
  (default i 0)
  (default ret @[])
  (if
    (> (+ window i) (length arr))
    ret
    (each-cons window arr (+ 1 i) (array/concat ret (tuple (tuple/slice arr i (+ i window)))))))
