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
           #:footprint   #:get-ghost-code  #:get-timestamp
           #:password    #:get-spell #:get-create-time #:get-update-time
           #:banshou
           #:get-id     ;; これは upanishad のやつを export しとるわけじゃけど。。。そんなもんか。
           ;; banshou
           #:make-banshou
           ;; footpring
           #:make-footprint #:mfp
           ;; deccot
           #:deccot #:add-deccot
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
           ;; ghost
           #:ghost #:note
           #:get-code #:get-name #:get-note #:get-password #:get-ghost
           #:tx-master-ghost #:tx-make-ghost
           #:master-ghost #:make-ghost
           ;; paradicate
           #:lifep #:nodep #:edgep #:existp
           ;; Relation
           #:find-r #:find-r-edge #:find-r-node
           #:get-r  #:get-r-edge  #:get-r-node
           ))
(in-package :shinrabanshou)



(defvar *master-ghost-code* "@master")
(defvar *master-ghost-name* "森羅万象 Master Ghost")
(defvar *master-ghost-password* "zaq12wsx")
(defvar *master-ghost-note* "Created by shinrabanshou")
(defvar *password-characters* "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*()_+|[]{};:,./<>?")

