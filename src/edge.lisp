(in-package :shinrabanshou)


;;;;;
;;;;; 述語
;;;;;
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
       (and (=  (get-from-node-id edge)    (get-from-node-id exist))
            (=  (get-to-node-id edge)      (get-to-node-id exist))
            (eq (get-from-node-class edge) (get-from-node-class exist))
            (eq (get-to-node-class edge)   (get-to-node-class exist))
            (eq (get-edge-type edge)       (get-edge-type exist)))
       t
       (error "id(~a) はおおとるんじゃけど、なんか内容が一致せんけぇ。おかしいじゃろう。 "
              (get-id edge))))))


;;;;;
;;;;; 削除
;;;;;
(defmethod tx-delete-edge ((pool banshou) (edge edge))
  ;; remove edge on index
  (mapcar #'(lambda (slot)
              (up:tx-remove-object-on-slot-index pool edge slot))
          '(from to type))
  ;; remove edge object
  (tx-delete-object pool (class-name (class-of edge)) (get-id edge)))



;;;;;
;;;;; 作成
;;;;;
(defmethod tx-make-edge ((system banshou) (class-symbol symbol) (from node) (to node) type
                         &optional slots)
  (cond ((null (get-id from)) (error "この node(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null (get-id to))   (error "この node(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null type)          (error "type が空っちゅうのはイケんよ。なんか適当でエエけぇ決めんさいや。")))
  (unless (edgep class-symbol)
    (error "このクラスは edge のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
  (let ((param `((from       ,(get-id from))
                 (from-class ,(class-name (class-of from)))
                 (to         ,(get-id to))
                 (to-class   ,(class-name (class-of to)))
                 (type       ,type))))
    (tx-make-shinra system class-symbol (if slots
                                            (append param slots)
                                            param))))

(defmethod make-edge ((pool banshou)
                      (class-symbol symbol)
                      (from node) (to node) type
                      &optional slots)
  (execute-transaction (tx-make-edge pool class-symbol from to type slots)))



;;;;;
;;;;; accsessor
;;;;;
(defmethod get-from-node ((system banshou) (edge edge))
  (get-at-id system (get-from-node-id edge)))


(defmethod get-to-node ((system banshou) (edge edge))
  (get-at-id system (get-to-node-id edge)))


(defun tx-change-from-node (pool edge node)
  (let ((class (class-name (class-of node)))
        (id    (get-id node)))
    (tx-change-object-slots pool
                            class
                            (get-id edge)
                            `((from ,id)
                              (from-class ,class)))))


;;; これは。。。TODO:整理が必要じゃね。
(defun class-symbol (obj)
  (class-name (class-of obj)))
(defun class@ (obj)
  (class-name (class-of obj)))

(defun get-edge-node-slot (type)
  (cond ((eq :from type)
         (values 'from 'from-class))
        ((eq :to type)
         (values 'to 'to-class))
        (t (error "こんとなん知らんけぇ。type=~a" type))))


(defmethod tx-change-node ((pool banshou) (edge edge) type (node node))
  (multiple-value-bind (cls-id cls-class)
      (get-edge-node-slot type)
    (tx-change-object-slots pool
                            (class@ edge)
                            (get-id edge)
                            `((,cls-id    ,(get-id node))
                              (,cls-class ,(class@ node)))))
  (values edge node))


(defmethod tx-change-type ((pool banshou) (edge edge) type)
  (tx-change-object-slots pool
                          (class@ edge)
                          (get-id edge)
                          `((type ,type)))
  edge)

