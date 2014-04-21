(in-package :shinrabanshou)

;;;;;
;;;;; 森羅
;;;;;
;;;;; object-with-id を継承しているのは id を持つから。
;;;;; 基本連番で良いかな。と。
;;;;; が、node と edge では別の name-space なので番号は被ります。
;;;;; shinra としての一意という訳ではないので node と edge に実装するほうが良いのかもしれませんね。
;;;;;
(defclass shinra (object-with-id)
  ((property :accessor property
             :initarg  :property
             :initform (make-hash-table)
             :documentation "まぁ、値ですわ。"))
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
  ((from :accessor from
         :initarg :from
         :initform nil
         :documentation "")
   (to :accessor to
       :initarg :to
       :initform nil
       :documentation ""))
  (:documentation ""))


;;;;;
;;;;; 万象
;;;;;
(defclass banshou (prevalence-system)
  ()
  (:documentation "万象：起きたこと、起きていること、その記憶。"))





;;;;;
;;;;; Test
;;;;;
;; (defun pairify (list)
;;   (when list (concatenate 'list
;;                           (list (subseq list 0 2))
;;                           (pairify (rest (rest list))))))


;; (defun make-node-test (&rest slots)
;;   "なんか動かない。。。。"
;;   (let ((slots-and-values (pairify slots)))
;;     (execute-transaction
;;      ;; ここが。。。。
;;      (tx-create-object *system* 'node slots-and-values))))



