(in-package :shinrabanshou)


;;;;;
;;;;; system
;;;;;
(defvar *datastore* #P"/home/atman/appl/shinra/")
(defvar *banshou* nil)

(defun start ()
  (setf *banshou*
        (make-prevalence-system *datastore* :prevalence-system-class 'banshou)))


;;;;;
;;;;; operator
;;;;;
(defun system-init (system)
  (when system
    (setf (get-root-object system :nodes) (make-hash-table))
    (setf (get-root-object system :edges) (make-hash-table))
    (setf (get-root-object system :node-id-counter) 0)
    (setf (get-root-object system :edge-id-counter) 0)
    system))

(defgeneric property-set (shinra key val) (:documentation ""))
(defmethod property-set ((obj shinra) key val)
  (setf (gethash key (property obj)) val))

(defgeneric properties-set (shinra properties) (:documentation ""))
(defmethod properties-set ((obj shinra) properties)
  (mapcar #'(lambda (x)
              (property-set obj (car x) (cdr x)))
          properties)
  obj)

(defgeneric property-get (shinra key) (:documentation ""))
(defmethod property-get ((obj shinra) key)
  (gethash key (property obj)))


;;;
;;; node operator
;;;

(defun pairify (list)
  (when list (concatenate 'list
                          (list (subseq list 0 2))
                          (pairify (rest (rest list))))))


;;; なんかこれで出来るんわ確認したんじゃけど、いまいち使い方がわかっちょらんのよね。
;;; index-on とか使わんとイケんのんかねぇ。
;;;
;;; これで作ると、find-object-with-id で取得出来るね。
;;; でも、class を指定せんといけんけぇ、それはそれで不便じゃねぇ。
;;; あ、っとこの前に tx-create-id-counter しとかんとイケんかったけぇ。覚えときんさいよ。
;;;
(defgeneric make-shinra (banshou class-symbol slots-and-values) (:documentation ""))
(defgeneric find-node (banshou slot value) (:documentation ""))
(defgeneric delete-node ( banshou node) (:documentation ""))
(defgeneric get-at-id (banshou id) (:documentation ""))
(defgeneric make-node (banshou &rest slots) (:documentation ""))
(defgeneric make-edge (banshou from to type &rest slots) (:documentation ""))
(defgeneric get-from-node (banshou edge) (:documentation ""))
(defgeneric get-to-node (banshou edge) (:documentation ""))


(defmethod make-shinra ((banshou banshou) class-symbol slots-and-values)
  (execute-transaction
   (tx-create-object banshou class-symbol slots-and-values)))


(defmethod find-node ((system banshou) slot value)
  (find-object-with-slot system 'node slot value))


(defmethod delete-node ((system banshou) (node node))
  (execute-transaction
   (tx-delete-object system 'node (get-id node))))


(defmethod get-at-id ((system banshou) id)
  (car
   (remove nil
           (list (find-object-with-id system 'node id)
                 (find-object-with-id system 'edge id)))))


(defmethod make-node ((system banshou) &rest slots)
  (make-shinra system 'node (pairify slots)))


(defmethod make-edge ((system banshou) (from node) (to node) type &rest slots)
  (cond ((null (get-id from)) (error "この node(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null (get-id to))   (error "この node(from)、id 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。"))
        ((null type)          (error "type が空っちゅうのはイケんよ。なんか適当でエエけぇ決めんさいや。")))
  (make-shinra system 'edge
               (pairify (concatenate 'list
                                     slots
                                     (list 'from (get-id from))
                                     (list 'to   (get-id to))
                                     (list 'type type)))))


(defmethod get-from-node ((system banshou) (edge edge))
  (get-at-id system (get-from-node-id edge)))


(defmethod get-to-node ((system banshou) (edge edge))
  (get-at-id system (get-to-node-id edge)))
