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



;;;;;
;;;;; 検索
;;;;;
(defgeneric find-node (banshou slot value)
  (:documentation "Nodeを検索します。"))
(defmethod find-node ((system banshou) slot value)
  (find-object-with-slot system 'node slot value))



;;;;;
;;;;; 削除
;;;;;
(defgeneric delete-node ( banshou node)
  (:documentation "Nodeを削除します。"))
(defmethod delete-node ((system banshou) (node node))
  (execute-transaction
   (tx-delete-object system 'node (get-id node))))



;;;;;
;;;;; 作る系の基礎
;;;;;
;; shinra
(defgeneric make-shinra (banshou class-symbol slots-and-values)
  (:documentation ""))
(defmethod make-shinra ((banshou banshou) class-symbol slots-and-values)
  ;; TODO: class-symbol は standard-class かどうかを調べる必要があるね。
  ;; TODO: class-symbol は shinra のサブクラスかどうかをチェックする必要があるね。
  ;; TODO: 全体的にタイプチェックについて調べる必要があるね。
  (execute-transaction
   (tx-create-object banshou class-symbol slots-and-values)))



;; node
(defgeneric make-node (banshou class-symbol &rest slots)
  (:documentation ""))
(defmethod make-node ((system banshou) (class-symbol symbol) &rest slots)
  (unless (nodep class-symbol)
    (error "このクラスは node のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
  (make-shinra system class-symbol (pairify slots)))


;; edge
(defgeneric make-edge (banshou class-symbol from to type &rest slots)
  (:documentation ""))
(defmethod make-edge ((system banshou) (class-symbol symbol) (from node) (to node) type &rest slots)
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
    (make-shinra system class-symbol
                 (pairify (if (null slots)
                              (concatenate 'list slots param)
                              param)))))


;; edge operator
(defgeneric get-from-node (banshou edge) (:documentation ""))
(defmethod get-from-node ((system banshou) (edge edge))
  (get-at-id system (get-from-node-id edge)))


(defgeneric get-to-node (banshou edge) (:documentation ""))
(defmethod get-to-node ((system banshou) (edge edge))
  (get-at-id system (get-to-node-id edge)))


(defmethod find-r-edge ((pool banshou) (class-symbol symbol) start (node node))
  (let ((start-slot (cond ((eq start :from) 'from)
                          ((eq start :to  ) 'to))))
    (find-object-with-slot pool class-symbol
                           start-slot (get-id node))))


(defmethod find-r ((pool banshou) (class-symbol symbol) start (node node))
  (let ((start-symbol (cond ((eq start :from) '(get-to-node-class   get-to-node-id))
                            ((eq start :to  ) '(get-from-node-class get-from-node-id)))))
    (mapcar #'(lambda (edge)
                (list :edge edge
                      :node (find-object-with-id pool
                                                 (funcall (first  start-symbol) edge)
                                                 (funcall (second start-symbol) edge))))
            (get-r-edge pool class-symbol start node))))


(defmethod find-r-node ((pool banshou) (class-symbol symbol) start (node node))
  (mapcar #'(lambda (data)
              (getf data :node))
          (get-r pool class-symbol start node)))
