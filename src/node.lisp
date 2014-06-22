(in-package :shinrabanshou)


;;;;;
;;;;; 述語
;;;;;
(defgeneric nodep (obj) (:documentation "symbolで指定された class が node のサブクラスかどうかを返す。
でも、こんなんでエエんじゃろうか。。。。
ほかにスマートな方法がありそうなんじゃけど。。。"))
(defmethod nodep (obj) (declare (ignore obj)) nil)
(defmethod nodep ((node node)) t)
(defmethod nodep ((class-symbol symbol))
  (handler-case
      (nodep (make-instance class-symbol))
    (error () nil)))


(defmethod existp ((pool banshou) (node node))
  (not (null (get-object-with-id pool (class-name (class-of node)) (get-id node)))))



;;;;;
;;;;; 削除
;;;;;
(defgeneric tx-delete-node ( banshou node)
  (:documentation "Nodeを削除します。"))
(defmethod tx-delete-node ((system banshou) (node node))
  (execute-transaction
   (tx-delete-object system 'node (get-id node))))


;;;;;
;;;;; 作成
;;;;;
(defgeneric tx-make-node (banshou class-symbol &rest slots)
  (:documentation ""))
(defmethod tx-make-node ((system banshou) (class-symbol symbol) &rest slots)
  (unless (nodep class-symbol)
    (error "このクラスは node のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
  (tx-make-shinra system class-symbol (pairify slots)))


;; 推奨しない。 いずれは廃棄予定。
(defgeneric make-node (banshou class-symbol &rest slots)
  (:documentation ""))
(defmethod make-node ((system banshou) (class-symbol symbol) &rest slots)
  (unless (nodep class-symbol)
    (error "このクラスは node のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
  ;; ここじゃぁ tx-meke-node を呼ぶべきじゃが、、、slots んところがねぇ。。。。マクロにせんといけんけぇ、あとまわしにしよ。
  ;; とりあえずこれで動くけぇ
  (execute-transaction
   (tx-make-shinra system class-symbol (pairify slots))))



