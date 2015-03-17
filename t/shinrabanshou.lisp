(in-package :cl-user)
(defpackage shinrabanshou-test
  (:use :cl
        :upanishad
        :shinrabanshou
        :prove)
  (:nicknames :shinra-test))

;;;;;
;;;;; Contents
;;;;;   1. Variable
;;;;;   2. Class
;;;;;   3. Plan
;;;;;       Plan 1 : Basic
;;;;;       Plan 2 : Predicates
;;;;;       Plan 3 : Find-r-xxx
;;;;;       Plan 4 : Slot-index
;;;;;       Plan 5 : remove-object-on-slot-index
;;;;;       Plan 6 : delete-edge
;;;;;       Plan 7 : tx-change-node
;;;;;       Plan 8 : tx-change-type
;;;;;

(in-package :shinrabanshou-test)

;;;;;
;;;;; 1. Variable
;;;;;
(defvar *pool*      nil)
(defvar *pool-stor* (concatenate 'string
                                 (namestring (user-homedir-pathname))
                                 "tmp/shinra/")
  "TODO: ディレクトリがなかったら作ろうか。。。。")

(defun clean-data-sotr (data-stor)
  (when (probe-file data-stor)
    (dolist (pathname (directory (merge-pathnames "*.xml" data-stor)))
      (delete-file pathname))))


;;;;;
;;;;; 2. Class
;;;;;
(defclass test-node (vertex)
  ((note :documentation ""
         :accessor get-note
         :initarg :note
         :initform nil)))

;;;;;
;;;;; 3. Plan
;;;;;
;;;
;;; Plan 1 : Basic
;;;
(plan 1)
(let ((node-note-1 "n-note-1")
      (node-note-2 "n-note-2")
      (node-note-3 "n-note-3")
      (edge-type   :test-r)
      (pool-stor *pool-stor*)
      (pool nil))
  ;; こりゃなんで？
  (unless pool-stor (error "*pool-stor*がnilのままです。"))
  ;; delete file
  (clean-data-sotr pool-stor)
  ;; create system
  (setf pool (make-banshou 'banshou pool-stor))
  (ok pool)
  (let* ((node1 (tx-make-node pool 'test-node `((note ,node-note-1))))
         (node2 (tx-make-node pool 'test-node `((note ,node-note-2))))
         (node3 (tx-make-node pool 'test-node `((note ,node-note-3))))
         (edge1 (tx-make-edge pool 'edge node1 node2 edge-type))
         (edge2 (tx-make-edge pool 'edge node1 node3 edge-type)))
       ;;; check node
    (is node1 (find-object-with-id pool 'test-node (get-id node1)))
    (is node2 (find-object-with-id pool 'test-node (get-id node2)))
    (ok (find-object-with-slot pool 'test-node 'note node-note-1))
    (ok (find-object-with-slot pool 'test-node 'note node-note-2))
       ;;; check edge
    (is 2 (length (get-root-object pool :EDGE-ROOT)))
    (is 2 (length (find-object-with-slot pool 'edge 'shinra::type :test-r)))
    (is 2 (length (find-object-with-slot pool 'edge 'shinra::from (get-id node1))))
    (is edge1 (find-object-with-id pool 'edge (get-id edge1)))
    (is edge2 (find-object-with-id pool 'edge (get-id edge2)))
    ;;
    (let ((tmp-edge-1 (find-object-with-id pool 'edge (get-id edge1)))
          (tmp-edge-2 (find-object-with-id pool 'edge (get-id edge2))))
      ;; check id. from and to node.
      (is (get-id node1) (get-from-node-id tmp-edge-1))
      (is (get-id node2) (get-to-node-id   tmp-edge-1))
      (is (get-id node1) (get-from-node-id tmp-edge-2))
      (is (get-id node3) (get-to-node-id   tmp-edge-2))
      ;; check class. from and to node.
      (is (class-name (class-of node1))
          (get-from-node-class tmp-edge-1))
      (is (class-name (class-of node2))
          (get-to-node-class tmp-edge-1))
      (is (class-name (class-of node1))
          (get-from-node-class tmp-edge-2))
      (is (class-name (class-of node3))
          (get-to-node-class tmp-edge-2))
      (is node1 (find-object-with-id pool (get-from-node-class tmp-edge-1) (get-id node1)))
      (is node2 (find-object-with-id pool (get-to-node-class tmp-edge-1)   (get-id node2)))
      (is node1 (find-object-with-id pool (get-from-node-class tmp-edge-2) (get-id node1)))
      (is node3 (find-object-with-id pool (get-to-node-class tmp-edge-2)   (get-id node3)))
      )
       ;;;
       ;;;
    (up:snapshot pool)
    (clean-data-sotr pool-stor)))



;;;
;;; Plan 2 : Predicates
;;;
(plan 2)
(let ((node-note-1 "n-note-1")
      (node-note-2 "n-note-2")
      (edge-type   :test-r)
      (pool-stor *pool-stor*)
      (pool nil))
  ;; こりゃなんで？
  (unless pool-stor (error "*pool-stor*がnilのままです。"))
  ;; delete file
  (clean-data-sotr pool-stor)
  ;; create system
  (setf pool (make-banshou 'banshou pool-stor))
  (ok pool)
  ;; object を生成
  (let* ((node1 (tx-make-node pool 'test-node `((note ,node-note-1))))
         (node2 (tx-make-node pool 'test-node `((note ,node-note-2))))
         (node3 (make-instance 'vertex :id -999))
         (edge1 (tx-make-edge pool 'edge node1 node2 edge-type))
         (edge2 (tx-make-edge pool 'edge node1 node3 edge-type))
         (edge3 (make-instance 'edge :id -999)))
    ;; テスト開始
    (ok (existp pool node1))
    (ok (existp pool node2))
    (ok (not (existp pool node3)))
    (ok (existp pool edge1))
    (ok (existp pool edge2))
    (ok (not (existp pool edge3)))
    (up:snapshot pool)))



;;;
;;; Plan 3 : Find-r-xxx
;;;
(plan 3)
(let ((node-note-1 "n-note-1")
      (node-note-2 "n-note-2")
      (node-note-3 "n-note-3")
      (edge-type   :test-r)
      (pool-stor *pool-stor*)
      (pool nil))
  ;; こりゃなんで？
  (unless pool-stor (error "*pool-stor*がnilのままです。"))
  ;; delete file
  (clean-data-sotr pool-stor)
  ;; create system
  (setf pool (make-banshou 'banshou pool-stor))
  (ok pool)
  ;;
  (let* ((node1 (tx-make-node pool 'test-node `((note ,node-note-1))))
         (node2 (tx-make-node pool 'test-node `((note ,node-note-2))))
         (node3 (tx-make-node pool 'test-node `((note ,node-note-3))))
         (edge1 (tx-make-edge pool 'edge node1 node2 edge-type))
         (edge2 (tx-make-edge pool 'edge node1 node3 edge-type)))
    ;; find-r
    (is 2 (length (find-r-edge pool 'edge :from node1)))
    (is 0 (length (find-r-edge pool 'edge :to   node1)))
    (is 1 (length (find-r-edge pool 'edge :to   node2)))
    (is 1 (length (find-r-edge pool 'edge :to   node3)))
    (is 0 (length (find-r-edge pool 'edge :from node2)))
    (is 0 (length (find-r-edge pool 'edge :from node3)))
    (ok (equalp (find-r-edge pool 'edge :from node1)
                (list edge2 edge1)))
    (ok (equalp (find-r-node pool 'edge :from node1)
                (list node3 node2)))
    (ok (equalp (find-r pool 'edge :from node1)
                (list (list :edge edge2 :node node3)
                      (list :edge edge1 :node node2))))
    ;; get-r
    (let ((ret (get-r pool 'edge :from node1 node2 edge-type)))
      (is edge1 (getf ret :edge))
      (is node2 (getf ret :node)))
    (let ((ret (get-r pool 'edge :from node1 node3 edge-type)))
      (is edge2 (getf ret :edge))
      (is node3 (getf ret :node)))
    (is edge1 (get-r-edge pool 'edge :from node1 node2 edge-type))
    (is edge2 (get-r-edge pool 'edge :from node1 node3 edge-type))
    (is node2 (get-r-node pool 'edge :from node1 node2 edge-type))
    (is node3 (get-r-node pool 'edge :from node1 node3 edge-type)))
  (up:snapshot pool))




;;;
;;; Plan 4 : Slot-index
;;;
(plan 4)
(labels ((index-name (cls slot)
           (up::get-objects-slot-index-name cls slot)))
  (let ((node-note-1 "n-note-1")
        (node-note-2 "n-note-2")
        (rsc-class   'test-node)
        (node-class  'vertex)
        (edge-class  'edge)
        (edge-type   :test-r)
        (pool-stor *pool-stor*)
        (pool nil))
    ;; こりゃなんで？
    (unless pool-stor (error "*pool-stor*がnilのままです。"))
    ;; delete file
    (clean-data-sotr pool-stor)
    ;; create system
    (setf pool (make-banshou 'banshou pool-stor))
    (ok pool)
    ;; object を生成
    (let* ((node1 (tx-make-node pool rsc-class `((note ,node-note-1))))
           (node2 (tx-make-node pool rsc-class `((note ,node-note-2))))
           (node3 (make-instance  node-class :id -999))
           (edge1 (tx-make-edge pool edge-class node1 node2 edge-type))
           (edge2 (tx-make-edge pool edge-class node1 node3 edge-type))
           (edge3 (make-instance  edge-class :id -999)))
      (declare (ignore edge1 edge2 edge3))
      ;; テスト開始
      (ok (get-root-object pool (index-name edge-class 'from)))
      (ok (get-root-object pool (index-name edge-class 'to)))
      (ok (get-root-object pool (index-name edge-class 'type)))
      (up:drop-index-on pool edge-class '(from to type))
      (is nil (get-root-object pool (index-name edge-class 'from)))
      (is nil (get-root-object pool (index-name edge-class 'to)))
      (is nil (get-root-object pool (index-name edge-class 'type)))
      (up:index-on pool edge-class '(shinra::from shinra::to shinra::type))
      (ok (get-root-object pool (index-name edge-class 'from)))
      (ok (get-root-object pool (index-name edge-class 'to)))
      (ok (get-root-object pool (index-name edge-class 'type)))
      ;;
      (up:snapshot pool))))



;;;
;;; Plan 5 : remove-object-on-slot-index
;;;
(plan 5)
(labels ((index-name (cls slot)
           (up::get-objects-slot-index-name cls slot)))
  (let ((node-note-1 "n-note-1")
        (node-note-2 "n-note-2")
        (rsc-class   'test-node)
        (node-class  'vertex)
        (edge-class  'edge)
        (edge-type   :test-r)
        (pool-stor *pool-stor*)
        (pool nil))
    ;; こりゃなんで？
    (unless pool-stor (error "*pool-stor*がnilのままです。"))
    ;; delete file
    (clean-data-sotr pool-stor)
    ;; create system
    (setf pool (make-banshou 'banshou pool-stor))
    (ok pool)
    ;; object を生成
    (let* ((node1 (tx-make-node pool rsc-class `((note ,node-note-1))))
           (node2 (tx-make-node pool rsc-class `((note ,node-note-2))))
           (node3 (make-instance  node-class :id -999))
           (edge1 (tx-make-edge pool edge-class node1 node2 edge-type))
           (edge2 (tx-make-edge pool edge-class node1 node3 edge-type)))
      (declare (ignore edge2))
      ;; テスト開始
      (ok (get-root-object pool (index-name edge-class 'from)))
      (ok (get-root-object pool (index-name edge-class 'to)))
      (ok (get-root-object pool (index-name edge-class 'type)))
      (up:drop-index-on pool edge-class '(from to type))
      (is nil (get-root-object pool (index-name edge-class 'from)))
      (is nil (get-root-object pool (index-name edge-class 'to)))
      (is nil (get-root-object pool (index-name edge-class 'type)))
      (up:index-on pool edge-class '(shinra::from shinra::to shinra::type))
      (ok (get-root-object pool (index-name edge-class 'from)))
      (ok (get-root-object pool (index-name edge-class 'to)))
      (ok (get-root-object pool (index-name edge-class 'type)))
      ;;
      (let ((i-from (get-root-object pool (up::get-objects-slot-index-name edge-class 'from)))
            (i-to   (get-root-object pool (up::get-objects-slot-index-name edge-class 'to)))
            (i-type (get-root-object pool (up::get-objects-slot-index-name edge-class 'type))))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type))
        ;; from
        (is 2 (hash-table-count (gethash (get-from-node-id edge1) i-from)))
        (up:tx-remove-object-on-slot-index pool edge1 'shinra::from)
        (is 1 (hash-table-count (gethash (get-from-node-id edge1) i-from)))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type))
        ;; to
        (is 1 (hash-table-count (gethash (get-to-node-id edge1) i-to)))
        (up:tx-remove-object-on-slot-index pool edge1 'shinra::to)
        (is 0 (hash-table-count (gethash (get-to-node-id edge1) i-to)))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type))
        ;; type
        (is 2 (hash-table-count (gethash (get-edge-type edge1) i-type)))
        (up:tx-remove-object-on-slot-index pool edge1 'shinra::type)
        (is 1 (hash-table-count (gethash (get-edge-type edge1) i-type)))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type)))
      (up:snapshot pool))))


;;;
;;; Plan 6 : delete-edge
;;;
(plan 6)
(let ((node-note-1 "n-note-1")
      (node-note-2 "n-note-2")
      (rsc-class   'test-node)
      (node-class  'vertex)
      (edge-class  'edge)
      (edge-type   :test-r)
      (pool-stor *pool-stor*)
      (pool nil))
  (unless pool-stor (error "*pool-stor*がnilのままです。"))
  (clean-data-sotr pool-stor)
  (setf pool (make-banshou 'banshou pool-stor))
  (ok pool)
  ;; object を生成
  (let* ((node1 (tx-make-node pool rsc-class `((note ,node-note-1))))
         (node2 (tx-make-node pool rsc-class `((note ,node-note-2))))
         (node3 (make-instance  node-class :id -999))
         (edge1 (tx-make-edge pool edge-class node1 node2 edge-type))
         (edge2 (tx-make-edge pool edge-class node1 node3 edge-type)))
    (declare (ignore edge2))
    ;; テスト開始
    (let ((i-from (get-root-object pool (up::get-objects-slot-index-name edge-class 'from)))
          (i-to   (get-root-object pool (up::get-objects-slot-index-name edge-class 'to)))
          (i-type (get-root-object pool (up::get-objects-slot-index-name edge-class 'type))))
      (is 1 (hash-table-count i-from))
      (is 2 (hash-table-count i-to))
      (is 1 (hash-table-count i-type))
      ;; befor check
      (ok (not (null (member edge1 (find-all-objects pool edge-class)))))
      (is edge1 (get-object-with-id pool edge-class (get-id edge1)))
      (is 2 (length (find-object-with-slot pool edge-class 'shinra::from (get-from-node-id edge1))))
      (is 1 (length
             (find-object-with-slot pool edge-class 'shinra::to (get-to-node-id edge1))))
      (is 2 (length (find-object-with-slot pool edge-class 'shinra::type (get-edge-type edge1))))
      ;; do
      (shinra::tx-delete-edge pool edge1)
      ;; after check
      (is nil (not (null (member edge1 (find-all-objects pool edge-class)))))
      (is nil (eq edge1 (get-object-with-id pool edge-class (get-id edge1))))
      (is 1 (length (find-object-with-slot pool edge-class 'shinra::from (get-from-node-id edge1))))
      (is 0 (length
             (find-object-with-slot pool edge-class 'shinra::to (get-to-node-id edge1))))
      (is 1 (length (find-object-with-slot pool edge-class 'shinra::type (get-edge-type edge1))))
      ;;
      (is 1 (hash-table-count i-from))
      (is 2 (hash-table-count i-to))
      (is 1 (hash-table-count i-type))))
  (up:snapshot pool))



;;;
;;; Plan 7 : tx-change-node
;;;
(plan 7)
(let ((node-note-1 "n-note-1")
      (node-note-2 "n-note-2")
      (node-note-3 "n-note-3")
      (edge-type   :test-r)
      (pool-stor *pool-stor*)
      (pool nil))
  ;; こりゃなんで？
  (unless pool-stor (error "*pool-stor*がnilのままです。"))
  ;; delete file
  (clean-data-sotr pool-stor)
  ;; create system
  (setf pool (make-banshou 'banshou pool-stor))
  (ok pool)
  ;;
  (let* ((node1 (tx-make-node pool 'test-node `((note ,node-note-1))))
         (node2 (tx-make-node pool 'test-node `((note ,node-note-2))))
         (node3 (tx-make-node pool 'test-node `((note ,node-note-3))))
         (edge1 (tx-make-edge pool 'edge node1 node2 edge-type)))
    (is (get-id node1) (get-from-node-id edge1))
    (is (get-id node2) (get-to-node-id edge1))
    (is edge1 (tx-change-node pool edge1 :from node3))
    (is (get-id node3) (get-from-node-id edge1))
    (is (get-id node2) (get-to-node-id edge1))
    (is edge1 (tx-change-node pool edge1 :to node1))
    (is (get-id node3) (get-from-node-id edge1))
    (is (get-id node1) (get-to-node-id edge1))
    (up:snapshot pool)
    ))


;;;
;;; Plan 8 : tx-change-type
;;;
(plan 8)
(let ((node-note-1 "n-note-1")
      (node-note-2 "n-note-2")
      (edge-type-befor :test-b)
      (edge-type-after :test-a)
      (pool-stor *pool-stor*)
      (pool nil))
  ;; こりゃなんで？
  (unless pool-stor (error "*pool-stor*がnilのままです。"))
  ;; delete file
  (clean-data-sotr pool-stor)
  ;; create system
  (setf pool (make-banshou 'banshou pool-stor))
  (ok pool)
  ;;
  (let* ((node1 (tx-make-node pool 'test-node `((note ,node-note-1))))
         (node2 (tx-make-node pool 'test-node `((note ,node-note-2))))
         (edge1 (tx-make-edge pool 'edge node1 node2 edge-type-befor)))
    (is (get-id node1)   (get-from-node-id edge1))
    (is (get-id node2)   (get-to-node-id edge1))
    (is edge-type-befor (get-edge-type edge1))
    (is edge1 (tx-change-type pool edge1 edge-type-after))
    (is edge-type-after (get-edge-type edge1))
    ;;
    (up:snapshot pool)))


(finalize)


#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

