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


(test test-basic
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
    (let* ((node1 (make-node pool 'resource 'note node-note-1))
           (node2 (make-node pool 'resource 'note node-note-2))
           (node3 (make-node pool 'resource 'note node-note-3))
           (edge1 (make-edge pool 'edge node1 node2 edge-type))
           (edge2 (make-edge pool 'edge node1 node3 edge-type)))
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


(test test-find-r-xxx
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
    (let* ((node1 (make-node pool 'resource 'note node-note-1))
           (node2 (make-node pool 'resource 'note node-note-2))
           (node3 (make-node pool 'resource 'note node-note-3))
           (edge1 (make-edge pool 'edge node1 node2 edge-type))
           (edge2 (make-edge pool 'edge node1 node3 edge-type)))
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
                             (list :edge edge1 :node node2)))))
    (up:snapshot pool)))
