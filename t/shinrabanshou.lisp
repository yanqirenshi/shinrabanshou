#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

(in-package :cl-user)
(defpackage shinrabanshou-test
  (:use :cl
        :cl-prevalence
        :shinrabanshou
        :fiveam)
  (:nicknames :shinra-test))

(in-package :shinrabanshou-test)

(def-suite test-shinrabanshou) ;; :in shinrabanshou-test

(in-suite test-shinrabanshou)

(defvar *sys*      nil)
(defvar *sys-stor* nil "TODO: ディレクトリは自動判断したいね。")
(defvar *node1*    nil)
(defvar *node2*    nil)
(defvar *node3*    nil)
(defvar *edge1*    nil)
(defvar *edge2*    nil)

(defun clean-data-sotr (data-stor)
  (when (probe-file data-stor)
    (dolist (pathname (directory (merge-pathnames "*.xml" data-stor)))
      (delete-file pathname))))

(defclass test-node (node)
  ((code  :accessor get-code  :initform nil :initarg :code)
   (title :accessor get-title :initform nil :initarg :title)))

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
    (setf *edge2* (make-edge *sys* 'edge *node1* *node3* :TEST))))





(test cl-prevalence::slot-index-xxx-add
  ""
  (let* ((sys *sys*)
         (index       (get-root-object sys :EDGE-FROM-INDEX))
         (index-inner (gethash (get-id *node1*) index)))
    ;; 普通にインデックスが出来ているか。
    (is (hash-table-p index))
    (is (hash-table-p index-inner))
    ;; index-inner は 複数出来ているはずなので、その件数を確認する。ここでは2件の予定
    (is (= (hash-table-count index-inner) 2))
    (is (equalp (alexandria:hash-table-keys index-inner)
                (list (get-id *edge2*) (get-id *edge1*))))
    (is (eq (get-id *edge1*)
            (gethash (get-id *edge1*) index-inner)))
    (is (eq (get-id *edge2*)
            (gethash (get-id *edge2*) index-inner)))
    ;; 実際に取得してみる。
    (let ((edges (find-object-with-slot *sys* 'edge 'from (get-id *node1*))))
      (is (eq 2 (length edges))))

    ;;; indexが作成されている場合
    ;; 検索結果: 0件/10件
    ;; 検索結果: 1件/10件
    ;; 検索結果: 2件/10件

    ;;; indexが作成されていない場合
    ;; 検索結果: 0件/10件
    ;; 検索結果: 1件/10件
    ;; 検索結果: 2件/10件
    ))

;;(run!)
