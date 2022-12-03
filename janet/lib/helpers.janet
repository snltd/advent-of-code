(defn lookup-table
  "make a lookup table from an array"
  [arr]
  (zipcoll arr (array/new-filled (length arr) true)))
