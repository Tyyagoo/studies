(ns difference-of-squares)

(defn- two-sums [n] (* n (+ n 1)))

(defn sum-of-squares [n] (/ (* (+ (* 2 n) 1) (two-sums n)) 6))

(defn square-of-sum [n] (int (Math/pow (/ (two-sums n) 2) 2)))

(defn difference [n] (- (square-of-sum n) (sum-of-squares n)))