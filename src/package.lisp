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
           #:get-from-node
           #:get-to-node
           #:get-edge-type
           ;;
           #:banshou
           #:make-banshou
           ;;
           #:footprint
           #:get-user-code
           #:get-timestamp
           #:make-footprint
           ;;
           #:password
           #:get-spell
           #:get-create-time
           #:get-update-time
           ;;
           #:resource
           #:get-buddha
           #:get-nirvana
           ;;
           #:user
           #:get-code
           #:get-name
           #:get-note
           #:get-password
           ;;
           #:get-at-id
           #:find-node
           #:delete-node
           #:make-node
           #:make-edge))
(in-package :shinrabanshou)


