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
  (:use :cl :alexandria :cl-ppcre :upanishad)
  (:nicknames :shinra)
  (:import-from :world2world
                :error*
                :format*)
  (:export #:property
           #:banshou
           #:%id ;; これは upanishad のやつを export しとるわけじゃけど。。。そんなもんか。
           ;; banshou
           #:make-banshou
           ;; vertex
           #:shin
           #:tx-make-vertex   #:make-vertex
           #:tx-delete-vertex #:delete-vertex
           ;; edge
           #:ra
           #:tx-delete-edge #:delete-edge
           #:tx-make-edge   #:make-edge
           #:get-from-vertex    #:get-to-vertex
           #:from-id #:from-class
           #:to-id   #:to-class
           #:edge-type
           #:tx-change-vertex
           #:tx-change-type
           ;; user
           #:user #:note
           #:code #:name #:password #:get-user
           #:tx-master-user #:master-user
           #:tx-make-user   #:make-user
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



;;;;;
;;;;; 3. Utility
;;;;;
;; #\U+3000 : 全角スペース
;; #\Return : ^M
;; #\U+FEFF : なんだったっけ？ sbcl では NG?
(defun trim-string (seq &key (char-bag '(#\Space #\Tab #\Newline #\Return)))
  "cl:string-trim のラッパーです。
char-bag を指定するのが面倒なのでデフォルトでセットするようにしました。
あと cl:string-trim は nil を入力にすると \"NIL\" を返すので nil を返すようにしています。
"
  (when seq
    (string-trim char-bag seq)))
