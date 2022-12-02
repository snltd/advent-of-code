(import "spork/test")
(import "spork/path")
(import "../lib/input")
(import testament :prefix "" :exit true)

(defn sample
  "load the given sample"
  [name]
  (slurp (path/join (path/dirname *current-file*) ".." "test_inputs" name)))

(deftest root-exists
  (os/stat input/root) "cannot find input-root")

(deftest raw-real-input
  (let [raw-lines (input/as-lines (input/raw "2022" "01"))]
    (is (= 2243 (length raw-lines)))
    (is (= "1870" (last raw-lines)))
    (is (= "3427" (first raw-lines)))))

(deftest as-lines
  (is (deep= @["3" "5" "7" "9"] (input/as-lines (sample "int_list"))))
  (is (deep= @["abc" "def" "ghi"] (input/as-lines (sample "word_list")))))

(deftest as-ints
  (is (deep= @[3 5 7 9] (input/as-ints (sample "int_list")))))

(deftest as-blocks
  (is (deep= @["block0" "block1\nblock1" "block2"]
             (input/as-blocks (sample "blocks")))))

(deftest as-int-blocks
  (is (deep= @[@[1] @[3 4 3] @[90 10]]
             (input/as-int-blocks (sample "int_blocks")))))

(deftest word->chars
  (is (deep= @["a" "b" "c"] (input/word->chars "abc"))))

(deftest as-char-grid
  (is (deep= @[@["a" "b" "c"]
               @["d" "e" "f"]
               @["g" "h" "i"]]
             (input/as-char-grid (sample "word_list")))))

(run-tests!)
