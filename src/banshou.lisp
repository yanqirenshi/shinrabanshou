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
;;;
;;; shin
;;;
(defun init-shin-classes (banshou)
  (setf (get-root-object banshou :@vertex-classes) nil))

(defun get-shin-classes (banshou)
  (get-root-object banshou :@vertex-classes))

(defun add-shin-class (banshou symbol)
  (let ((lst (get-shin-classes banshou)))
    (unless (member symbol lst)
      (setf (get-root-object banshou :@vertex-classes) (cons symbol lst)))))


;;;
;;; ra
;;;
(defun init-ra-classes (banshou)
  (setf (get-root-object banshou :@vertex-classes) nil))

(defun get-ra-classes (banshou)
  (get-root-object banshou :@edge-classes))

(defun add-ra-class (banshou symbol)
  (let ((lst (get-ra-classes banshou)))
    (unless (member symbol lst)
      (setf (get-root-object banshou :@edge-classes) (cons symbol lst)))))


;; (up::get-objects-slot-index-name cls slot)

;;;
;;; make banshou
;;;
(defmethod make-banshou ((class-symbol symbol) data-stor)
  (let ((banshou (make-pool data-stor :pool-class class-symbol)))
    ;; init id counter
    (when (null (get-root-object banshou :id-counter))
      (execute-transaction (tx-create-id-counter banshou)))
    ;; init class list
    (init-shin-classes banshou)
    (init-ra-classes banshou)
    ;; make master user
    (when (null (master-user banshou))
      (execute-transaction (tx-make-master-user banshou)))
    banshou))


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
                      (code u)
                      (name u)))
          (up:get-object-list pool 'user)))



#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#

