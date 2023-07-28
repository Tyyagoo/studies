(ns robot-name)

(def ^:private names (atom (set nil)))
(def ^:private alpha (vec (map char (range 65 91))))
(defn- rnd-alpha [] (get alpha (rand-int 26)))
(defn- rnd-dec [] (rand-int 1000))
(defn- random-name [& _]
       (let [robot-name (format "%s%s%03d" (rnd-alpha) (rnd-alpha) (rnd-dec))]
         (if (contains? @names robot-name) (random-name) (do (swap! names conj robot-name) robot-name))))

(defn robot [] (atom (random-name)))
(defn robot-name [robot] @robot)
(defn reset-name [robot] (swap! robot random-name))
