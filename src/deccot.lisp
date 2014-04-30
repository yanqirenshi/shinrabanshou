(in-package :shinrabanshou)


;;;;;
;;;;; deccot
;;;;;
(defmethod get-owner-edge-at-deccot ((sys banshou) (deccot deccot))
  "TODO:もっと効率的なコードがかけるんじゃろうけど。"
  (car
   (let ((to-id (get-id deccot)))
     ;; type = :own-a のやつ
     (remove-if #'(lambda (y) (not (eq :own-a (get-edge-type y))))
                ;; from が自分のやつで
                (remove-if #'(lambda (x) (not (eq to-id (get-to-node-id x))))
                           (get-root-object sys (object-root-name 'edge)))))))

;;(get-user *sys* *deccot*)
(defmethod get-user ((sys banshou) (deccot deccot))
  "TODO: deccot -- :have --> user = (null) みたいな検索できんとイケんねぇ。
Graph理論をもっと勉強せんとイケん。
gremlin を参考にしよう。
それをS式にしてもエエんじゃろうけどね。"
  (let ((edge (get-owner-edge-at-deccot sys deccot)))
    (when edge
      (get-at-id sys (get-from-node-id edge)))))



;; make
(defmethod make-deccot ((sys banshou)
                        (creater user)
                        &key
                          (name "@未設定")
                          (password (gen-password))
                          (note "")
                          (timestamp (get-universal-time)))
  (values (make-node sys 'deccot
                     'create-time (make-footprint nil :timestamp timestamp)
                     'update-time nil
                     'buddha (make-footprint nil :timestamp timestamp)
                     'nirvana nil
                     'password password
                     'name name
                     'note note)
          password))


;; add
(defgeneric add-deccot (banshou place deccot type &rest slots) (:documentation ""))
(defmethod  add-deccot ((sys banshou) (user user) (deccot deccot) type &rest slots)
  ;; TODO: Check => user:deccot=1:n
  (when (get-user sys deccot)
    (error "このデコットはすでに誰かが所有しとるけぇ、アンタのもんにゃぁならんけぇ。"))
  ;; check type
  (when (not (eq type :own-a))
    (error "type は :own-a しか許しとらんのんよ。ごめんねぇ。type=~a" type))
  ;; do make
  (make-edge sys 'edge user deccot type slots))





;;;
;;; printer
;;;
;; (print-deccot-lit *sys*)
(defun gen-list-sep (len) (make-string len :initial-element #\-))

(defmethod print-deccot-lit ((sys banshou) &key (stream t))
  (let ((fmt "| ~4a | ~5a |  ~a ~%"))
    (format stream fmt "stat" "id" "name")
    (format stream fmt (gen-list-sep 4) (gen-list-sep 5) (gen-list-sep 33) )
    (mapcar #'(lambda (x)
                (format stream fmt
                        (if (lifep x) "life" "dead")
                        (get-id x)
                        (get-name x)))
            (get-object-list sys 'deccot))))


