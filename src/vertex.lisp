;;;;;
;;;;; Contents
;;;;;    1. 述語
;;;;;    2. 作成
;;;;;    3. 削除
;;;;;

(in-package :shinrabanshou)


;;;;;
;;;;; 1. 述語
;;;;;
(defmethod vertexp (obj) (declare (ignore obj)) nil)
(defmethod vertexp ((vertex vertex)) t)
(defmethod vertexp ((class-symbol symbol))
  (handler-case
      (vertexp (make-instance class-symbol))
    (error () nil)))


(defmethod existp ((pool banshou) (vertex vertex))
  (not (null (get-object-with-id pool (class-name (class-of vertex)) (id vertex)))))


;;;;;
;;;;; 2. 作成
;;;;;
(defmethod tx-make-vertex ((system banshou) (class-symbol symbol) &optional slots-and-values)
  (unless (vertexp class-symbol)
    (error* :bad-class 'vertex class-symbol))
  (tx-make-shinra system class-symbol slots-and-values))



(defmethod make-vertex ((system banshou) (class-symbol symbol) &optional slots-and-values)
  (execute-transaction
   (tx-make-vertex system class-symbol slots-and-values)))



;;;;;
;;;;; 3. 削除
;;;;;
(defmethod tx-delete-vertex ((pool banshou) (vertex vertex))
  ;; 現在関係があるものは削除できないようにしています。
  (let ((vertex-class (class-name (class-of vertex)))
        (edge-class 'edge))
    (when (or (find-r-edge pool edge-class :from vertex)
              (find-r-edge pool edge-class :to   vertex))
      (error* :delete-failed-have-some-edge vertex-class))
    (execute-transaction
     (tx-delete-object pool vertex-class (id vertex)))))




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#
