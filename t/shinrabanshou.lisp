(in-package :cl-user)
(defpackage shinrabanshou-test
  (:use :cl
   :upanishad
        :shinrabanshou
   :prove)
  (:nicknames :shinra-test))

(in-package :shinrabanshou-test)

;;;
;;; Variable
;;;
(defvar *pool*      nil)
(defvar *pool-stor* (concatenate 'string
                                 (namestring (user-homedir-pathname))
                                 "tmp/shinra/")
  "TODO: ディレクトリがなかったら作ろうか。。。。")

;;;
;;; Class
;;;
(defclass vertex (shin)
  ((note :documentation ""
         :accessor note
         :initarg :note
         :initform nil)))

(defclass edge (ra) ())

;;;
;;; utility
;;;
(defun clean-data-sotr (data-stor)
  (when (probe-file data-stor)
    (dolist (pathname (directory (merge-pathnames "*.xml" data-stor)))
      (delete-file pathname))))

(defun make-test-pool (&optional (pool-stor *pool-stor*))
  (unless pool-stor (error "*pool-stor*がnilのままです。"))
  (clean-data-sotr pool-stor)
  (make-banshou 'banshou pool-stor))

(plan 9)

;;;
;;; Basic
;;;

(subtest "Basic Test"
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
    (let* ((vertex1 (tx-make-vertex pool 'vertex `((note ,vertex-note-1))))
           (vertex2 (tx-make-vertex pool 'vertex `((note ,vertex-note-2))))
           (vertex3 (tx-make-vertex pool 'vertex `((note ,vertex-note-3))))
           (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type))
           (edge2 (tx-make-edge pool 'edge vertex1 vertex3 edge-type)))

      (subtest "can make vertex"
        (is vertex1 (find-object-with-%id pool 'vertex (%id vertex1)) "vertex %id is 1")
        (is vertex2 (find-object-with-%id pool 'vertex (%id vertex2)) "vertex %id is 2")
        (ok (find-object-with-slot pool 'vertex 'note vertex-note-1) "can finde vertex1 at note")
        (ok (find-object-with-slot pool 'vertex 'note vertex-note-2) "can finde vertex2 at note"))

      (subtest "can make edge"
        (is 2 (length (get-root-object pool :EDGE-ROOT)) "maked two edges")
        (is 2 (length (find-object-with-slot pool 'edge 'shinra::edge-type :test-r)) "edge type is :test-r")
        (is 2 (length (find-object-with-slot pool 'edge 'shinra::from-id (%id vertex1))))
        (is edge1 (find-object-with-%id pool 'edge (%id edge1)))
        (is edge2 (find-object-with-%id pool 'edge (%id edge2)))
        ;;
        (let ((tmp-edge-1 (find-object-with-%id pool 'edge (%id edge1)))
              (tmp-edge-2 (find-object-with-%id pool 'edge (%id edge2))))
          ;; check id. from and to vertex.
          (is (%id vertex1) (from-id tmp-edge-1))
          (is (%id vertex2) (to-id   tmp-edge-1))
          (is (%id vertex1) (from-id tmp-edge-2))
          (is (%id vertex3) (to-id   tmp-edge-2))
          ;; check class. from and to vertex.
          (is (class-name (class-of vertex1))
              (from-class tmp-edge-1))
          (is (class-name (class-of vertex2))
              (to-class tmp-edge-1))
          (is (class-name (class-of vertex1))
              (from-class tmp-edge-2))
          (is (class-name (class-of vertex3))
              (to-class tmp-edge-2))
          (is vertex1 (find-object-with-%id pool (from-class tmp-edge-1) (%id vertex1)))
          (is vertex2 (find-object-with-%id pool (to-class tmp-edge-1)   (%id vertex2)))
          (is vertex1 (find-object-with-%id pool (from-class tmp-edge-2) (%id vertex1)))
          (is vertex3 (find-object-with-%id pool (to-class tmp-edge-2)   (%id vertex3))))
       ;;;
       ;;;
        (up:snapshot pool)
        (clean-data-sotr pool-stor)))))


;;;
;;; Predicates
;;;
(subtest "Predicates Test"
  (let ((pool (make-test-pool))
        (vertex-note-1 "n-note-1")
        (vertex-note-2 "n-note-2")
        (edge-type :test-r))

    (let* ((vertex1 (tx-make-vertex pool 'vertex `((note ,vertex-note-1))))
           (vertex2 (tx-make-vertex pool 'vertex `((note ,vertex-note-2))))
           (vertex3 (make-instance 'vertex :%id -999))
           (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type))
           (edge2 (tx-make-edge pool 'edge vertex1 vertex3 edge-type))
           (edge3 (make-instance 'edge :%id -999)))

      (subtest "existp"
        (ok (existp pool vertex1))
        (ok (existp pool vertex2))
        (ok (existp pool edge1))
        (ok (existp pool edge2)))

      (subtest "not existp"
        (ok (not (existp pool vertex3)))
        (ok (not (existp pool edge3))))

      (up:snapshot pool))))


;;;
;;; Find-r-xxx
;;;
(subtest "Find-r-xxx"
  (let ((pool (make-test-pool))
        (vertex-note-1 "n-note-1")
        (vertex-note-2 "n-note-2")
        (vertex-note-3 "n-note-3")
        (edge-type   :test-r))

    (let* ((vertex1 (tx-make-vertex pool 'vertex `((note ,vertex-note-1))))
           (vertex2 (tx-make-vertex pool 'vertex `((note ,vertex-note-2))))
           (vertex3 (tx-make-vertex pool 'vertex `((note ,vertex-note-3))))
           (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type))
           (edge2 (tx-make-edge pool 'edge vertex1 vertex3 edge-type)))
      (subtest "find-r"
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
                          (list :edge edge1 :vertex vertex2)))))

      (subtest "get-r"
        (let ((ret (get-r pool 'edge :from vertex1 vertex2 edge-type)))
          (is edge1 (getf ret :edge))
          (is vertex2 (getf ret :vertex)))
        (let ((ret (get-r pool 'edge :from vertex1 vertex3 edge-type)))
          (is edge2 (getf ret :edge))
          (is vertex3 (getf ret :vertex)))
        (is edge1 (get-r-edge pool 'edge :from vertex1 vertex2 edge-type))
        (is edge2 (get-r-edge pool 'edge :from vertex1 vertex3 edge-type))
        (is vertex2 (get-r-vertex pool 'edge :from vertex1 vertex2 edge-type))
        (is vertex3 (get-r-vertex pool 'edge :from vertex1 vertex3 edge-type))))

    (up:snapshot pool)))


;;;
;;; Slot-index
;;;
(subtest "Slot-index"
  (labels ((index-name (cls slot)
             (up::get-objects-slot-index-name cls slot)))
    (let ((pool (make-test-pool))
          (vertex-note-1 "n-note-1")
          (vertex-note-2 "n-note-2")
          (rsc-class   'vertex)
          (vertex-class  'shin)
          (edge-class  'edge)
          (edge-type   :test-r))

      (let* ((vertex1 (tx-make-vertex pool rsc-class `((note ,vertex-note-1))))
             (vertex2 (tx-make-vertex pool rsc-class `((note ,vertex-note-2))))
             (vertex3 (make-instance  vertex-class :%id -999))
             (edge1 (tx-make-edge pool edge-class vertex1 vertex2 edge-type))
             (edge2 (tx-make-edge pool edge-class vertex1 vertex3 edge-type))
             (edge3 (make-instance  edge-class :%id -999)))
        (declare (ignore edge1 edge2 edge3))

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

        (up:snapshot pool)))))


;;;
;;; remove-object-on-slot-index
;;;
(subtest "remove-object-on-slot-index"
  (labels ((index-name (cls slot)
             (up::get-objects-slot-index-name cls slot)))
    (let* ((pool (make-test-pool))
           (vertex-note-1 "n-note-1")
           (vertex-note-2 "n-note-2")
           (rsc-class   'vertex)
           (vertex-class  'shin)
           (edge-class  'edge)
           (edge-type   :test-r)
           (vertex1 (tx-make-vertex pool rsc-class `((note ,vertex-note-1))))
           (vertex2 (tx-make-vertex pool rsc-class `((note ,vertex-note-2))))
           (vertex3 (make-instance  vertex-class :%id -999))
           (edge1 (tx-make-edge pool edge-class vertex1 vertex2 edge-type)))
      (tx-make-edge pool edge-class vertex1 vertex3 edge-type)

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

        (subtest "from"
          (is 2 (hash-table-count (gethash (from-id edge1) i-from)))
          (up:tx-remove-object-on-slot-index pool edge1 'from-id)
          (is 1 (hash-table-count (gethash (from-id edge1) i-from)))
          (is 1 (hash-table-count i-from))
          (is 2 (hash-table-count i-to))
          (is 1 (hash-table-count i-type)))

        (subtest "to"
          (is 1 (hash-table-count (gethash (to-id edge1) i-to)))
          (up:tx-remove-object-on-slot-index pool edge1 'to-id)
          (is 0 (hash-table-count (gethash (to-id edge1) i-to)))
          (is 1 (hash-table-count i-from))
          (is 2 (hash-table-count i-to))
          (is 1 (hash-table-count i-type)))

        (subtest "type"
          (is 2 (hash-table-count (gethash (edge-type edge1) i-type)))
          (up:tx-remove-object-on-slot-index pool edge1 'edge-type)
          (is 1 (hash-table-count (gethash (edge-type edge1) i-type)))
          (is 1 (hash-table-count i-from))
          (is 2 (hash-table-count i-to))
          (is 1 (hash-table-count i-type))))

      (up:snapshot pool))))


;;;
;;; delete-vertex
;;;
(subtest "delete-vertex"
  (let* ((pool (make-test-pool))
         (vertex-note-1 "n-note-1")
         (vertex-note-2 "n-note-2")
         (rsc-class     'vertex)
         (edge-class    'edge)
         (edge-type     :test-r)
         (vertex1 (tx-make-vertex pool rsc-class `((note ,vertex-note-1))))
         (vertex2 (tx-make-vertex pool rsc-class `((note ,vertex-note-2))))
         (vertex3 (tx-make-vertex pool rsc-class))
         (vertex4 (tx-make-vertex pool rsc-class)))
    (tx-make-edge pool edge-class vertex1 vertex2 edge-type)

    (subtest "can not delete, exist edge"
      (ok (existp pool vertex1))
      (is-error (tx-delete-vertex pool vertex1) 'error)
      (is-error (delete-vertex pool vertex1) 'error)
      (ok (existp pool vertex1)))

    (subtest "can not delete, exist edge"
      (ok (existp pool vertex2))
      (is-error (tx-delete-vertex pool vertex2) 'error)
      (is-error (delete-vertex pool vertex2) 'error)
      (ok (existp pool vertex2)))

    (subtest "can delete"
      (subtest "vertex3"
        (ok (existp pool vertex3))
        (ok (tx-delete-vertex pool vertex3))
        (is nil (existp pool vertex3)))
      (subtest "vertex4"
        (ok (existp pool vertex4))
        (ok (delete-vertex pool vertex4))
        (is nil (existp pool vertex4))))

    (up:snapshot pool)))

;;;
;;; delete-edge
;;;
(subtest "delete-edge"
  (let ((pool (make-test-pool))
        (vertex-note-1 "n-note-1")
        (vertex-note-2 "n-note-2")
        (rsc-class     'vertex)
        (vertex-class  'shin)
        (edge-class    'edge)
        (edge-type     :test-r))

    (let* ((vertex1 (tx-make-vertex pool rsc-class `((note ,vertex-note-1))))
           (vertex2 (tx-make-vertex pool rsc-class `((note ,vertex-note-2))))
           (vertex3 (make-instance  vertex-class :%id -999))
           (edge1 (tx-make-edge pool edge-class vertex1 vertex2 edge-type))
           (edge2 (tx-make-edge pool edge-class vertex1 vertex3 edge-type)))

      (let ((i-from (get-root-object pool (up::get-objects-slot-index-name edge-class 'from-id)))
            (i-to   (get-root-object pool (up::get-objects-slot-index-name edge-class 'to-id)))
            (i-type (get-root-object pool (up::get-objects-slot-index-name edge-class 'edge-type))))
        (is 1 (hash-table-count i-from))
        (is 2 (hash-table-count i-to))
        (is 1 (hash-table-count i-type))

        (subtest "befor check"
          (ok (not (null (member edge1 (find-all-objects pool edge-class)))))
          (is edge1 (get-object-with-%id pool edge-class (%id edge1)))
          (is 2 (length (find-object-with-slot pool edge-class 'from-id   (from-id   edge1))))
          (is 1 (length (find-object-with-slot pool edge-class 'to-id     (to-id     edge1))))
          (is 2 (length (find-object-with-slot pool edge-class 'edge-type (edge-type edge1)))))

        (subtest "tx-delete-edge edge1"
          (shinra::tx-delete-edge pool edge1)
          (is nil (not (null (member edge1 (find-all-objects pool edge-class)))))
          (is nil (eq edge1 (get-object-with-%id pool edge-class (%id edge1))))
          (is 1 (length (find-object-with-slot pool edge-class 'from-id   (from-id   edge1))))
          (is 0 (length (find-object-with-slot pool edge-class 'to-id     (to-id     edge1))))
          (is 1 (length (find-object-with-slot pool edge-class 'edge-type (edge-type edge1)))))

        (subtest "delete-edge edge2"
          (shinra::delete-edge pool edge2)
          (is nil (not (null (member edge1 (find-all-objects pool edge-class)))))
          (is nil (eq edge1 (get-object-with-%id pool edge-class (%id edge1))))
          (is 0 (length (find-object-with-slot pool edge-class 'from-id   (from-id   edge1))))
          (is 0 (length (find-object-with-slot pool edge-class 'to-id     (to-id     edge1))))
          (is 0 (length (find-object-with-slot pool edge-class 'edge-type (edge-type edge1)))))

        (subtest "hash-table-count"
          (is 1 (hash-table-count i-from))
          (is 2 (hash-table-count i-to))
          (is 1 (hash-table-count i-type)))))

    (up:snapshot pool)))


;;;
;;; tx-change-vertex
;;;
(subtest "tx-change-vertex"
  (let ((pool (make-test-pool))
        (vertex-note-1 "n-note-1")
        (vertex-note-2 "n-note-2")
        (vertex-note-3 "n-note-3")
        (edge-type   :test-r))

    (let* ((vertex1 (tx-make-vertex pool 'vertex `((note ,vertex-note-1))))
           (vertex2 (tx-make-vertex pool 'vertex `((note ,vertex-note-2))))
           (vertex3 (tx-make-vertex pool 'vertex `((note ,vertex-note-3))))
           (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type)))
      (is (%id vertex1) (from-id edge1))
      (is (%id vertex2) (to-id   edge1))
      (is edge1 (tx-change-vertex pool edge1 :from vertex3))
      (is (%id vertex3) (from-id edge1))
      (is (%id vertex2) (to-id   edge1))
      (is edge1 (tx-change-vertex pool edge1 :to vertex1))
      (is (%id vertex3) (from-id edge1))
      (is (%id vertex1) (to-id   edge1))

      (up:snapshot pool))))


;;;
;;; tx-change-type
;;;
(subtest "tx-change-type"
  (let* ((pool (make-test-pool))
         (vertex-note-1 "n-note-1")
         (vertex-note-2 "n-note-2")
         (edge-type-befor :test-b)
         (edge-type-after :test-a)
         (vertex1 (tx-make-vertex pool 'vertex `((note ,vertex-note-1))))
         (vertex2 (tx-make-vertex pool 'vertex `((note ,vertex-note-2))))
         (edge1 (tx-make-edge pool 'edge vertex1 vertex2 edge-type-befor)))

    (is (%id vertex1)   (from-id edge1))
    (is (%id vertex2)   (to-id edge1))
    (is edge-type-befor (edge-type edge1))
    (is edge1 (tx-change-type pool edge1 edge-type-after))
    (is edge-type-after (edge-type edge1))

    (up:snapshot pool)))


(finalize)
