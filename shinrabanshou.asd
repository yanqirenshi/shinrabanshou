(in-package :cl-user)

(defpackage shinrabanshou-asd
  (:use :cl :asdf))
(in-package :shinrabanshou-asd)

(defsystem shinrabanshou
  :version "0.1"
  :author "Satoshi Iwasaki"
  :license "LLGPL"
  :depends-on (:alexandria
               :cl-ppcre
               :cl+
               :upanishad
               :takajin84key
               :world2world)
  :components ((:module "src"
                        :components
                        ;;
                        ;; (start)
                        ;;    |
                        ;; package
                        ;;    |
                        ;;    +----------------------+
                        ;;    |                      |
                        ;; utility                   |
                        ;;    |                      |
                        ;; generic-function          |
                        ;;    |                      |
                        ;; class                     |
                        ;;    |                      |
                        ;; shinra           extension/cl-json+
                        ;;    |                      |
                        ;;  node                     |
                        ;;    |                      |
                        ;;  edge                     |
                        ;;    |                      |
                        ;;  finder                   |
                        ;;    |                      |
                        ;;  user                     |
                        ;;    |                      |
                        ;;  banshou                  |
                        ;;    |                      |
                        ;;    +----------------------+
                        ;;    |
                        ;;  (end)
                        ;;
                        ((:file "package")
                         ;;(:file "extension/cl-json+" :depends-on ("package"))
                         (:file "utility"            :depends-on ("package"))
                         (:file "generic-function"   :depends-on ("utility"))
                         (:file "class"              :depends-on ("generic-function"))
                         (:file "shinra"             :depends-on ("class"))
                         (:file "node"               :depends-on ("shinra"))
                         (:file "edge"               :depends-on ("node"))
                         (:file "finder"             :depends-on ("edge"))
                         (:file "user"               :depends-on ("finder"))
                         (:file "banshou"            :depends-on ("user")))))
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




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

Author: Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

