;;;;;
;;;;; Contents
;;;;;   1. 述語
;;;;;   2. 削除
;;;;;   3. 作成
;;;;;   4. Accsessor
;;;;;   5. 整理中
;;;;;

(in-package :shinrabanshou)


;;;;;
;;;;; 1. 述語
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
       (and (=  (get-from-vertex-id edge)    (get-from-vertex-id exist))
            (=  (get-to-vertex-id edge)      (get-to-vertex-id exist))
            (eq (get-from-vertex-class edge) (get-from-vertex-class exist))
            (eq (get-to-vertex-class edge)   (get-to-vertex-class exist))
            (eq (get-edge-type edge)       (get-edge-type exist)))
       t
       (error "id(~a) はおおとるんじゃけど、なんか内容が一致せんけぇ。おかしいじゃろう。 "
              (get-id edge))))))


;;;;;
;;;;; 2. 削除
;;;;;
(defmethod tx-delete-edge ((pool banshou) (edge edge))
  ;; remove edge on index
  (mapcar #'(lambda (slot)
              (up:tx-remove-object-on-slot-index pool edge slot))
          '(from to type))
  ;; remove edge object
  (tx-delete-object pool (class-name (class-of edge)) (get-id edge)))



;;;;;
;;;;; 3. 作成
;;;;;
(defmethod tx-make-edge ((system banshou) (class-symbol symbol) (from vertex) (to vertex) type
                         &optional slots)
  (cond ((null (get-id from)) (error "この vertex(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null (get-id to))   (error "この vertex(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
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
                      (from vertex) (to vertex) type
                      &optional slots)
  (execute-transaction (tx-make-edge pool class-symbol from to type slots)))



;;;;;
;;;;; 4. Accsessor
;;;;;
(defmethod get-from-vertex ((system banshou) (edge edge))
  (up:get-at-id system (get-from-vertex-id edge)))


(defmethod get-to-vertex ((system banshou) (edge edge))
  (up:get-at-id system (get-to-vertex-id edge)))


(defun tx-change-from-vertex (pool edge vertex)
  (let ((class (class-name (class-of vertex)))
        (id    (get-id vertex)))
    (tx-change-object-slots pool
                            class
                            (get-id edge)
                            `((from ,id)
                              (from-class ,class)))))



;;;;;
;;;;; 5. 整理中
;;;;;
;;; これは。。。TODO:整理が必要じゃね。
(defun class-symbol (obj)
  (class-name (class-of obj)))
(defun class@ (obj)
  (class-name (class-of obj)))

(defun get-edge-vertex-slot (type)
  (cond ((eq :from type)
         (values 'from 'from-class))
        ((eq :to type)
         (values 'to 'to-class))
        (t (error "こんとなん知らんけぇ。type=~a" type))))


(defmethod tx-change-vertex ((pool banshou) (edge edge) type (vertex vertex))
  (multiple-value-bind (cls-id cls-class)
      (get-edge-vertex-slot type)
    (tx-change-object-slots pool
                            (class@ edge)
                            (get-id edge)
                            `((,cls-id    ,(get-id vertex))
                              (,cls-class ,(class@ vertex)))))
  (values edge vertex))


(defmethod tx-change-type ((pool banshou) (edge edge) type)
  (tx-change-object-slots pool
                          (class@ edge)
                          (get-id edge)
                          `((type ,type)))
  edge)




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#

