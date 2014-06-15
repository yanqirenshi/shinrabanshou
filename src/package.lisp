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
  (:use :cl :alexandria :cl-ppcre :cl+ :upanishad)
  (:nicknames :shinra)
  (:export #:property
           ;;
           ;;
           #:footprint   #:get-user-code  #:get-timestamp
           #:password    #:get-spell #:get-create-time #:get-update-time
           #:banshou
           #:get-id     ;; これは upanishad のやつを export しとるわけじゃけど。。。そんなもんか。
           #:node
           ;; edge
           #:edge
           #:get-from-node    #:get-to-node
           #:get-from-node-id #:get-from-node-class
           #:get-to-node-id   #:get-to-node-class
           #:get-edge-type
           ;; resource
           #:resource    #:get-buddha #:get-nirvana
           ;; user
           #:user #:note
           #:get-code #:get-name #:get-note #:get-password #:get-user
           #:master-user #:make-user
           ;; banshou
           #:make-banshou
           ;; footpring
           #:make-footprint
           ;; deccot
           #:deccot #:add-deccot
           ;; banshou
           #:get-at-id
           #:find-node   ;; これは不要じゃろう。若気の至り関数。
           #:delete-node
           #:tx-make-node #:make-node
           #:tx-make-edge #:make-edge
           ;; paradicate
           #:lifep #:nodep #:edgep
           ;; Relation
           #:find-r #:find-r-edge #:find-r-node
           #:get-r  #:get-r-edge  #:get-r-node
           ))
(in-package :shinrabanshou)



(defvar *master-user-code* "@master")
(defvar *master-user-name* "森羅万象 Master User")
(defvar *master-user-password* "zaq12wsx")
(defvar *master-user-note* "Created by shinrabanshou")
(defvar *password-characters* "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*()_+|[]{};:,./<>?")

