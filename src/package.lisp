;;;;;
;;;;; shinra(森羅)  : Node と Edge がこれに当ります。
;;;;; banshou(万象) : Node と Edge のプール 及び、それらの永続化がこれに当たります。
;;;;;
;;;;; Contents
;;;;;   1. Package
;;;;;   2. Variable
;;;;;

(in-package :cl-user)

;;;;;
;;;;; 1. Package
;;;;;
(defpackage shinrabanshou
  (:use :cl :alexandria :cl-ppcre :cl+ :upanishad)
  (:nicknames :shinra)
  (:export #:property
           #:banshou
           #:get-id     ;; これは upanishad のやつを export しとるわけじゃけど。。。そんなもんか。
           ;; banshou
           #:make-banshou
           ;; node
           #:vertex #:tx-delete-node #:tx-make-node #:make-node
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



;;;;;
;;;;; 2. Variable
;;;;;
(defvar *master-user-code* "@master")
(defvar *master-user-name* "森羅万象 Master User")
(defvar *master-user-password* "zaq12wsx")
(defvar *master-user-note* "Created by shinrabanshou")






#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#
