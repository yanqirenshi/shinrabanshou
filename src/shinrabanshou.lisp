(in-package :shinrabanshou)


;;;;;
;;;;; system
;;;;;
(defvar *datastore* #P"/home/atman/appl/shinra/")
(defvar *system* nil)

(defun start ()
  (make-prevalence-system *datastore* :prevalence-system-class 'banshou))


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
(defun make-node (&key (properties nil))
  (properties-set (make-instance 'node) properties))

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
