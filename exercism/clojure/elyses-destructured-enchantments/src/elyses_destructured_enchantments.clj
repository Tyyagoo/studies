(ns elyses-destructured-enchantments)

(defn first-card [[x]] x)

(defn second-card [[_ x]] x)

(defn swap-top-two-cards [[x y & zs]] (concat [y x] zs))

(defn discard-top-card [[x & xs]] [x xs])

(def face-cards ["jack" "queen" "king"])

(defn insert-face-cards [[x & xs]] (filter boolean (concat [x] face-cards xs)))
