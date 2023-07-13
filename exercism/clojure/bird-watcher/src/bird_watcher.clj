(ns bird-watcher)

(def last-week [0 2 5 3 7 8 4])

(def today last)

(defn inc-bird [birds]
  (assoc birds 6 (-> birds today inc)))

(defn day-without-birds? [birds]
  (not (every? pos? birds)))

(defn n-days-count [birds n]
  (->> birds (take n) (reduce +)))

(defn busy-days [birds]
  (count (filter #(>= % 5) birds)))

(defn odd-week? [birds]
  (every? #(or (zero? %) (odd? %)) birds))
