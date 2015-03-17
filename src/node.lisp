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
(defmethod nodep (obj) (declare (ignore obj)) nil)
(defmethod nodep ((node vertex)) t)
(defmethod nodep ((class-symbol symbol))
  (handler-case
      (nodep (make-instance class-symbol))
    (error () nil)))


(defmethod existp ((pool banshou) (node vertex))
  (not (null (get-object-with-id pool (class-name (class-of node)) (get-id node)))))


;;;;;
;;;;; 2. 作成
;;;;;
(defmethod tx-make-node ((system banshou) (class-symbol symbol) &optional slots-and-values)
  (unless (nodep class-symbol)
    (error "このクラスは node のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
  (tx-make-shinra system class-symbol slots-and-values))



(defmethod make-node ((system banshou) (class-symbol symbol) &optional slots-and-values)
  (execute-transaction
   (tx-make-node system class-symbol slots-and-values)))



;;;;;
;;;;; 3. 削除
;;;;;
(defmethod tx-delete-node ((pool banshou) (node vertex))
  ;; 現在関係があるものは削除できないようにしています。
  (let ((node-class (class-name (class-of node)))
        (edge-class 'edge))
    (when (or (find-r-edge pool edge-class :from node)
              (find-r-edge pool edge-class :to   node))
      (error "関係を持っている Node は削除できません。"))
    (execute-transaction
     (tx-delete-object pool node-class (get-id node)))))




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#
