(in-package :shinrabanshou)


;;;;;
;;;;; 万象
;;;;;
(defmethod make-banshou ((class-symbol symbol) data-stor)
  (let ((pool (make-pool data-stor :pool-class class-symbol)))
    (when (null (get-root-object pool :id-counter))
      (execute-transaction (tx-create-id-counter pool)))
    (when (null (master-user pool))
      (execute-transaction (tx-make-master-user pool)))
    (index-on pool 'edge '(from to type))
    pool))



;;;;;
;;;;; Permission
;;;;;
(defmethod chek-permission ((pool banshou) (user user) &rest param)
  (list pool user param))



;;;;;
;;;;; getter
;;;;;
(defun class-id-indexp (symbol)
  (scan "^(\\S)+-ID-INDEX$"
        (symbol-name symbol)))


(defun class-id-rootp (symbol)
  (scan "^(\\S)+-ROOT$"
        (symbol-name symbol)))


(defmethod class-id-list ((pool banshou))
  (remove-if (complement #'class-id-indexp)
             (hash-table-keys
              (upanishad::get-root-objects pool))))


(defmethod root-list ((pool banshou))
  (remove-if (complement #'class-id-rootp)
             (hash-table-keys
              (upanishad::get-root-objects pool))))


(defun object-root-name (symbol)
  (upanishad::get-objects-root-name symbol))


(defmethod get-object-list ((pool banshou) (class-symbol symbol))
  (get-root-object pool
                   (object-root-name class-symbol)))



(defmethod get-at-id ((pool banshou) id)
  "もっと効率良いやりかたがありそうじゃけど。。。"
  (car
   (remove nil
           (mapcar #'(lambda (index)
                       (gethash id
                                (get-root-object pool index)))
                   (class-id-list pool)))))





;;;;;
;;;;; index
;;;;;
;;;;; TODO: これも作らんとね。
;;;;;
;; create
(defmethod create-index ((pool banshou) (user user) (class-symbol symbol) (slot-list list))
  (list pool user class-symbol slot-list))


;; remove
(defmethod remove-index ((pool banshou) (user user) (class-symbol symbol) index)
  (list pool user class-symbol index))


;; rebuild
(defmethod rebuild-index ((pool banshou) (user user) (class-symbol symbol) index)
  (list pool user class-symbol index))




;;;;;
;;;;; printer
;;;;;
(defmethod print-root-list ((pool banshou) &key (stream t))
  (mapcar #'(lambda (root)
              (format stream "~10a : count=~a~%"
                      root
                      (length (get-root-object pool root))))
          (root-list pool))
  pool)



;; (print-user-list *sys* (master-user *sys*))
(defmethod print-user-list ((pool banshou) (user user) &key (stream t))
  (mapcar #'(lambda (u)
              (format stream
                      "| ~20a | ~a~%"
                      (get-code u)
                      (get-name u)))
          (get-object-list pool 'user)))

