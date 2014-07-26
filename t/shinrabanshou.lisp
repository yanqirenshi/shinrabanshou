#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

(in-package :cl-user)
(defpackage shinrabanshou-test
  (:use :cl
        :upanishad
        :shinrabanshou
        :fiveam)
  (:nicknames :shinra-test))

(in-package :shinrabanshou-test)

(def-suite test-shinrabanshou) ;; :in shinrabanshou-test

(in-suite test-shinrabanshou)


(defvar *pool*      nil)
(defvar *pool-stor* (concatenate 'string
                                 (namestring (user-homedir-pathname))
                                 "tmp/shinra/")
  "TODO: ディレクトリがなかったら作ろうか。。。。")

(defun clean-data-sotr (data-stor)
  (when (probe-file data-stor)
    (dolist (pathname (directory (merge-pathnames "*.xml" data-stor)))
      (delete-file pathname))))


(test test@basic
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
    (is-true pool)
    ;;
    (let* ((node1 (tx-make-node pool 'resource 'note node-note-1))
           (node2 (tx-make-node pool 'resource 'note node-note-2))
           (node3 (tx-make-node pool 'resource 'note node-note-3))
           (edge1 (tx-make-edge pool 'edge node1 node2 edge-type))
           (edge2 (tx-make-edge pool 'edge node1 node3 edge-type)))
      ;;; check node
      (is-true (eq node1 (find-object-with-id pool 'resource (get-id node1))))
      (is-true (eq node2 (find-object-with-id pool 'resource (get-id node2))))
      (is-true (find-object-with-slot pool 'resource 'note node-note-1))
      (is-true (find-object-with-slot pool 'resource 'note node-note-2))
      ;;; check edge
      (is-true (= 2 (length (get-root-object pool :EDGE-ROOT))))
      (is-true (= 2 (length (find-object-with-slot pool 'edge 'shinra::type :test-r))))
      (is-true (= 2 (length (find-object-with-slot pool 'edge 'shinra::from (get-id node1)))))
      (is-true (eq edge1 (find-object-with-id pool 'edge (get-id edge1))))
      (is-true (eq edge2 (find-object-with-id pool 'edge (get-id edge2))))
      ;;
      (let ((tmp-edge-1 (find-object-with-id pool 'edge (get-id edge1)))
            (tmp-edge-2 (find-object-with-id pool 'edge (get-id edge2))))
        ;; check id. from and to node.
        (is-true (= (get-id node1) (get-from-node-id tmp-edge-1)))
        (is-true (= (get-id node2) (get-to-node-id   tmp-edge-1)))
        (is-true (= (get-id node1) (get-from-node-id tmp-edge-2)))
        (is-true (= (get-id node3) (get-to-node-id   tmp-edge-2)))
        ;; check class. from and to node.
        (is-true (eq (class-name (class-of node1))
                     (get-from-node-class tmp-edge-1)))
        (is-true (eq (class-name (class-of node2))
                     (get-to-node-class tmp-edge-1)))
        (is-true (eq (class-name (class-of node1))
                     (get-from-node-class tmp-edge-2)))
        (is-true (eq (class-name (class-of node3))
                     (get-to-node-class tmp-edge-2)))
        (is-true (eq node1 (find-object-with-id pool (get-from-node-class tmp-edge-1) (get-id node1))))
        (is-true (eq node2 (find-object-with-id pool (get-to-node-class tmp-edge-1)   (get-id node2))))
        (is-true (eq node1 (find-object-with-id pool (get-from-node-class tmp-edge-2) (get-id node1))))
        (is-true (eq node3 (find-object-with-id pool (get-to-node-class tmp-edge-2)   (get-id node3))))
        )
      ;;;
      ;;;
      (up:snapshot pool)
      (clean-data-sotr pool-stor))))



(test test@predicates
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
    (is-true pool)
    ;; object を生成
    (let* ((node1 (tx-make-node pool 'resource 'note node-note-1))
           (node2 (tx-make-node pool 'resource 'note node-note-2))
           (node3 (make-instance 'node :id -999))
           (edge1 (tx-make-edge pool 'edge node1 node2 edge-type))
           (edge2 (tx-make-edge pool 'edge node1 node3 edge-type))
           (edge3 (make-instance 'edge :id -999)))
      ;; テスト開始
      (is-true (existp pool node1))
      (is-true (existp pool node2))
      (is-true (not (existp pool node3)))
      (is-true (existp pool edge1))
      (is-true (existp pool edge2))
      (is-true (not (existp pool edge3)))
      (up:snapshot pool))))



(test test@find-r-xxx
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
    (is-true pool)
    ;;
    (let* ((node1 (tx-make-node pool 'resource 'note node-note-1))
           (node2 (tx-make-node pool 'resource 'note node-note-2))
           (node3 (tx-make-node pool 'resource 'note node-note-3))
           (edge1 (tx-make-edge pool 'edge node1 node2 edge-type))
           (edge2 (tx-make-edge pool 'edge node1 node3 edge-type)))
      ;; find-r
      (is-true (= 2 (length (find-r-edge pool 'edge :from node1))))
      (is-true (= 0 (length (find-r-edge pool 'edge :to   node1))))
      (is-true (= 1 (length (find-r-edge pool 'edge :to   node2))))
      (is-true (= 1 (length (find-r-edge pool 'edge :to   node3))))
      (is-true (= 0 (length (find-r-edge pool 'edge :from node2))))
      (is-true (= 0 (length (find-r-edge pool 'edge :from node3))))
      (is-true (equalp (find-r-edge pool 'edge :from node1)
                       (list edge2 edge1)))
      (is-true (equalp (find-r-node pool 'edge :from node1)
                       (list node3 node2)))
      (is-true (equalp (find-r pool 'edge :from node1)
                       (list (list :edge edge2 :node node3)
                             (list :edge edge1 :node node2))))
      ;; get-r
      (let ((ret (get-r pool 'edge :from node1 node2 edge-type)))
        (is-true (eq edge1 (getf ret :edge)))
        (is-true (eq node2 (getf ret :node))))
      (let ((ret (get-r pool 'edge :from node1 node3 edge-type)))
        (is-true (eq edge2 (getf ret :edge)))
        (is-true (eq node3 (getf ret :node))))
      (is-true (eq edge1 (get-r-edge pool 'edge :from node1 node2 edge-type)))
      (is-true (eq edge2 (get-r-edge pool 'edge :from node1 node3 edge-type)))
      (is-true (eq node2 (get-r-node pool 'edge :from node1 node2 edge-type)))
      (is-true (eq node3 (get-r-node pool 'edge :from node1 node3 edge-type))))
    (up:snapshot pool)))




;;
(test test@slot-index
  (labels ((index-name (cls slot)
             (up::get-objects-slot-index-name cls slot)))
    (let ((node-note-1 "n-note-1")
          (node-note-2 "n-note-2")
          (rsc-class   'resource)
          (node-class  'node)
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
      (is-true pool)
      ;; object を生成
      (let* ((node1 (tx-make-node pool rsc-class 'note node-note-1))
             (node2 (tx-make-node pool rsc-class 'note node-note-2))
             (node3 (make-instance  node-class :id -999))
             (edge1 (tx-make-edge pool edge-class node1 node2 edge-type))
             (edge2 (tx-make-edge pool edge-class node1 node3 edge-type))
             (edge3 (make-instance  edge-class :id -999)))
        (declare (ignore edge1 edge2 edge3))
        ;; テスト開始
        (is-true (get-root-object pool (index-name edge-class 'from)))
        (is-true (get-root-object pool (index-name edge-class 'to)))
        (is-true (get-root-object pool (index-name edge-class 'type)))
        (up:drop-index-on pool edge-class '(from to type))
        (is-false (get-root-object pool (index-name edge-class 'from)))
        (is-false (get-root-object pool (index-name edge-class 'to)))
        (is-false (get-root-object pool (index-name edge-class 'type)))
        (up:index-on pool edge-class '(shinra::from shinra::to shinra::type))
        (is-true (get-root-object pool (index-name edge-class 'from)))
        (is-true (get-root-object pool (index-name edge-class 'to)))
        (is-true (get-root-object pool (index-name edge-class 'type)))
        ;;
        (up:snapshot pool)))))



;;
(test test@remove-object-on-slot-index
  (labels ((index-name (cls slot)
             (up::get-objects-slot-index-name cls slot)))
    (let ((node-note-1 "n-note-1")
          (node-note-2 "n-note-2")
          (rsc-class   'resource)
          (node-class  'node)
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
      (is-true pool)
      ;; object を生成
      (let* ((node1 (tx-make-node pool rsc-class 'note node-note-1))
             (node2 (tx-make-node pool rsc-class 'note node-note-2))
             (node3 (make-instance  node-class :id -999))
             (edge1 (tx-make-edge pool edge-class node1 node2 edge-type))
             (edge2 (tx-make-edge pool edge-class node1 node3 edge-type)))
        (declare (ignore edge2))
        ;; テスト開始
        (is-true (get-root-object pool (index-name edge-class 'from)))
        (is-true (get-root-object pool (index-name edge-class 'to)))
        (is-true (get-root-object pool (index-name edge-class 'type)))
        (up:drop-index-on pool edge-class '(from to type))
        (is-false (get-root-object pool (index-name edge-class 'from)))
        (is-false (get-root-object pool (index-name edge-class 'to)))
        (is-false (get-root-object pool (index-name edge-class 'type)))
        (up:index-on pool edge-class '(shinra::from shinra::to shinra::type))
        (is-true (get-root-object pool (index-name edge-class 'from)))
        (is-true (get-root-object pool (index-name edge-class 'to)))
        (is-true (get-root-object pool (index-name edge-class 'type)))
        ;;
        (let ((i-from (get-root-object pool (up::get-objects-slot-index-name edge-class 'from)))
              (i-to   (get-root-object pool (up::get-objects-slot-index-name edge-class 'to)))
              (i-type (get-root-object pool (up::get-objects-slot-index-name edge-class 'type))))
          (is-true (= 1 (hash-table-count i-from)))
          (is-true (= 2 (hash-table-count i-to)))
          (is-true (= 1 (hash-table-count i-type)))
          ;; from
          (is-true (= 2 (hash-table-count (gethash (get-from-node-id edge1) i-from))))
          (up:tx-remove-object-on-slot-index pool edge1 'shinra::from)
          (is-true (= 1 (hash-table-count (gethash (get-from-node-id edge1) i-from))))
          (is-true (= 1 (hash-table-count i-from)))
          (is-true (= 2 (hash-table-count i-to)))
          (is-true (= 1 (hash-table-count i-type)))
          ;; to
          (is-true (= 1 (hash-table-count (gethash (get-to-node-id edge1) i-to))))
          (up:tx-remove-object-on-slot-index pool edge1 'shinra::to)
          (is-true (= 0 (hash-table-count (gethash (get-to-node-id edge1) i-to))))
          (is-true (= 1 (hash-table-count i-from)))
          (is-true (= 2 (hash-table-count i-to)))
          (is-true (= 1 (hash-table-count i-type)))
          ;; type
          (is-true (= 2 (hash-table-count (gethash (get-edge-type edge1) i-type))))
          (up:tx-remove-object-on-slot-index pool edge1 'shinra::type)
          (is-true (= 1 (hash-table-count (gethash (get-edge-type edge1) i-type))))
          (is-true (= 1 (hash-table-count i-from)))
          (is-true (= 2 (hash-table-count i-to)))
          (is-true (= 1 (hash-table-count i-type))))
        (up:snapshot pool)))))


(test test@delete-edge
  (let ((node-note-1 "n-note-1")
        (node-note-2 "n-note-2")
        (rsc-class   'resource)
        (node-class  'node)
        (edge-class  'edge)
        (edge-type   :test-r)
        (pool-stor *pool-stor*)
        (pool nil))
    (unless pool-stor (error "*pool-stor*がnilのままです。"))
    (clean-data-sotr pool-stor)
    (setf pool (make-banshou 'banshou pool-stor))
    (is-true pool)
    ;; object を生成
    (let* ((node1 (tx-make-node pool rsc-class 'note node-note-1))
           (node2 (tx-make-node pool rsc-class 'note node-note-2))
           (node3 (make-instance  node-class :id -999))
           (edge1 (tx-make-edge pool edge-class node1 node2 edge-type))
           (edge2 (tx-make-edge pool edge-class node1 node3 edge-type)))
      (declare (ignore edge2))
      ;; テスト開始
      (let ((i-from (get-root-object pool (up::get-objects-slot-index-name edge-class 'from)))
            (i-to   (get-root-object pool (up::get-objects-slot-index-name edge-class 'to)))
            (i-type (get-root-object pool (up::get-objects-slot-index-name edge-class 'type))))
        (is-true (= 1 (hash-table-count i-from)))
        (is-true (= 2 (hash-table-count i-to)))
        (is-true (= 1 (hash-table-count i-type)))
        ;; befor check
        (is-true (not (null (member edge1 (find-all-objects pool edge-class)))))
        (is-true (eq edge1 (get-object-with-id pool edge-class (get-id edge1))))
        (is-true (= 2
                    (length (find-object-with-slot pool edge-class 'shinra::from (get-from-node-id edge1)))))
        (is-true (= 1
                    (length
                     (find-object-with-slot pool edge-class 'shinra::to (get-to-node-id edge1)))))
        (is-true (= 2
                    (length (find-object-with-slot pool edge-class 'shinra::type (get-edge-type edge1)))))
        ;; do
        (shinra::tx-delete-edge pool edge1)
        ;; after check
        (is-false (not (null (member edge1 (find-all-objects pool edge-class)))))
        (is-false (eq edge1 (get-object-with-id pool edge-class (get-id edge1))))
        (is-true (= 1
                    (length (find-object-with-slot pool edge-class 'shinra::from (get-from-node-id edge1)))))
        (is-true (= 0
                    (length
                     (find-object-with-slot pool edge-class 'shinra::to (get-to-node-id edge1)))))
        (is-true (= 1
                    (length (find-object-with-slot pool edge-class 'shinra::type (get-edge-type edge1)))))

        ;;
        (is-true (= 1 (hash-table-count i-from)))
        (is-true (= 2 (hash-table-count i-to)))
        (is-true (= 1 (hash-table-count i-type)))))
    (up:snapshot pool)))



(test test@tx-change-node
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
    (is-true pool)
    ;;
    (let* ((node1 (tx-make-node pool 'resource 'note node-note-1))
           (node2 (tx-make-node pool 'resource 'note node-note-2))
           (node3 (tx-make-node pool 'resource 'note node-note-3))
           (edge1 (tx-make-edge pool 'edge node1 node2 edge-type)))
      (is-true (= (get-id node1) (get-from-node-id edge1)))
      (is-true (= (get-id node2) (get-to-node-id edge1)))
      (is-true (eq edge1 (tx-change-node pool edge1 :from node3)))
      (is-true (= (get-id node3) (get-from-node-id edge1)))
      (is-true (= (get-id node2) (get-to-node-id edge1)))
      (is-true (eq edge1 (tx-change-node pool edge1 :to node1)))
      (is-true (= (get-id node3) (get-from-node-id edge1)))
      (is-true (= (get-id node1) (get-to-node-id edge1)))
      (up:snapshot pool)
      )))



(test test@tx-change-type
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
    (is-true pool)
    ;;
    (let* ((node1 (tx-make-node pool 'resource 'note node-note-1))
           (node2 (tx-make-node pool 'resource 'note node-note-2))
           (edge1 (tx-make-edge pool 'edge node1 node2 edge-type-befor)))
      (is-true (= (get-id node1)   (get-from-node-id edge1)))
      (is-true (= (get-id node2)   (get-to-node-id edge1)))
      (is-true (eq edge-type-befor (get-edge-type edge1)))
      (is-true (eq edge1 (tx-change-type pool edge1 edge-type-after)))
      (is-true (eq edge-type-after (get-edge-type edge1)))
      ;;
      (up:snapshot pool))))
