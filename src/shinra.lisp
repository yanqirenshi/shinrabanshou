(in-package :shinrabanshou)


;;;
;;; node operator
;;;
(defun pairify (list)
  (when list (concatenate 'list
                          (list (subseq list 0 2))
                          (pairify (rest (rest list))))))


;;;;;
;;;;; 述語
;;;;;
;; 述語: node
(defgeneric nodep (obj) (:documentation "symbolで指定された class が node のサブクラスかどうかを返す。
でも、こんなんでエエんじゃろうか。。。。
ほかにスマートな方法がありそうなんじゃけど。。。"))
(defmethod nodep (obj) nil)
(defmethod nodep ((node node)) t)
(defmethod nodep ((class-symbol symbol))
  (handler-case
      (nodep (make-instance class-symbol))
    (error () nil)))


;; 述語: edge
(defgeneric edgep (obj) (:documentation "symbolで指定された class が edge のサブクラスかどうかを返す。
でも、こんなんでエエんじゃろうか。。。。
ほかにスマートな方法がありそうなんじゃけど。。。"))
(defmethod edgep (obj) nil)
(defmethod edgep ((edge edge)) t)
(defmethod edgep ((class-symbol symbol))
  (handler-case
      (edgep (make-instance class-symbol))
    (error () nil)))




;;; なんかこれで出来るんわ確認したんじゃけど、いまいち使い方がわかっちょらんのよね。
;;; index-on とか使わんとイケんのんかねぇ。
;;;
;;; これで作ると、find-object-with-id で取得出来るね。
;;; でも、class を指定せんといけんけぇ、それはそれで不便じゃねぇ。
;;; あ、っとこの前に tx-create-id-counter しとかんとイケんかったけぇ。覚えときんさいよ。
;;;
;;; なんか 余分な関数が多いね。整理する必要がある思うんじゃけど。
;;; shinra はあくまで基礎部分じゃけぇ、これ自身で使えんでもエエんよね。
;;; 汎用的な Graph Database じゃなくて、Common Lisp 上で拡張しながら利用する Graph Database なんよ。
;;; まぁ、考えならがらかいとるけぇ、明日には別のこと言うとるかもしれんのんじゃけどね。
;;;
(defgeneric find-node (banshou slot value)
  (:documentation ""))
(defmethod find-node ((system banshou) slot value)
  (find-object-with-slot system 'node slot value))



(defgeneric delete-node ( banshou node)
  (:documentation ""))
(defmethod delete-node ((system banshou) (node node))
  (execute-transaction
   (tx-delete-object system 'node (get-id node))))



(defgeneric get-at-id (banshou id)
  (:documentation ""))
(defmethod get-at-id ((system banshou) id)
  (car
   (remove nil
           ;; TODO: ここでは node edge の二つしか調べとらんけど、node edge の二つのサブクラスも含めて調べんといけんねぇ。
           ;; TODO: make-node, make-edge んときに クラスをどっかに保持しとこぉか。
           (list (find-object-with-id system 'node id)
                 (find-object-with-id system 'edge id)))))


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


;;;;;
;;;;; edge @ class
;;;;;
;; 作る。
(defgeneric make-edge (banshou class-symbol from to type &rest slots)
  (:documentation ""))
(defmethod make-edge ((system banshou) (class-symbol symbol) (from node) (to node) type &rest slots)
  (cond ((null (get-id from)) (error "この node(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null (get-id to))   (error "この node(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null type)          (error "type が空っちゅうのはイケんよ。なんか適当でエエけぇ決めんさいや。")))
  (unless (edgep class-symbol)
    (error "このクラスは edge のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a" class-symbol))
  (make-shinra system class-symbol
               (pairify (concatenate 'list
                                     slots
                                     (list 'from (get-id from))
                                     (list 'to   (get-id to))
                                     (list 'type type)))))


;; operator
(defgeneric get-from-node (banshou edge) (:documentation ""))
(defmethod get-from-node ((system banshou) (edge edge))
  (get-at-id system (get-from-node-id edge)))


(defgeneric get-to-node (banshou edge) (:documentation ""))
(defmethod get-to-node ((system banshou) (edge edge))
  (get-at-id system (get-to-node-id edge)))
