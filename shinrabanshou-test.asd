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
                 (:file "banshou")
                 (:file "communication")
                 (:file "edge")
                 (:file "finder")
                 (:file "user")
                 (:file "vertex"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
