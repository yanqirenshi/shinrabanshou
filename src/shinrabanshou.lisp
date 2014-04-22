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

(defmethod property-set ((obj shinra) key val)
  (setf (gethash key (property obj)) val))

(defmethod properties-set ((obj shinra) properties)
  (mapcar #'(lambda (x)
              (property-set obj (car x) (cdr x)))
          properties)
  obj)

(defmethod property-get ((obj shinra) key)
  (gethash key (property obj)))


;; ex) (make-node :properties '((:id . 1) (:name . "hanage")))
;; (defun make-node (&key (properties nil))
;;   (properties-set (make-instance 'node) properties))

(defmethod get-node ((system banshou) id)
  (gethash id (get-root-object *system* :nodes)))

(defmethod add-node ((system banshou) (node node))
  (let ((newid (incf (get-root-object system :node-id-counter))))
    (setf (id node) newid)
    (setf (gethash newid (get-root-object system :nodes))
          node))
  (values system node))

(defmethod add-edge ((system banshou) (from node) (to node))
  (let ((newid (incf (get-root-object system :edge-id-counter)))
        (edge  (make-instance 'edge :node-id-from (id from) :node-id-to (id to))))
    (setf (id edge) newid)
    (setf (gethash newid (get-root-object system :edges))
          edge)
    (values system edge)))

(defmethod add-edge ((system banshou) (from-id number) (to-id number))
  (let ((from (get-node system from-id))
        (to   (get-node system to-id)))
    (unless from (error "from が存在しないよ。id=~a" from-id))
    (unless to   (error "to が存在しないよ。id=~a"   to-id))
    (add-edge system from to)))




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
(defun make-node (system &rest slots)
  (let ((slots-and-values (pairify slots)))
    (execute-transaction
     (tx-create-object system 'node slots-and-values))))

(defun find-node (system slot value)
  (find-object-with-slot system 'node slot value))

(defun delete-node (system node)
  (execute-transaction
   (tx-delete-object system 'node (get-id node))))


(defun make-edge (system &rest slots)
  (let ((slots-and-values (pairify slots)))
    (execute-transaction
     (tx-create-object system 'edge slots-and-values))))

