#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

(in-package :cl-user)
(defpackage shinrabanshou-test
  (:use :cl
        :shinrabanshou
        :fiveam))
(in-package :shinrabanshou-test)

;;(plan nil)

;; blah blah blah.

;;(finalize)

(defclass test-node (node)
  ((code :accessor get-code :initform nil :initarg :code)
   (name :accessor get-name :initform nil :initarg :name)))

(test cl-prevalence::slot-index-xxx-add
  ""
  (let ((node1  (make-instance 'test-node :id 1))
        (node2  (make-instance 'test-node :id 2))
        (node3  (make-instance 'test-node :id 3))
        (edge1  (make-instance 'edge      :id 4))
        (edge2  (make-instance 'edge      :id 5))
        (index-from  (make-hash-table :test 'equalp)))
    (list node1 node2 node3 edge1 edge2 index)
    ;; make-banshou. includeing index-on edge-from edge-to.
    ;; make-node node1 node2 node3
    ;; make-edge edge1 edge2
    ))
