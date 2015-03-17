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
;;;;;       Plan 7 : tx-change-vertex
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
(defclass test-vertex (vertex)
  ((note :documentation ""
         :accessor note
         :initarg :note
         :initform nil)))

;;;;;
;;;;; 3. Plan
;;;;;
;;;
;;; Plan 1 : Basic
;;;
(plan 1)
(let ((vertex-note-1 "n-note-1")
      (vertex-note-2 "n-note-2")
      (vertex-note-3 "n-note-3")
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
  (let* ((vertex1 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-1))))
         (vertex2 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-2))))
         (vertex3 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-3))))
         (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type))
         (edge2 (tx-make-edge pool 'edge vertex1 vertex3 edge-type)))
       ;;; check vertex
    (is vertex1 (find-object-with-id pool 'test-vertex (id vertex1)))
    (is vertex2 (find-object-with-id pool 'test-vertex (id vertex2)))
    (ok (find-object-with-slot pool 'test-vertex 'note vertex-note-1))
    (ok (find-object-with-slot pool 'test-vertex 'note vertex-note-2))
       ;;; check edge
    (is 2 (length (get-root-object pool :EDGE-ROOT)))
    (is 2 (length (find-object-with-slot pool 'edge 'shinra::edge-type :test-r)))
    (is 2 (length (find-object-with-slot pool 'edge 'shinra::from-id (id vertex1))))
    (is edge1 (find-object-with-id pool 'edge (id edge1)))
    (is edge2 (find-object-with-id pool 'edge (id edge2)))
    ;;
    (let ((tmp-edge-1 (find-object-with-id pool 'edge (id edge1)))
          (tmp-edge-2 (find-object-with-id pool 'edge (id edge2))))
      ;; check id. from and to vertex.
      (is (id vertex1) (from-id tmp-edge-1))
      (is (id vertex2) (to-id   tmp-edge-1))
      (is (id vertex1) (from-id tmp-edge-2))
      (is (id vertex3) (to-id   tmp-edge-2))
      ;; check class. from and to vertex.
      (is (class-name (class-of vertex1))
          (from-class tmp-edge-1))
      (is (class-name (class-of vertex2))
          (to-class tmp-edge-1))
      (is (class-name (class-of vertex1))
          (from-class tmp-edge-2))
      (is (class-name (class-of vertex3))
          (to-class tmp-edge-2))
      (is vertex1 (find-object-with-id pool (from-class tmp-edge-1) (id vertex1)))
      (is vertex2 (find-object-with-id pool (to-class tmp-edge-1)   (id vertex2)))
      (is vertex1 (find-object-with-id pool (from-class tmp-edge-2) (id vertex1)))
      (is vertex3 (find-object-with-id pool (to-class tmp-edge-2)   (id vertex3)))
      )
       ;;;
       ;;;
    (up:snapshot pool)
    (clean-data-sotr pool-stor)))



;;;
;;; Plan 2 : Predicates
;;;
(plan 2)
(let ((vertex-note-1 "n-note-1")
      (vertex-note-2 "n-note-2")
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
  (let* ((vertex1 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-1))))
         (vertex2 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-2))))
         (vertex3 (make-instance 'vertex :id -999))
         (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type))
         (edge2 (tx-make-edge pool 'edge vertex1 vertex3 edge-type))
         (edge3 (make-instance 'edge :id -999)))
    ;; テスト開始
    (ok (existp pool vertex1))
    (ok (existp pool vertex2))
    (ok (not (existp pool vertex3)))
    (ok (existp pool edge1))
    (ok (existp pool edge2))
    (ok (not (existp pool edge3)))
    (up:snapshot pool)))



;;;
;;; Plan 3 : Find-r-xxx
;;;
(plan 3)
(let ((vertex-note-1 "n-note-1")
      (vertex-note-2 "n-note-2")
      (vertex-note-3 "n-note-3")
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
  (let* ((vertex1 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-1))))
         (vertex2 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-2))))
         (vertex3 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-3))))
         (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type))
         (edge2 (tx-make-edge pool 'edge vertex1 vertex3 edge-type)))
    ;; find-r
    (is 2 (length (find-r-edge pool 'edge :from vertex1)))
    (is 0 (length (find-r-edge pool 'edge :to   vertex1)))
    (is 1 (length (find-r-edge pool 'edge :to   vertex2)))
    (is 1 (length (find-r-edge pool 'edge :to   vertex3)))
    (is 0 (length (find-r-edge pool 'edge :from vertex2)))
    (is 0 (length (find-r-edge pool 'edge :from vertex3)))
    (ok (equalp (find-r-edge pool 'edge :from vertex1)
                (list edge2 edge1)))
    (ok (equalp (find-r-vertex pool 'edge :from vertex1)
                (list vertex3 vertex2)))
    (ok (equalp (find-r pool 'edge :from vertex1)
                (list (list :edge edge2 :vertex vertex3)
                      (list :edge edge1 :vertex vertex2))))
    ;; get-r
    (let ((ret (get-r pool 'edge :from vertex1 vertex2 edge-type)))
      (is edge1 (getf ret :edge))
      (is vertex2 (getf ret :vertex)))
    (let ((ret (get-r pool 'edge :from vertex1 vertex3 edge-type)))
      (is edge2 (getf ret :edge))
      (is vertex3 (getf ret :vertex)))
    (is edge1 (get-r-edge pool 'edge :from vertex1 vertex2 edge-type))
    (is edge2 (get-r-edge pool 'edge :from vertex1 vertex3 edge-type))
    (is vertex2 (get-r-vertex pool 'edge :from vertex1 vertex2 edge-type))
    (is vertex3 (get-r-vertex pool 'edge :from vertex1 vertex3 edge-type)))
  (up:snapshot pool))




;;;
;;; Plan 4 : Slot-index
;;;
(plan 4)
(labels ((index-name (cls slot)
           (up::get-objects-slot-index-name cls slot)))
  (let ((vertex-note-1 "n-note-1")
        (vertex-note-2 "n-note-2")
        (rsc-class   'test-vertex)
        (vertex-class  'vertex)
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
    (let* ((vertex1 (tx-make-vertex pool rsc-class `((note ,vertex-note-1))))
           (vertex2 (tx-make-vertex pool rsc-class `((note ,vertex-note-2))))
           (vertex3 (make-instance  vertex-class :id -999))
           (edge1 (tx-make-edge pool edge-class vertex1 vertex2 edge-type))
           (edge2 (tx-make-edge pool edge-class vertex1 vertex3 edge-type))
           (edge3 (make-instance  edge-class :id -999)))
      (declare (ignore edge1 edge2 edge3))
      ;; テスト開始
      (ok (get-root-object pool (index-name edge-class 'from-id)))
      (ok (get-root-object pool (index-name edge-class 'to-id)))
      (ok (get-root-object pool (index-name edge-class 'edge-type)))
      (up:drop-index-on pool edge-class '(from-id to-id edge-type))
      (is nil (get-root-object pool (index-name edge-class 'from-id)))
      (is nil (get-root-object pool (index-name edge-class 'to-id)))
      (is nil (get-root-object pool (index-name edge-class 'edge-type)))
      (up:index-on pool edge-class '(from-id to-id edge-type))
      (ok (get-root-object pool (index-name edge-class 'from-id)))
      (ok (get-root-object pool (index-name edge-class 'to-id)))
      (ok (get-root-object pool (index-name edge-class 'edge-type)))
      ;;
      (up:snapshot pool))))



;;;
;;; Plan 5 : remove-object-on-slot-index
;;;
(plan 5)
(labels ((index-name (cls slot)
           (up::get-objects-slot-index-name cls slot)))
  (let ((vertex-note-1 "n-note-1")
        (vertex-note-2 "n-note-2")
        (rsc-class   'test-vertex)
        (vertex-class  'vertex)
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
    (let* ((vertex1 (tx-make-vertex pool rsc-class `((note ,vertex-note-1))))
           (vertex2 (tx-make-vertex pool rsc-class `((note ,vertex-note-2))))
           (vertex3 (make-instance  vertex-class :id -999))
           (edge1 (tx-make-edge pool edge-class vertex1 vertex2 edge-type))
           (edge2 (tx-make-edge pool edge-class vertex1 vertex3 edge-type)))
      (declare (ignore edge2))
      ;; テスト開始
      (ok (get-root-object pool (index-name edge-class 'from-id)))
      (ok (get-root-object pool (index-name edge-class 'to-id)))
      (ok (get-root-object pool (index-name edge-class 'edge-type)))
      (up:drop-index-on pool edge-class '(from-id to-id edge-type))
      (is nil (get-root-object pool (index-name edge-class 'from-id)))
      (is nil (get-root-object pool (index-name edge-class 'to-id)))
      (is nil (get-root-object pool (index-name edge-class 'edge-type)))
      (up:index-on pool edge-class '(from-id to-id edge-type))
      (ok (get-root-object pool (index-name edge-class 'from-id)))
      (ok (get-root-object pool (index-name edge-class 'to-id)))
      (ok (get-root-object pool (index-name edge-class 'edge-type)))
      ;;
      (let ((i-from (get-root-object pool
                                     (up::get-objects-slot-index-name edge-class 'from-id)))
            (i-to   (get-root-object pool
                                     (up::get-objects-slot-index-name edge-class 'to-id)))
            (i-type (get-root-object pool
                                     (up::get-objects-slot-index-name edge-class 'edge-type))))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type))
        ;; from
        (is 2 (hash-table-count (gethash (from-id edge1) i-from)))
        (up:tx-remove-object-on-slot-index pool edge1 'from-id)
        (is 1 (hash-table-count (gethash (from-id edge1) i-from)))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type))
        ;; to
        (is 1 (hash-table-count (gethash (to-id edge1) i-to)))
        (up:tx-remove-object-on-slot-index pool edge1 'to-id)
        (is 0 (hash-table-count (gethash (to-id edge1) i-to)))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type))
        ;; type
        (is 2 (hash-table-count (gethash (edge-type edge1) i-type)))
        (up:tx-remove-object-on-slot-index pool edge1 'edge-type)
        (is 1 (hash-table-count (gethash (edge-type edge1) i-type)))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type)))
      (up:snapshot pool))))


;;;
;;; Plan 6 : delete-edge
;;;
(plan 6)
(let ((vertex-note-1 "n-note-1")
      (vertex-note-2 "n-note-2")
      (rsc-class     'test-vertex)
      (vertex-class  'vertex)
      (edge-class    'edge)
      (edge-type     :test-r)
      (pool-stor     *pool-stor*)
      (pool nil))
  (unless pool-stor (error "*pool-stor*がnilのままです。"))
  (clean-data-sotr pool-stor)
  (setf pool (make-banshou 'banshou pool-stor))
  (ok pool)
  ;; object を生成
  (let* ((vertex1 (tx-make-vertex pool rsc-class `((note ,vertex-note-1))))
         (vertex2 (tx-make-vertex pool rsc-class `((note ,vertex-note-2))))
         (vertex3 (make-instance  vertex-class :id -999))
         (edge1 (tx-make-edge pool edge-class vertex1 vertex2 edge-type))
         (edge2 (tx-make-edge pool edge-class vertex1 vertex3 edge-type)))
    (declare (ignore edge2))
    ;; テスト開始
    (let ((i-from (get-root-object pool (up::get-objects-slot-index-name edge-class 'from-id)))
          (i-to   (get-root-object pool (up::get-objects-slot-index-name edge-class 'to-id)))
          (i-type (get-root-object pool (up::get-objects-slot-index-name edge-class 'edge-type))))
      (is 1 (hash-table-count i-from))
      (is 2 (hash-table-count i-to))
      (is 1 (hash-table-count i-type))
      ;; befor check
      (ok (not (null (member edge1 (find-all-objects pool edge-class)))))
      (is edge1 (get-object-with-id pool edge-class (id edge1)))
      (is 2 (length (find-object-with-slot pool edge-class 'from-id   (from-id   edge1))))
      (is 1 (length (find-object-with-slot pool edge-class 'to-id     (to-id     edge1))))
      (is 2 (length (find-object-with-slot pool edge-class 'edge-type (edge-type edge1))))
      ;; do
      (shinra::tx-delete-edge pool edge1)
      ;; after check
      (is nil (not (null (member edge1 (find-all-objects pool edge-class)))))
      (is nil (eq edge1 (get-object-with-id pool edge-class (id edge1))))
      (is 1 (length (find-object-with-slot pool edge-class 'from-id   (from-id   edge1))))
      (is 0 (length (find-object-with-slot pool edge-class 'to-id     (to-id     edge1))))
      (is 1 (length (find-object-with-slot pool edge-class 'edge-type (edge-type edge1))))
      ;;
      (is 1 (hash-table-count i-from))
      (is 2 (hash-table-count i-to))
      (is 1 (hash-table-count i-type))))
  (up:snapshot pool))



;;;
;;; Plan 7 : tx-change-vertex
;;;
(plan 7)
(let ((vertex-note-1 "n-note-1")
      (vertex-note-2 "n-note-2")
      (vertex-note-3 "n-note-3")
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
  (let* ((vertex1 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-1))))
         (vertex2 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-2))))
         (vertex3 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-3))))
         (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type)))
    (is (id vertex1) (from-id edge1))
    (is (id vertex2) (to-id   edge1))
    (is edge1 (tx-change-vertex pool edge1 :from vertex3))
    (is (id vertex3) (from-id edge1))
    (is (id vertex2) (to-id   edge1))
    (is edge1 (tx-change-vertex pool edge1 :to vertex1))
    (is (id vertex3) (from-id edge1))
    (is (id vertex1) (to-id   edge1))
    (up:snapshot pool)
    ))


;;;
;;; Plan 8 : tx-change-type
;;;
(plan 8)
(let ((vertex-note-1 "n-note-1")
      (vertex-note-2 "n-note-2")
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
  (let* ((vertex1 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-1))))
         (vertex2 (tx-make-vertex pool 'test-vertex `((note ,vertex-note-2))))
         (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type-befor)))
    (is (id vertex1)   (from-id edge1))
    (is (id vertex2)   (to-id edge1))
    (is edge-type-befor (edge-type edge1))
    (is edge1 (tx-change-type pool edge1 edge-type-after))
    (is edge-type-after (edge-type edge1))
    ;;
    (up:snapshot pool)))


(finalize)


#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

