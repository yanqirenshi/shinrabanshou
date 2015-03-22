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
(defmethod vertexp ((vertex shin)) t)
(defmethod vertexp ((class-symbol symbol))
  (handler-case
      (vertexp (make-instance class-symbol))
    (error () nil)))


(defmethod existp ((pool banshou) (vertex shin))
  (not (null (get-object-with-id pool (class-name (class-of vertex)) (id vertex)))))


;;;;;
;;;;; 2. 作成
;;;;;
(defmethod tx-make-vertex ((graph banshou) (class-symbol symbol) &optional slots-and-values)
  (unless (vertexp class-symbol)
    (error "このクラスは vertex のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
  (tx-create-object graph class-symbol slots-and-values))


(defmethod make-vertex ((graph banshou) (class-symbol symbol) &optional slots-and-values)
  (execute-transaction
   (tx-make-vertex graph class-symbol slots-and-values)))



;;;;;
;;;;; 3. 削除
;;;;;
(defmethod tx-delete-vertex ((pool banshou) (vertex shin))
  ;; 現在関係があるものは削除できないようにしています。
  (let ((vertex-class (class-name (class-of vertex)))
        (edge-class 'edge))
    (when (or (find-r-edge pool edge-class :from vertex)
              (find-r-edge pool edge-class :to   vertex))
      (error "関係を持っている Vertex は削除できません。"))
    (execute-transaction
     (tx-delete-object pool vertex-class (id vertex)))))




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#
