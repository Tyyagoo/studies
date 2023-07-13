(ns interest-is-interesting)

(defn interest-rate
  "Returns the interest rate based on the specified balance."
  [balance]
  (cond (>= balance 5000M) 2.475
        (>= balance 1000M) 1.621
        (>= balance    0M) 0.5
        :else              -3.213))

(defn annual-balance-update
  "Returns the annual balance update, taking into account the interest rate."
  [balance]
  (-> balance
    interest-rate
    (Math/abs)
    (bigdec)
    (/ 100)
    (+ 1)
    (* balance)))

(defn amount-to-donate
  "Returns how much money to donate based on the balance and the tax-free percentage."
  [balance tax-free-percentage]
  (def donation (int (* 2 (* balance (/ tax-free-percentage 100)))))
  (if (pos? balance) donation 0))