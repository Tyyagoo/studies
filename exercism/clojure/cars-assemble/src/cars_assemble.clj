(ns cars-assemble)

(defn production-rate
  "Returns the assembly line's production rate per hour,
   taking into account its success rate"
  [speed]
  (def max-cars (* speed 221))
  (cond (= speed 0)   0.0
        (< speed 5)  (* max-cars 1.0)
        (< speed 9)  (* max-cars 0.9)
        (< speed 10) (* max-cars 0.8)
        :else        (* max-cars 0.77)
    ))

(defn working-items
  "Calculates how many working cars are produced per minute"
  [speed]
  (int (/ (production-rate speed) 60)))
