#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

Author: Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

(in-package :cl-user)
(defpackage shinrabanshou-asd
  (:use :cl :asdf))
(in-package :shinrabanshou-asd)

(defsystem shinrabanshou
  :version "0.1"
  :author "Satoshi Iwasaki"
  :license "LLGPL"
  :depends-on (:alexandria :cl-ppcre :cl+ :upanishad)
  :components ((:module "src"
                        :components
                        ;;
                        ;; (start)
                        ;;    |
                        ;; package
                        ;;    |
                        ;;    +----------------------------+
                        ;;    |                            |
                        ;; utility                 extension/cl-json+
                        ;;    |                            |
                        ;; class                           |
                        ;;    |                            |
                        ;;    +-------+                    |
                        ;;    |       |                    |
                        ;; shinra  password                |
                        ;;    |       |                    |
                        ;;  node      +------------------->|
                        ;;    |                            |
                        ;;  edge                           |
                        ;;    |                            |
                        ;;  finder                         |
                        ;;    |                            |
                        ;;  ghost                          |
                        ;;    |                            |
                        ;;    +--------+                   |
                        ;;    |        |                   |
                        ;;  banshou  deccot                |
                        ;;    |        |                   |
                        ;;    +--------+-------------------+
                        ;;    |
                        ;;  (end)
                        ;;
                        ((:file "package")
                         (:file "extension/cl-json+" :depends-on ("package"))
                         (:file "utility"            :depends-on ("package"))
                         (:file "class"              :depends-on ("utility"))
                         (:file "password"           :depends-on ("class"))
                         (:file "shinra"             :depends-on ("class"))
                         (:file "node"               :depends-on ("shinra"))
                         (:file "edge"               :depends-on ("node"))
                         (:file "finder"             :depends-on ("edge"))
                         (:file "ghost"              :depends-on ("finder"))
                         (:file "banshou"            :depends-on ("ghost"))
                         (:file "deccot"             :depends-on ("ghost")))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (load-op shinrabanshou-test))))
