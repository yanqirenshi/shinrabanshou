(in-package :shinrabanshou)


;;;;;
;;;;; resource
;;;;;
(defgeneric lifep (resource &key time)
  (:documentation"リソースが生きているかを返します。"))
(defmethod lifep ((rsc resource) &key (time (get-universal-time)))
  (let ((from (get-buddha  rsc)) (to   (get-nirvana rsc)))
    (cond ((and (null to)
                (<= (get-timestamp from) time))
           t)
          ((and (not (null to))
                (and (<= (get-timestamp from) time)
                     (<= (get-timestamp time) to)))
           t)
          (t nil))))



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


(defgeneric edgep (obj) (:documentation "symbolで指定された class が edge のサブクラスかどうかを返す。
でも、こんなんでエエんじゃろうか。。。。
ほかにスマートな方法がありそうなんじゃけど。。。"))
(defmethod edgep (obj) (declare (ignore obj)) nil)
(defmethod edgep ((edge edge)) t)
(defmethod edgep ((class-symbol symbol))
  (handler-case
      (edgep (make-instance class-symbol))
    (error () nil)))



(defmethod existp ((pool banshou) (node node))
  (not (null (get-object-with-id pool (class-name (class-of node)) (get-id node)))))


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
(defgeneric tx-delete-node ( banshou node)
  (:documentation "Nodeを削除します。"))
(defmethod tx-delete-node ((system banshou) (node node))
  (execute-transaction
   (tx-delete-object system 'node (get-id node))))


(defgeneric tx-delete-edge (banshou edge)
  (:documentation "Nodeを削除します。"))
(defmethod tx-delete-edge ((pool banshou) (edge edge))
  ;; まずはスロット・インデックスの削除
  (mapcar #'(lambda (slot) (up:tx-remove-object-on-slot-index pool edge slot))
          '(from to type))
  ;; 本体と プライマリ・インデックスを削除
  (tx-delete-object pool (class-name (class-of edge)) (get-id edge)))



;;;;;
;;;;; 作る系の基礎
;;;;;
;; shinra
(defgeneric tx-make-shinra (banshou class-symbol slots-and-values)
  (:documentation ""))
(defmethod tx-make-shinra ((banshou banshou) class-symbol slots-and-values)
  ;; TODO: class-symbol は standard-class かどうかを調べる必要があるね。
  ;; TODO: class-symbol は shinra のサブクラスかどうかをチェックする必要があるね。
  ;; TODO: 全体的にタイプチェックについて調べる必要があるね。
  (tx-create-object banshou class-symbol slots-and-values))


;; 推奨しない。 いずれは廃棄予定。
(defgeneric make-shinra (banshou class-symbol slots-and-values)
  (:documentation ""))
(defmethod make-shinra ((banshou banshou) class-symbol slots-and-values)
  (execute-transaction
   (tx-make-shinra banshou class-symbol slots-and-values)))



;;;;;
;;;;; Node
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



;; 検索 .... ってこれ不要なような。 find-object-with-slot で事足りるけぇ。 若気の至り関数じゃろう。
(defgeneric find-node (banshou slot value)
  (:documentation "Nodeを検索します。"))
(defmethod find-node ((system banshou) slot value)
  (find-object-with-slot system 'node slot value))



;;;;;
;;;;; Edge
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

;; edge operator
(defgeneric get-from-node (banshou edge) (:documentation ""))
(defmethod get-from-node ((system banshou) (edge edge))
  (get-at-id system (get-from-node-id edge)))


(defgeneric get-to-node (banshou edge) (:documentation ""))
(defmethod get-to-node ((system banshou) (edge edge))
  (get-at-id system (get-to-node-id edge)))



;;;;;
;;;;; Relation
;;;;;
(defmethod get-r ((pool banshou) (edge-class-symbol symbol)
                  start
                  (start-node node) (end-node node) rtype)
  (first
   (remove-if #'(lambda (r)
                  (let ((node (getf r :node))
                        (edge (getf r :edge)))
                    (not (and (= (get-id end-node)
                                 (get-id node))
                              (eq rtype (get-edge-type edge))))))
              (find-r pool edge-class-symbol start start-node))))


(defmethod get-r-edge ((pool banshou) (edge-class-symbol symbol)
                       start
                       (start-node node) (end-node node) rtype)
  (let ((r (get-r pool edge-class-symbol start start-node end-node rtype)))
    (when r (getf r :edge))))


(defmethod get-r-node ((pool banshou) (edge-class-symbol symbol)
                       start
                       (start-node node) (end-node node) rtype)
  (let ((r (get-r pool edge-class-symbol start start-node end-node rtype)))
    (when r (getf r :node))))





(defgeneric find-r-edge (pool edge-class-symbol start node)
  (:documentation ""))
(defmethod find-r-edge ((pool banshou) (edge-class-symbol symbol) start (node node))
  (let ((start-slot (cond ((eq start :from) 'from)
                          ((eq start :to  ) 'to))))
    (find-object-with-slot pool edge-class-symbol
                           start-slot (get-id node))))


(defgeneric find-r (pool edge-class-symbol start node)
  (:documentation ""))
(defmethod find-r ((pool banshou) (edge-class-symbol symbol) start (node node))
  (let ((start-symbol (cond ((eq start :from) '(get-to-node-class   get-to-node-id))
                            ((eq start :to  ) '(get-from-node-class get-from-node-id)))))
    (mapcar #'(lambda (edge)
                (list :edge edge
                      :node (find-object-with-id pool
                                                 (funcall (first  start-symbol) edge)
                                                 (funcall (second start-symbol) edge))))
            (find-r-edge pool edge-class-symbol start node))))


(defgeneric find-r-node (pool edge-class-symbol start node)
  (:documentation ""))
(defmethod find-r-node ((pool banshou) (edge-class-symbol symbol) start (node node))
  (mapcar #'(lambda (data)
              (getf data :node))
          (find-r pool edge-class-symbol start node)))
