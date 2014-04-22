#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

shinra(森羅)
------------
Node と Edge がこれに当ります。


banshou(万象)
-------------
Node と Edge のプール 及び、それらの永続化がこれに当たります。

|#

(in-package :cl-user)
(defpackage shinrabanshou
  (:use :cl  :cl-prevalence)
  (:nicknames :shinra)
  (:export #:property
           ;;
           #:node
           ;;
           #:edge
           #:from-node
           #:to-node
           ;;
           #:banshou
           #:find-node
           #:delete-node
           #:make-node
           #:make-edge))
(in-package :shinrabanshou)


