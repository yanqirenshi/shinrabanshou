;;;;;
;;;;; 神羅纐纈のクラス図です。
;;;;;
;;;;; Contents
;;;;;   1. クラス図
;;;;;   2. 森羅
;;;;;   3. 万象
;;;;;   4. ユーザー/権限
;;;;;

;;;
;;; 1. クラス図
;;;
;;;   <<upanishad>>
;;;         +--------+               +--------+
;;;         | meme   |               | pool   |
;;;         |========|               |========|
;;;         |--------|               |--------|
;;;         +--------+               +--------+
;;;            ^                        ^
;;;            |                        |
;;;   - - - - -|- - - - - - - - - - - - | - - - - - - - - - - - - - - - -
;;;            |                        |             <<shinrabanshou>>
;;;         +--------+               +---------+
;;;         | shinra |               | banshou |
;;;         |========|               |=========|      +--------+
;;;         |--------|               |---------|      | naming |
;;;         +--------+               +---------+      |========|
;;;            ^                                      |a code  |
;;;            |                                      |a name  |
;;;    +----------------+                             |--------|
;;;    |                |                             +--------+
;;; +--------+   +-------------+                          ^
;;; | vertex |   | vertex      |                          |
;;; |========|   |=============|                      +-----------+
;;; |--------|   |a from-id    |                      | user      |
;;; +--------+   |a from-class |                      |===========|
;;;              |a to-id      |                      |a password |
;;;              |a to-class   |                      |-----------|
;;;              |a type       |                      +-----------+
;;;              |-------------|
;;;              +-------------+
;;;

(in-package :shinrabanshou)

;;;;;
;;;;; 2. 森羅
;;;;;
(defclass shinra (meme)
  ()
  (:documentation "Vertex と Edge の親クラス。
森羅 : 数多く並びつらなること。また，そのもの。
この世を構成するもの。的な意味で Vertex と Edge の親クラスとしては良い感じかな。と。
まぁ分かり難いっちゃぁそうなんですが、ヒンドゥー語からチョイスするよりは日本人には優しいかな。と。
shinra で構成される物が banshou である。と。
そう言った感じなんじゃなかろうか。と。
"))


(defclass vertex (shinra)
  ()
  (:documentation ""))



(defclass edge (shinra)
  ((from-id :documentation ""
            :accessor from-id
            :initarg :from-id
            :initform nil)
   (from-class :documentation ""
               :accessor from-class
               :initarg :from-class
               :initform nil)
   (to-id :documentation ""
          :accessor to-id
          :initarg :to-id
          :initform nil)
   (to-class :documentation ""
             :accessor to-class
             :initarg :to-class
             :initform nil)
   (edge-type :documentation ""
              :accessor edge-type
              :initarg :edge-type
              :initform nil))
  (:documentation ""))



;;;;;
;;;;;
;;;;; 3. 万象
;;;;;
;;;;;
(defclass banshou (pool)
  ()
  (:documentation "万象：起きたこと、起きていること、その記憶。
upanishad の pool を継承しています。
まぁ、今んところそのままで名前を変えただけですが。"))




;;;;;
;;;;; 4. ユーザー/権限
;;;;;
(defclass naming ()
  ((code :documentation ""
         :accessor get-code
         :initarg :code
         :initform nil)
   (name :documentation ""
         :accessor get-name
         :initarg :name
         :initform nil)))


(defclass user (vertex naming)
  ((password :documentation ""
             :accessor get-password
             :initarg :password
             :initform nil))
  (:documentation "ユーザーのクラスです。"))


(defclass force (vertex naming)
  ()
  (:documentation "権限のクラスです。"))




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#

