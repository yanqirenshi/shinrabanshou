(in-package :shinrabanshou)

#|

森羅万象 を 構成する クラス。

object-with-id を継承しているのは id を持つから。
基本連番で良いかな。と。
が、node と edge では別の name-space なので番号は被ります。
shinra としての一意という訳ではないので node と edge に実装するほうが良いのかもしれませんね。

|#


;;;;;
;;;;; utility class
;;;;;
(defclass footprint ()
  ((user-code :accessor get-user-code :initarg :user-code :initform nil)
   (timestamp :accessor get-timestamp :initarg :timestamp :initform nil)))

(defun make-footprint (user-code &key (timestamp (get-universal-time)))
  (make-instance 'footprint :user-code user-code :timestamp timestamp))


(defclass mutable ()
  ((create-time :documentation ""
                :accessor get-create-time :initarg :create-time :initform nil)))

(defclass immutable (mutable)
  ((update-time :documentation ""
                :accessor get-update-time :initarg :update-time :initform nil)))

(defclass password (immutable)
  ((spell       :documentation ""
                :accessor get-spell       :initarg :spell       :initform nil)))


;; <参考>
;; http://ja.wikipedia.org/wiki/%E3%83%A1%E3%83%BC%E3%83%AB%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9
(defclass mail-address ()
  ((local       :documentation ""
                :accessor get-local       :initarg :local       :initform nil)
   (domain      :documentation ""
                :accessor get-domain       :initarg :domain       :initform nil)))



;;;;;
;;;;;
;;;;; 森羅
;;;;;
;;;;;
(defclass shinra (atman)
  ((create-time :documentation ""
                :accessor get-create-time :initarg :create-time :initform nil)
   (update-time :documentation ""
                :accessor get-update-time :initarg :update-time :initform nil))
  (:documentation "森羅 : 数多く並びつらなること。また，そのもの。
この世を構成するもの。的な意味で Node と Edge の親クラスとしては良い感じかな。と。
まぁ分かり難いっちゃぁそうなんですが、ヒンドゥー語からチョイスするよりは日本人には優しいかな。と。
shinra で構成される物が banshou である。と。
そう言った感じなんじゃなかろうか。と。
"))


(defclass node (shinra)
  ()
  (:documentation ""))



(defclass edge (shinra)
  ((from :accessor get-from-node-id
         :initarg :from
         :initform nil
         :documentation "")
   (from-class :accessor get-from-node-class
               :initarg :from-class
               :initform nil
               :documentation "")
   (to :accessor get-to-node-id
       :initarg :to
       :initform nil
       :documentation "")
   (to-class :accessor get-to-node-class
             :initarg :to-class
             :initform nil
             :documentation "")
   (type :accessor get-edge-type
         :initarg :type
         :initform nil
         :documentation ""))
  (:documentation ""))



;;;;;
;;;;;
;;;;; 万象
;;;;;
;;;;;
(defclass banshou (pool)
  ()
  (:documentation "万象：起きたこと、起きていること、その記憶。
cl-prevalence の prevalence-system を継承しています。
まぁ、今んところそのままで名前を変えただけですが。
こう言うのってわかりニクイんですけど、何か好きなんですよね。"))




;;;;;
;;;;; shinra resource
;;;;;
(defclass resource (node)
  ((buddha :documentation ""
           :accessor get-buddha
           :initarg :buddha
           :initform nil)
   (nirvana :documentation ""
            :accessor get-nirvana
            :initarg :nirvana
            :initform nil)
   (note :documentation ""
         :accessor get-note
         :initarg :note
         :initform nil)))



(defclass force (resource)
  ((name :documentation ""
         :accessor get-name
         :initarg :name
         :initform nil)
   (password :documentation ""
             :accessor get-password
             :initarg :password
             :initform nil))
  (:documentation ""))




(defclass user (resource)
  ((code :documentation ""
         :accessor get-code
         :initarg :code
         :initform nil)
   (name :documentation ""
         :accessor get-name
         :initarg :name
         :initform nil)
   (password :documentation ""
             :accessor get-password
             :initarg :password
             :initform nil)
   (forces   :documentation ""
             :accessor get-forces
             :initarg :forces
             :initform nil))
  (:documentation ""))




(defclass deccot (resource)
  ((name :documentation ""
         :accessor get-name
         :initarg :name
         :initform nil)
   (forces   :documentation ""
             :accessor get-forces
             :initarg :forces
             :initform nil)))
