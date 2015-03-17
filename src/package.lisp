;;;;;
;;;;; shinra(森羅)  : Vertex と Edge がこれに当ります。
;;;;; banshou(万象) : Vertex と Edge のプール 及び、それらの永続化がこれに当たります。
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
           ;; vertex
           #:vertex #:tx-delete-vertex #:tx-make-vertex #:make-vertex
           ;; edge
           #:edge #:tx-delete-edge #:tx-make-edge #:make-edge
           #:get-from-vertex    #:get-to-vertex
           #:get-from-vertex-id #:get-from-vertex-class
           #:get-to-vertex-id   #:get-to-vertex-class
           #:get-edge-type
           #:tx-change-vertex
           #:tx-change-type
           ;; user
           #:user #:note
           #:get-code #:get-name #:get-note #:get-password #:get-user
           #:tx-master-user #:tx-make-user
           #:master-user #:make-user
           ;; paradicate
           #:lifep #:vertexp #:edgep #:existp
           ;; Relation
           #:find-r #:find-r-edge #:find-r-vertex
           #:get-r  #:get-r-edge  #:get-r-vertex
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
