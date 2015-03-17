;;;;;
;;;;; Contents
;;;;;   none....
;;;;;

(in-package :shinrabanshou)


(defmethod get-r ((pool banshou) (edge-class-symbol symbol)
                  start
                  (start-node vertex) (end-node vertex) rtype)
  (first
   (remove-if #'(lambda (r)
                  (let ((node (getf r :node))
                        (edge (getf r :edge)))
                    (not (and (= (get-id end-node)
                                 (get-id node))
                              (eq rtype (get-edge-type edge))))))
              (find-r pool edge-class-symbol start start-node))))


(defmethod get-r-edge ((pool banshou) (edge-class-symbol symbol)
                       start
                       (start-node vertex) (end-node vertex) rtype)
  (let ((r (get-r pool edge-class-symbol start start-node end-node rtype)))
    (when r (getf r :edge))))


(defmethod get-r-node ((pool banshou) (edge-class-symbol symbol)
                       start
                       (start-node vertex) (end-node vertex) rtype)
  (let ((r (get-r pool edge-class-symbol start start-node end-node rtype)))
    (when r (getf r :node))))


(defmethod find-r-edge ((pool banshou) (edge-class-symbol symbol) start (node vertex))
  (let ((start-slot (cond ((eq start :from) 'from)
                          ((eq start :to  ) 'to))))
    (find-object-with-slot pool edge-class-symbol
                           start-slot (get-id node))))

(defmethod find-r ((pool banshou) (edge-class-symbol symbol) start (node vertex))
  (let ((start-symbol (cond ((eq start :from) '(get-to-node-class   get-to-node-id))
                            ((eq start :to  ) '(get-from-node-class get-from-node-id)))))
    (mapcar #'(lambda (edge)
                (list :edge edge
                      :node (find-object-with-id pool
                                                 (funcall (first  start-symbol) edge)
                                                 (funcall (second start-symbol) edge))))
            (find-r-edge pool edge-class-symbol start node))))


(defmethod find-r-node ((pool banshou) (edge-class-symbol symbol) start (node vertex))
  (mapcar #'(lambda (data)
              (getf data :node))
          (find-r pool edge-class-symbol start node)))




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#
