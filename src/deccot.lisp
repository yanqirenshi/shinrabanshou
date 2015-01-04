(in-package :shinrabanshou)


;;;;;
;;;;; deccot
;;;;;
(defgeneric get-owner-edge-at-deccot (banshou deccot)
  (:documentation "")
  (:method ((pool banshou) (deccot deccot))
    "TODO:もっと効率的なコードがかけるんじゃろうけど。"
    (car
     (let ((to-id (get-id deccot)))
       ;; type = :own-a のやつ。 これ find でええんじゃない？ そしたら car いらんし。
       (remove-if #'(lambda (y) (not (eq :own-a (get-edge-type y))))
                  ;; from が自分のやつで
                  (remove-if #'(lambda (x) (not (eq to-id (get-to-node-id x))))
                             (get-root-object pool (object-root-name 'edge))))))))


(defmethod get-user ((pool banshou) (deccot deccot))
  "TODO: deccot -- :have --> user = (null) みたいな検索できんとイケんねぇ。
Graph理論をもっと勉強せんとイケん。
gremlin を参考にしよう。
それをS式にしてもエエんじゃろうけどね。"
  (let ((edge (get-owner-edge-at-deccot pool deccot)))
    (when edge
      (get-at-id pool (get-from-node-id edge)))))



;; make
(defgeneric make-deccot (banshou user &key name password note timestamp)
  (:documentation "デコットを作成します。
----------
TODO: 名称が tx-make-deccot の必要がある。
")
  (:method ((pool banshou) (creater user)
            &key
              (name "@未設定")
              (password (gen-password))
              (note "")
              (timestamp (get-universal-time)))
    (values (tx-make-node pool 'deccot
                          'create-time (make-footprint nil :timestamp timestamp)
                          'update-time nil
                          'buddha (make-footprint nil :timestamp timestamp)
                          'nirvana nil
                          'password password
                          'name name
                          'note note)
            password)))


(defgeneric add-deccot (banshou place deccot type &rest slots)
  (:documentation "user に デコットを追加します。")
  (:method ((pool banshou) (user user) (deccot deccot) type &rest slots)
    ;; TODO: Check => user:deccot=1:n
    (when (get-user pool deccot)
      (error "このデコットはすでに誰かが所有しとるけぇ、アンタのもんにゃぁならんけぇ。"))
    ;; check type
    (when (not (eq type :own-a))
      (error "type は :own-a しか許しとらんのんよ。ごめんねぇ。type=~a" type))
    ;; do make
    (make-edge pool 'edge user deccot type slots)))





;;;
;;; printer
;;;
;; (print-deccot-lit *sys*)
(defun gen-list-sep (len) (make-string len :initial-element #\-))

(defgeneric print-deccot-lit (banshou &key stream)
  (:documentation "")
  (:method ((pool banshou) &key (stream t))
    (let ((fmt "| ~4a | ~5a |  ~a ~%"))
      (format stream fmt "stat" "id" "name")
      (format stream fmt (gen-list-sep 4) (gen-list-sep 5) (gen-list-sep 33) )
      (mapcar #'(lambda (x)
                  (format stream fmt
                          (if (lifep x) "life" "dead")
                          (get-id x)
                          (get-name x)))
              (get-object-list pool 'deccot)))))


