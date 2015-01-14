(in-package :shinrabanshou)


;;;;;
;;;;; 述語
;;;;;
(defgeneric nodep (obj)
  (:documentation "symbolで指定された class が node のサブクラスかどうかを返す。
-----------
TODO:でも、こんなんでエエんじゃろうか。。。。ほかにスマートな方法がありそうなんじゃけど。。。")
  (:method (obj) (declare (ignore obj)) nil)
  (:method ((node node)) t)
  (:method ((class-symbol symbol))
    (handler-case
        (nodep (make-instance class-symbol))
      (error () nil))))


(defmethod existp ((pool banshou) (node node))
  (not (null (get-object-with-id pool (class-name (class-of node)) (get-id node)))))


;;;;;
;;;;; 作成
;;;;;
(defgeneric tx-make-node (banshou class-symbol &optional slots-and-values)
  (:documentation "")
  (:method ((system banshou) (class-symbol symbol) &optional slots-and-values)
    (unless (nodep class-symbol)
      (error "このクラスは node のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
    (tx-make-shinra system class-symbol slots-and-values)))



(defgeneric make-node (banshou class-symbol &optional slots-and-values)
  (:documentation "")
  (:method ((system banshou) (class-symbol symbol) &optional slots-and-values)
    (execute-transaction
     (tx-make-node system class-symbol slots-and-values))))



;;;;;
;;;;; 削除
;;;;;
(defgeneric tx-delete-node (banshou node)
  (:documentation "Nodeを削除します。
現在、関係を持っている Node は削除できないようにしています。
2014/7/26
なんじゃあるんかいね。
でもこれ、関係があったらそれらをq返すようにしたほうが良さそうじゃね。
どんとなんあるか判断できるもんね。
")
  (:method ((pool banshou) (node node))
    ;; 現在関係があるものは削除できないようにしています。
    (let ((node-class (class-name (class-of node)))
          (edge-class 'edge))
      (when (or (find-r-edge pool edge-class :from node)
                (find-r-edge pool edge-class :to   node))
        (error "関係を持っている Node は削除できません。"))
      (execute-transaction
       (tx-delete-object pool node-class (get-id node))))))
