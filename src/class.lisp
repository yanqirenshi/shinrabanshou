;;;;;
;;;;; 神羅纐纈のクラス図です。
;;;;;
;;;;; Contents
;;;;;   1. クラス図
;;;;;   2. 森羅
;;;;;   3. 万象
;;;;;   4. ユーザー/権限
;;;;;

(in-package :shinrabanshou)

;;;
;;; 1. クラス図
;;;
;;;         +--------+               +--------+
;;;         | meme   |               | pool   |
;;;         |========|               |========|
;;;         |--------|               |--------|
;;;         +--------+               +--------+
;;;            ^                        ^
;;;            |                        |             <<upanishad>>
;;;   - - - - -|- - - - - - - - - - - - | - - - - - - - - - - - - - - - -+
;;;            |                        |             <<shinrabanshou>>  |
;;;    +----------------+               |
;;;    |                |               |                                |
;;; +--------+   +-------------+     +---------+     .................
;;; | shin   |   | ra          |     | banshou |     :<Utility class>:   |
;;; |========|   |=============|     |=========|     :               :
;;; |--------|   |a from-id    |     |---------|     : +--------+    :   |
;;; +--------+   |a from-class |     +---------+     : | naming |    :
;;; super class  |a to-id      |     super class     : |========|    :   |
;;; or vertex    |a to-class   |     or graph        : |a code  |    :
;;;              |a type       |                     : |a name  |    :   |
;;;              |-------------|                     : |--------|    :
;;;              +-------------+                     : +--------+    :   |
;;;              super class                         :     ^         :
;;;              or edge                             :.....|.........:   |
;;;                                                        |
;;;                           .............................|..........   |
;;;                           : <Security>                 |         :
;;;                           : +-----------+          +-----------+ :   |  <<takajin84key>>
;;;                           : | force     |<--:have--| user      | :
;;;                           : |===========|          |===========| :   |   +----------+
;;;                           : |-----------|          |a password |<<-------| password |
;;;                           : +-----------+          |-----------| :   |   +----------+
;;;                           :                        +-----------+ :
;;;                           :......................................:   |
;;;
;;;

;;;;;
;;;;; 2. 森羅
;;;;;
(defclass shin (meme)
  ()
  (:documentation ""))



(defclass ra (meme)
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
         :accessor code
         :initarg :code
         :initform nil)
   (name :documentation ""
         :accessor name
         :initarg :name
         :initform nil)))


(defclass user (shin naming)
  ((password :documentation ""
             :accessor password
             :initarg :password
             :initform nil))
  (:documentation "ユーザーのクラスです。"))


(defclass force (shin naming)
  ()
  (:documentation "権限のクラスです。"))
