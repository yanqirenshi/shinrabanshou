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

;; とりあえず万象を作成。
;; TODO: ディレクトリは自動判断したいね。
;; TODO: ディレクトリのファイルは事前に全部削除する。
;; (defvar *sys-stor* "/home/atman/prj/shinrabanshou/t/data")
;; (defvar *sys* (make-banshou 'banshou *sys-stor*))


;; (defclass test-node (node)
;;   ((code :accessor get-code :initform nil :initarg :code)
;;    (name :accessor get-name :initform nil :initarg :name)))

;; (defvar *node1* (make-node *sys* 'test-node))
;; (defvar *node2* (make-node *sys* 'test-node))
;; (defvar *node3* (make-node *sys* 'test-node))

;; (defvar *edge1* (make-edge *sys* 'edge *node1* *node2* :TEST))
;; (defvar *edge2* (make-edge *sys* 'edge *node1* *node3* :TEST))

;; (test cl-prevalence::slot-index-xxx-add
;;   ""
;;   (let* ((sys *sys*)
;;       (index (cl-prevalence:get-root-object sys :EDGE-FROM-INDEX))
;;       (index-inner (gethash (cl-prevalence:get-id *node1*) index)))
;;     (is (hash-table-p index))
;;     (is (hash-table-p index-inner))
;;     (is (= (hash-table-count index-inner) 2))
;;     (is (equalp (alexandria:hash-table-keys index-inner)
;;              (list (cl-prevalence:get-id *edge2*)
;;                    (cl-prevalence:get-id *edge1*))))
;;     (is (eq *edge1* (gethash (cl-prevalence:get-id *edge1*) index-inner)))
;;     (is (eq *edge2* (gethash (cl-prevalence:get-id *edge2*) index-inner)))

;;     ))

;; (run!)
