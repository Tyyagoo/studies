(ns leap)

(defn leap-year? [year]
  (defn- ? (= 0 (mod year %)))
  (or (? 400) (and (? 4) (not (? 100)))))
