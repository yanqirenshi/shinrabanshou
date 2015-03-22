;;;;;
;;;;; Contents
;;;;;   none....
;;;;;

(in-package :shinrabanshou)


(defmethod get-r ((graph banshou) (edge-class-symbol symbol)
                  start
                  (start-vertex shin) (end-vertex shin) rtype)
  (first
   (remove-if #'(lambda (r)
                  (let ((vertex (getf r :vertex))
                        (edge   (getf r :edge)))
                    (not (and (= (id end-vertex)
                                 (id vertex))
                              (eq rtype (edge-type edge))))))
              (find-r graph edge-class-symbol start start-vertex))))


(defmethod get-r-edge ((graph banshou) (edge-class-symbol symbol)
                       start
                       (start-vertex shin) (end-vertex shin) rtype)
  (let ((r (get-r graph edge-class-symbol start start-vertex end-vertex rtype)))
    (when r (getf r :edge))))


(defmethod get-r-vertex ((graph banshou) (edge-class-symbol symbol)
                         start
                         (start-vertex shin) (end-vertex shin) rtype)
  (let ((r (get-r graph edge-class-symbol start start-vertex end-vertex rtype)))
    (when r (getf r :vertex))))


(defmethod find-r-edge ((graph banshou) (edge-class-symbol symbol) start (vertex shin))
  (let ((start-slot (cond ((eq start :from) 'from-id)
                          ((eq start :to  ) 'to-id))))
    (find-object-with-slot graph edge-class-symbol
                           start-slot (id vertex))))

(defmethod find-r ((graph banshou) (edge-class-symbol symbol) start (vertex shin))
  (let ((start-symbol (cond ((eq start :from) '(to-class   to-id))
                            ((eq start :to  ) '(from-class from-id)))))
    (mapcar #'(lambda (edge)
                (list :edge edge
                      :vertex (find-object-with-id graph
                                                   (funcall (first  start-symbol) edge)
                                                   (funcall (second start-symbol) edge))))
            (find-r-edge graph edge-class-symbol start vertex))))


(defmethod find-r-vertex ((graph banshou) (edge-class-symbol symbol) start (vertex shin))
  (mapcar #'(lambda (data)
              (getf data :vertex))
          (find-r graph edge-class-symbol start vertex)))




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#
