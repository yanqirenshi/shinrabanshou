;;;;;
;;;;; Contents
;;;;;    1. 述語
;;;;;    2. 取得
;;;;;    3. 作成
;;;;;    4. 削除
;;;;;

(in-package :shinrabanshou)


;;;;;
;;;;; 1. 述語
;;;;;
(defmethod vertexp (obj) (declare (ignore obj)) nil)
(defmethod vertexp ((vertex shin)) t)
(defmethod vertexp ((class-symbol symbol))
  (handler-case
      (vertexp (make-instance class-symbol))
    (error () nil)))


(defmethod existp ((graph banshou) (vertex shin))
  (assert-graph graph)
  (not (null (get-object-at-%id graph (class-name (class-of vertex)) (%id vertex)))))


(defun existp-relationship (graph shin &optional (ra-list nil))
  (assert-graph graph)
  (when (null ra-list)
    (setf ra-list (get-ra-classes graph)))
  (labels ((core (graph shin ra-list)
             (when ra-list
               (let ((ra (car ra-list))
                     (id (%id shin)))
                 (if (or (gethash id (get-root-object graph (up::get-objects-slot-index-name ra 'from-id)))
                         (gethash id (get-root-object graph (up::get-objects-slot-index-name ra 'to-id))))
                     t
                     (core graph shin (cdr ra-list)))))))
    (core graph shin ra-list)))

;;;;;
;;;;; 3. 取得
;;;;;
(defmethod find-vertex ((graph banshou) (class-symbol symbol) &key slot value)
  (assert-graph graph)
  (up:find-objects graph class-symbol
                   :slot slot
                   :value value))

(defmethod get-vertex-at ((graph banshou) (class-symbol symbol)
                          &key %id)
  (assert-graph graph)
  (cond (%id (up:get-object-at-%id graph class-symbol %id))
        (t nil)))


;;;;;
;;;;; 4. 作成
;;;;;
(defmethod tx-make-vertex ((graph banshou) (class-symbol symbol) &optional slots-and-values)
  (assert-graph graph)
  (unless (vertexp class-symbol)
    (error* :bad-class 'shin class-symbol))
  (add-shin-class graph class-symbol)
  (tx-create-object graph class-symbol slots-and-values))

(defmethod make-vertex ((graph banshou) (class-symbol symbol) &optional slots-and-values)
  (execute-transaction
   (tx-make-vertex graph class-symbol slots-and-values)))


;;;;;
;;;;; 5. 削除
;;;;;
(defmethod tx-delete-vertex ((graph banshou) (vertex shin))
  (assert-graph graph)
  ;; 現在関係があるものは削除できないようにしています。
  (let ((vertex-class (class-name (class-of vertex))))
    (when (existp-relationship graph vertex)
      (error* :delete-failed-have-some-edge vertex-class))
    (tx-delete-object graph vertex-class (%id vertex))))

(defmethod delete-vertex ((graph banshou) (vertex shin))
  (execute-transaction
   (tx-delete-vertex graph vertex)))
