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
  (:use :cl :alexandria :cl-ppcre :cl-prevalence )
  (:nicknames :shinra)
  (:export #:property
           ;;
           ;;
           #:footprint   #:get-user-code  #:get-timestamp
           #:password    #:get-spell #:get-create-time #:get-update-time
           #:banshou
           #:node
           #:edge        #:get-from-node #:get-to-node #:get-edge-type
           #:resource    #:get-buddha #:get-nirvana
           #:lifep
           #:nodep
           #:edgep
           #:user        #:get-code #:get-name #:get-note #:get-password #:get-user
           #:master-user
           #:deccot
           ;; banshou
           #:make-banshou
           ;; footpring
           #:make-footprint
           ;; deccot
           #:add-deccot
           ;; banshou
           #:get-at-id
           #:find-node
           #:delete-node
           #:make-node
           #:make-edge))
(in-package :shinrabanshou)



(defvar *master-user-code* "@master")
(defvar *master-user-name* "森羅万象 Master User")
(defvar *master-user-password* "zaq12wsx")
(defvar *master-user-note* "Created by shinrabanshou")
(defvar *password-characters* "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*()_+|[]{};:,./<>?")

