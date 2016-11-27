(in-package :cl-user)

(defpackage shinrabanshou.conditions
  (:use :cl)
  (:nicknames :shinra.conditions)
  (:export #:graph-error))

(in-package :shinrabanshou.conditions)

(define-condition graph-error (error)
  ((graph :initarg :graph :reader grap)))

(defun graph-error (graph)
  (error 'graph-error :graph graph))
