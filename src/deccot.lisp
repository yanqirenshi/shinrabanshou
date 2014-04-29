(in-package :shinrabanshou)


;;;;;
;;;;; deccot
;;;;;
(defmethod get-user ((sys banshou) (deccot deccot))
  "TODO: deccot -- :have --> user = (null) みたいな検索できんとイケんねぇ。 "
  (declare (ignore  sys deccot))
  t)

(defgeneric add-deccot (banshou place deccot type &rest slots) (:documentation ""))
(defmethod  add-deccot ((sys banshou) (user user) (deccot deccot) type &rest slots)
  ;; TODO: Check => user:deccot=1:n
  (when (not (eq type :have)) (error "type は :have しか許しとらんのんよ。ごめんねぇ。type=~a" type))
  (let ((owners (get-user sys deccot)))
    ;; TODO: (member user owners) でチェックせんとね。
    (declare (ignore owners))
    (make-edge sys 'edge user deccot type slots)))


