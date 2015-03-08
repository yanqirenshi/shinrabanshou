;;;;;
;;;;; Contents
;;;;;   1. 万象
;;;;;   2. Permission
;;;;;   3. Index
;;;;;   4. Printer
;;;;;

(in-package :shinrabanshou)



;;;;;
;;;;; 1. 万象
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
;;;;; 2. Permission
;;;;;
(defmethod chek-permission ((pool banshou) (user user) &rest param)
  (list pool user param))



;;;;;
;;;;; 3. Index
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
;;;;; 4. Printer
;;;;;
;; (print-user-list *sys* (master-user *sys*))
(defmethod print-user-list ((pool banshou) (user user) &key (stream t))
  (mapcar #'(lambda (u)
              (format stream
                      "| ~20a | ~a~%"
                      (get-code u)
                      (get-name u)))
          (up:get-object-list pool 'user)))



#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#

