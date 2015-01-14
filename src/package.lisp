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
           #:footprint   #:get-user-code  #:get-timestamp
           #:password    #:get-spell #:get-create-time #:get-update-time
           #:banshou
           #:get-id     ;; これは upanishad のやつを export しとるわけじゃけど。。。そんなもんか。
           ;; banshou
           #:make-banshou
           ;; footpring
           #:make-footprint #:mfp
           ;; banshou
           #:get-at-id
           ;; buddha-nature
           #:buddha-nature    #:get-buddha #:get-nirvana
           ;; node
           #:node #:tx-delete-node #:tx-make-node #:make-node
           ;; edge
           #:edge #:tx-delete-edge #:tx-make-edge #:make-edge
           #:get-from-node    #:get-to-node
           #:get-from-node-id #:get-from-node-class
           #:get-to-node-id   #:get-to-node-class
           #:get-edge-type
           #:tx-change-node
           #:tx-change-type
           ;; user
           #:user #:note
           #:get-code #:get-name #:get-note #:get-password #:get-user
           #:tx-master-user #:tx-make-user
           #:master-user #:make-user
           ;; paradicate
           #:lifep #:nodep #:edgep #:existp
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

