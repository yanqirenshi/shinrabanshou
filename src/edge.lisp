(in-package :shinrabanshou)


;;;;;
;;;;; 述語
;;;;;
(defgeneric edgep (obj) (:documentation "symbolで指定された class が edge のサブクラスかどうかを返す。
でも、こんなんでエエんじゃろうか。。。。
ほかにスマートな方法がありそうなんじゃけど。。。"))
(defmethod edgep (obj) (declare (ignore obj)) nil)
(defmethod edgep ((edge edge)) t)
(defmethod edgep ((class-symbol symbol))
  (handler-case
      (edgep (make-instance class-symbol))
    (error () nil)))


(defmethod existp ((pool banshou) (edge edge))
  (let ((exist (get-object-with-id pool (class-name (class-of edge)) (get-id edge))))
    (when (not (null exist))
      (if
       ;; これ以降は不要なチェックみたいになっとるけど。。。。
       ;; これ以降のチェックがNGの場合は 例外発生させてもエエレベルなんよね。やっぱそうしよ。
       (and (= (get-from-node-id edge) (get-from-node-id exist))
            (= (get-to-node-id edge) (get-to-node-id exist))
            (eq (get-from-node-class edge) (get-from-node-class exist))
            (eq (get-to-node-class edge) (get-to-node-class exist))
            (eq (get-edge-type edge) (get-edge-type exist)))
       t
       (error "id(~a) はおおとるんじゃけど、なんか内容が一致せんけぇ。おかしいじゃろう。 "
              (get-id edge))))))


;;;;;
;;;;; 削除
;;;;;
(defgeneric tx-delete-edge (banshou edge)
  (:documentation "Nodeを削除します。"))
(defmethod tx-delete-edge ((pool banshou) (edge edge))
  ;; まずはスロット・インデックスの削除
  (mapcar #'(lambda (slot) (up:tx-remove-object-on-slot-index pool edge slot))
          '(from to type))
  ;; 本体と プライマリ・インデックスを削除
  (tx-delete-object pool (class-name (class-of edge)) (get-id edge)))



;;;;;
;;;;; 作成
;;;;;
(defgeneric tx-make-edge (banshou class-symbol from to type &rest slots)
  (:documentation ""))
(defmethod tx-make-edge ((system banshou) (class-symbol symbol) (from node) (to node) type &rest slots)
  (cond ((null (get-id from)) (error "この node(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null (get-id to))   (error "この node(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null type)          (error "type が空っちゅうのはイケんよ。なんか適当でエエけぇ決めんさいや。")))
  (unless (edgep class-symbol)
    (error "このクラスは edge のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
  (let ((param (list 'from       (get-id from)
                     'from-class (class-name (class-of from))
                     'to         (get-id to)
                     'to-class   (class-name (class-of to))
                     'type      type)))
    (tx-make-shinra system class-symbol
                    (pairify (if (null slots)
                                 (concatenate 'list slots param)
                                 param)))))

;; 推奨しない。 いずれは廃棄予定。
(defgeneric make-edge (banshou class-symbol from to type &rest slots)
  (:documentation ""))
(defmethod make-edge ((pool banshou)
                      (class-symbol symbol)
                      (from node) (to node) type
                      &rest slots)
  (execute-transaction (tx-make-edge pool class-symbol from to type slots)))


;;;;;
;;;;; accsessor
;;;;;
(defgeneric get-from-node (banshou edge) (:documentation ""))
(defmethod get-from-node ((system banshou) (edge edge))
  (get-at-id system (get-from-node-id edge)))


(defgeneric get-to-node (banshou edge) (:documentation ""))
(defmethod get-to-node ((system banshou) (edge edge))
  (get-at-id system (get-to-node-id edge)))
