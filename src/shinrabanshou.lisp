#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

森羅万象
- 森羅 : 数多く並びつらなること。また，そのもの。
- 万象 : さまざまの形。あらゆる事物。

命名のキルラキルに影響を受けたんでしょうね。
あと、ヒンドゥー語から引っ張ってくるのにも疲れたんでしょうね。
|#

(in-package :cl-user)
(defpackage shinrabanshou
  (:use :cl  :cl-prevalence)
  (:nicknames :shinra))
(in-package :shinrabanshou)

;;; class
(defclass shinra ()
  ((id :accessor id
       :initarg :id
       :initform nil
       :documentation "一意のキーという訳です。
基本連番で良いかな。と。
が、node と edge では別の name-space なので番号は被ります。
shinra としての一意という訳ではないので node と edge に実装するほうが良いのかもしれませんね。")
   (property :accessor property
             :initarg  :property
             :initform (make-hash-table)
             :documentation "まぁ、値ですわ。"))
  (:documentation "森羅 : 数多く並びつらなること。また，そのもの。
この世を構成するもの。的な意味で Node と Edge の親クラスとしては良い感じかな。と。
まぁ分かり難いっちゃぁそうなんですが、ヒンドゥー語からチョイスするよりは日本人には優しいかな。と。
shinra で構成される物が banshou である。と。
そう言った感じなんじゃなかろうか。と。
"))


(defclass banshou (prevalence-system) ()
  (:documentation "万象 : さまざまの形。あらゆる事物。"))

(defclass node (shinra) ())

(defclass edge (shinra)
  ((node-id-from :accessor node-id-from
                 :initarg :node-id-from
                 :initform nil
                 :documentation "")
   (node-id-to :accessor node-id-to
               :initarg :node-id-to
               :initform nil
               :documentation "")))


(defvar *datastore* #P"/home/atman/appl/shinra/")
(defvar *system* (make-prevalence-system *datastore* :prevalence-system-class 'banshou))

(defun system-init (system)
  (when system
    (setf (get-root-object system :nodes) (make-hash-table))
    (setf (get-root-object system :edges) (make-hash-table))
    (setf (get-root-object system :node-id-counter) 0)
    (setf (get-root-object system :edge-id-counter) 0)
    system))

(defmethod property-set ((obj shinra) key val)
  (setf (gethash key (property obj)) val))

(defmethod properties-set ((obj shinra) properties)
  (mapcar #'(lambda (x)
              (property-set obj (car x) (cdr x)))
          properties)
  obj)

(defmethod property-get ((obj shinra) key)
  (gethash key (property obj)))


;; ex) (make-node :properties '((:id . 1) (:name . "hanage")))
(defun make-node (&key (properties nil))
  (properties-set (make-instance 'node) properties))

(defmethod get-node ((system banshou) id)
  (gethash id (get-root-object *system* :nodes)))

(defmethod add-node ((system banshou) (node node))
  (let ((newid (incf (get-root-object system :node-id-counter))))
    (setf (id node) newid)
    (setf (gethash newid (get-root-object system :nodes))
          node))
  (values system node))

(defmethod add-edge ((system banshou) (from node) (to node))
  (let ((newid (incf (get-root-object system :edge-id-counter)))
        (edge  (make-instance 'edge :node-id-from (id from) :node-id-to (id to))))
    (setf (id edge) newid)
    (setf (gethash newid (get-root-object system :edges))
          edge)
    (values system edge)))

(defmethod add-edge ((system banshou) (from-id number) (to-id number))
  (let ((from (get-node system from-id))
        (to   (get-node system to-id)))
    (unless from (error "from が存在しないよ。id=~a" from-id))
    (unless to   (error "to が存在しないよ。id=~a"   to-id))
    (add-edge system from to)))
