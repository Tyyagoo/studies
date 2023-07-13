(ns matching-brackets)

; from @jaihindhreddy
(def ^:private matching {\{ \}, \[ \], \( \)})
(def ^:private opening? (set (keys matching)))
(def ^:private bracket? (into opening? (vals matching)))

(defn valid? [s]
  (->> s
    (filter bracket?)
    (reduce
      (fn [stack, c]
        (cond (= (matching (first stack)) c) (rest stack)
              (opening? c)                   (conj stack c)
              :else                          (reduced (list :error))
         ))
     (list))
    (empty?)))
