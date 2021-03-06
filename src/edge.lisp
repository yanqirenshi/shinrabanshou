;;;;;
;;;;; Contents
;;;;;   1. 述語
;;;;;   2. Accsessor
;;;;;   3. 作成
;;;;;   4. 削除
;;;;;   5. 整理中
;;;;;

(in-package :shinrabanshou)


;;;;;
;;;;; 1. 述語
;;;;;
(defmethod edgep (obj) (declare (ignore obj)) nil)
(defmethod edgep ((edge ra)) t)
(defmethod edgep ((class-symbol symbol))
  (handler-case
      (edgep (make-instance class-symbol))
    (error () nil)))


(defmethod existp ((graph banshou) (edge ra))
  (assert-graph graph)
  (let ((exist (get-object-at-%id graph (class-name (class-of edge)) (%id edge))))
    (when (not (null exist))
      (if
       ;; これ以降は不要なチェックみたいになっとるけど。。。。
       ;; これ以降のチェックがNGの場合は 例外発生させてもエエレベルなんよね。やっぱそうしよ。
       (and (=  (from-id    edge) (from-id    exist))
            (=  (to-id      edge) (to-id      exist))
            (eq (from-class edge) (from-class exist))
            (eq (to-class   edge) (to-class   exist))
            (eq (edge-type  edge) (edge-type  exist)))
       t
       (error* :edge-bad-contents (%id edge))))))


;;;;;
;;;;; 2. Accsessor
;;;;;
(defmethod get-from-vertex ((pool banshou) (edge ra))
  (get-object-at-%id pool :all (from-id edge)))


(defmethod get-to-vertex ((pool banshou) (edge ra))
  (get-object-at-%id pool :all (to-id edge)))


(defun tx-change-from-vertex (graph edge vertex)
  (assert-graph graph)
  (let ((class (class-name (class-of vertex)))
        (id    (%id vertex)))
    (tx-change-object-slots graph
                            class
                            (%id edge)
                            `((from-id    ,id)
                              (from-class ,class)))))


(defun tx-change-from-vertex (graph edge vertex)
  (assert-graph graph)
  (let ((class (class-name (class-of vertex)))
        (id    (%id vertex)))
    (tx-change-object-slots graph
                            class
                            (%id edge)
                            `((from-id    ,id)
                              (from-class ,class)))))


;;;;;
;;;;; 3. 作成
;;;;;
(defun indexp (graph class slot)
  (assert-graph graph)
  (let ((name (up::get-objects-slot-index-name class slot)))
    (not (null (up:get-root-object graph name)))))


(defmethod check-exist-edge-indexes ((graph banshou) (class-symbol symbol) slots)
  (let ((slot-length (length slots))
        (exist (remove-if-not #'(lambda (slot) (indexp graph class-symbol slot))
                              slots)))
    (cond ((= (length exist) 0) t)
          ((= (length exist) slot-length) nil)
          (t (error "なんか中途半端に Edge のインデックスが存在するよ。edge=~a" class-symbol)))))


(defmethod make-edge-indexes ((graph banshou) (class-symbol symbol) &optional (slots '(from-id to-id edge-type)))
  (when (check-exist-edge-indexes graph class-symbol slots)
    (index-on graph class-symbol slots)))


(defmethod tx-make-edge ((graph banshou) (class-symbol symbol) (from shin) (to shin) type
                         &optional slots)
  (assert-graph graph)
  (cond ((null (%id from)) (error* :bad-id-is-null "vertex(from)"))
        ((null (%id to))   (error* :bad-id-is-null "vertex(to)"))
        ((null type)      (error* :edge-type-is-null)))
  (unless (edgep class-symbol)
    (error* :bad-class 'ra class-symbol))
  (add-ra-class graph class-symbol)
  (make-edge-indexes graph class-symbol)
  (let ((param `((from-id    ,(%id from))
                 (from-class ,(class-name (class-of from)))
                 (to-id      ,(%id to))
                 (to-class   ,(class-name (class-of to)))
                 (edge-type  ,type))))
    (tx-create-object graph class-symbol (if slots
                                             (append param slots)
                                             param))))

(defmethod make-edge ((graph banshou)
                      (class-symbol symbol)
                      (from shin) (to shin) type
                      &optional slots)
  (execute-transaction (tx-make-edge graph class-symbol from to type slots)))



;;;;;
;;;;; 4. 削除
;;;;;
(defmethod tx-delete-edge ((graph banshou) (edge ra))
  (assert-graph graph)
  ;; remove edge on index
  (mapcar #'(lambda (slot)
              (up:tx-remove-object-on-slot-index graph edge slot))
          '(from-id to-id edge-type))
  ;; remove edge object
  (tx-delete-object graph (class-name (class-of edge)) (%id edge)))

(defmethod delete-edge ((graph banshou) (edge ra))
  (execute-transaction (tx-delete-edge graph edge)))


;;;;;
;;;;; 5. 整理中
;;;;;
;;; これは。。。TODO:整理が必要じゃね。
(defun class-symbol (obj)
  (class-name (class-of obj)))
(defun class@ (obj)
  (class-name (class-of obj)))

(defun get-edge-vertex-slot (type)
  (cond ((eq :from type) (values 'from-id 'from-class))
        ((eq :to type)   (values 'to-id   'to-class))
        (t (error* :understand-this-value "edge-slot" type))))


(defmethod tx-change-vertex ((graph banshou) (edge ra) type (vertex shin))
  (assert-graph graph)
  (multiple-value-bind (cls-id cls-class)
      (get-edge-vertex-slot type)
    (tx-change-object-slots graph
                            (class@ edge)
                            (%id edge)
                            `((,cls-id    ,(%id vertex))
                              (,cls-class ,(class@ vertex)))))
  (values edge vertex))


(defmethod tx-change-type ((graph banshou) (edge ra) type)
  (assert-graph graph)
  (tx-change-object-slots graph
                          (class@ edge)
                          (%id edge)
                          `((edge-type ,type)))
  edge)
