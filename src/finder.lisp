;;;;;
;;;;; Contents
;;;;;   none....
;;;;;

(in-package :shinrabanshou)


(defmethod get-r ((pool banshou) (edge-class-symbol symbol)
                  start
                  (start-vertex vertex) (end-vertex vertex) rtype)
  (first
   (remove-if #'(lambda (r)
                  (let ((vertex (getf r :vertex))
                        (edge   (getf r :edge)))
                    (not (and (= (get-id end-vertex)
                                 (get-id vertex))
                              (eq rtype (edge-type edge))))))
              (find-r pool edge-class-symbol start start-vertex))))


(defmethod get-r-edge ((pool banshou) (edge-class-symbol symbol)
                       start
                       (start-vertex vertex) (end-vertex vertex) rtype)
  (let ((r (get-r pool edge-class-symbol start start-vertex end-vertex rtype)))
    (when r (getf r :edge))))


(defmethod get-r-vertex ((pool banshou) (edge-class-symbol symbol)
                         start
                         (start-vertex vertex) (end-vertex vertex) rtype)
  (let ((r (get-r pool edge-class-symbol start start-vertex end-vertex rtype)))
    (when r (getf r :vertex))))


(defmethod find-r-edge ((pool banshou) (edge-class-symbol symbol) start (vertex vertex))
  (let ((start-slot (cond ((eq start :from) 'from-id)
                          ((eq start :to  ) 'to-id))))
    (find-object-with-slot pool edge-class-symbol
                           start-slot (get-id vertex))))

(defmethod find-r ((pool banshou) (edge-class-symbol symbol) start (vertex vertex))
  (let ((start-symbol (cond ((eq start :from) '(to-class   to-id))
                            ((eq start :to  ) '(from-class from-id)))))
    (mapcar #'(lambda (edge)
                (list :edge edge
                      :vertex (find-object-with-id pool
                                                   (funcall (first  start-symbol) edge)
                                                   (funcall (second start-symbol) edge))))
            (find-r-edge pool edge-class-symbol start vertex))))


(defmethod find-r-vertex ((pool banshou) (edge-class-symbol symbol) start (vertex vertex))
  (mapcar #'(lambda (data)
              (getf data :vertex))
          (find-r pool edge-class-symbol start vertex)))




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#
