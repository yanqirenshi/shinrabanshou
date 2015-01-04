(in-package :shinrabanshou)

#|

|#

(defgeneric get-r (pool edge-class-symbol start start-node end-node rtype)
  (:documentation "")
  (:method ((pool banshou) (edge-class-symbol symbol)
            start
            (start-node node) (end-node node) rtype)
    (first
     (remove-if #'(lambda (r)
                    (let ((node (getf r :node))
                          (edge (getf r :edge)))
                      (not (and (= (get-id end-node)
                                   (get-id node))
                                (eq rtype (get-edge-type edge))))))
                (find-r pool edge-class-symbol start start-node)))))


(defgeneric get-r-edge (pool edge-class-symbol start start-node end-node rtype)
  (:method ((pool banshou) (edge-class-symbol symbol)
            start
            (start-node node) (end-node node) rtype)
    (let ((r (get-r pool edge-class-symbol start start-node end-node rtype)))
      (when r (getf r :edge)))))


(defgeneric get-r-node (pool edge-class-symbol start start-node end-node rtype)
  (:method ((pool banshou) (edge-class-symbol symbol)
            start
            (start-node node) (end-node node) rtype)
    (let ((r (get-r pool edge-class-symbol start start-node end-node rtype)))
      (when r (getf r :node)))))


(defgeneric find-r-edge (pool edge-class-symbol start node)
  (:documentation "")
  (:method ((pool banshou) (edge-class-symbol symbol) start (node node))
    (let ((start-slot (cond ((eq start :from) 'from)
                            ((eq start :to  ) 'to))))
      (find-object-with-slot pool edge-class-symbol
                             start-slot (get-id node)))))

(defgeneric find-r (pool edge-class-symbol start node)
  (:documentation "")
  (:method ((pool banshou) (edge-class-symbol symbol) start (node node))
    (let ((start-symbol (cond ((eq start :from) '(get-to-node-class   get-to-node-id))
                              ((eq start :to  ) '(get-from-node-class get-from-node-id)))))
      (mapcar #'(lambda (edge)
                  (list :edge edge
                        :node (find-object-with-id pool
                                                   (funcall (first  start-symbol) edge)
                                                   (funcall (second start-symbol) edge))))
              (find-r-edge pool edge-class-symbol start node)))))


(defgeneric find-r-node (pool edge-class-symbol start node)
  (:documentation "")
  (:method ((pool banshou) (edge-class-symbol symbol) start (node node))
    (mapcar #'(lambda (data)
                (getf data :node))
            (find-r pool edge-class-symbol start node))))
