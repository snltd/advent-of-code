(import spork/path)

# Functions to (at least partially) process AoC input. We return arrays, which
# are mutable. Originally it was tuples, but forcing the array to tuple seems
# messy. To go back, wrap the return in (tuple ;)

(def root
  (-> (path/dirname *current-file*) (path/join ".." "input")))

(defn raw
  "a string of the input for a day defined by two strings"
  [year day]
  (slurp (path/join root year day)))

(defn as-lines
  "the given string input as an array of lines"
  [input]
  (map string/trim (string/split "\n" (string/trim input))))

(defn as-ints
  "assuming input is a list of ints, return an array of numbers"
  [input]
  (map scan-number (as-lines input)))

(defn as-blocks
  "return an array of strings which were separated by blank lines"
  [input]
  (string/split "\n\n" (string/trim input)))

(defn as-int-blocks
  "assuming input is a list of ints, return an array of arrays of ints"
  [input]
  (map as-ints (as-blocks input)))

(defn word->chars
  "turn a string into an array of its characters, like Ruby's #chars. Probably
  only works for 7-bit ASCII"
  [word]
  (map string/from-bytes (string/bytes word)))

(defn as-char-grid
  "turn input string into an array of arrays of chars"
  [input]
  (map word->chars (as-lines input)))
