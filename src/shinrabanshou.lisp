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
(defun make-shinra (system class-symbol slots-and-values)
  (execute-transaction
   (tx-create-object system class-symbol slots-and-values)))


(defun find-node (system slot value)
  (find-object-with-slot system 'node slot value))


(defun delete-node (system node)
  (execute-transaction
   (tx-delete-object system 'node (get-id node))))


(defun get-at-id (system id)
  (car
   (remove nil
           (list (find-object-with-id system 'node id)
                 (find-object-with-id system 'edge id)))))


(defun make-node (system &rest slots)
  (make-shinra system 'node (pairify slots)))


(defun make-edge (system &rest slots)
  (make-shinra system 'edge (pairify slots)))

