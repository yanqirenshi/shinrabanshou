#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

(in-package :cl-user)
(defpackage shinrabanshou-test-asd
  (:use :cl :asdf))
(in-package :shinrabanshou-test-asd)

(defsystem shinrabanshou-test
  :author "Satoshi Iwasaki"
  :license "LLGPL"
  :depends-on (:shinrabanshou
               :prove)
  :components ((:module "t"
                :components
                ((:file "shinrabanshou")
                 (:file "banshou.lisp")
                 (:file "communication.lisp")
                 (:file "edge.lisp")
                 (:file "finder.lisp")
                 (:file "shinrabanshou.lisp")
                 (:file "user.lisp")
                 (:file "vertex.lisp"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
