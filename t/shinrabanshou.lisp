#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

(in-package :cl-user)
(defpackage shinrabanshou-test
  (:use :cl
        ;;:cl-prevalence
        :shinrabanshou
        :fiveam)
  (:nicknames :shinra-test))

(in-package :shinrabanshou-test)

(def-suite test-shinrabanshou) ;; :in shinrabanshou-test

(in-suite test-shinrabanshou)

(defvar *sys*      nil)
(defvar *sys-stor* nil)
(defvar *node1* nil)
(defvar *node2* nil)
(defvar *node3* nil)
(defvar *edge1* nil)
(defvar *edge2* nil)

;; TODO: ディレクトリは自動判断したいね。
;; (setf *sys-stor* "/home/atman/prj/shinrabanshou/t/data/")
;; (setf *sys-stor* "/Users/yanqirenshi/prj/shinrabanshou/t/data/")

(defun clean-data-sotr (data-stor)
  (when (probe-file data-stor)
    (dolist (pathname (directory (merge-pathnames "*.xml" data-stor)))
      (delete-file pathname))))

(test test-managed-prevalence-start
  (progn
    ;; こりゃなんで？
    (unless *sys-stor* (error "*sys-stor*がnilのままです。"))
    ;; delete file
    (clean-data-sotr *sys-stor*)
    ;; create system
    (setf *sys* (make-banshou 'banshou *sys-stor*))
    (is-true *sys*)
    ;; preset data
    (setf *node1* (make-node *sys* 'test-node))
    (setf *node2* (make-node *sys* 'test-node))
    (setf *node3* (make-node *sys* 'test-node))
    (setf *edge1* (make-edge *sys* 'edge *node1* *node2* :TEST))
    (setf *edge2* (make-edge *sys* 'edge *node1* *node3* :TEST))
    ))



(defclass test-node (node)
  ((code :accessor get-code :initform nil :initarg :code)
   (name :accessor get-name :initform nil :initarg :name)))



(test cl-prevalence::slot-index-xxx-add
  ""
  (let* ((sys *sys*)
         (index (cl-prevalence:get-root-object sys :EDGE-FROM-INDEX))
         (index-inner (gethash (cl-prevalence:get-id *node1*) index)))
    (is (hash-table-p index))
    (is (hash-table-p index-inner))
    (is (= (hash-table-count index-inner) 2))
    (is (equalp (alexandria:hash-table-keys index-inner)
                (list (cl-prevalence:get-id *edge2*)
                      (cl-prevalence:get-id *edge1*))))
    (is (eq *edge1* (gethash (cl-prevalence:get-id *edge1*) index-inner)))
    (is (eq *edge2* (gethash (cl-prevalence:get-id *edge2*) index-inner)))

    ))

;;(run!)
