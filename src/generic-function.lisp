;;;;;
;;;;; 森羅万象の総称関数
;;;;;
;;;;; Contents
;;;;;   1. 森羅
;;;;;   2. Vertex
;;;;;   3. Edge
;;;;;   4. Finder
;;;;;   5. User
;;;;;

(in-package :shinrabanshou)

;;;;;
;;;;; 1. 森羅
;;;;;
(defgeneric existp (graph rsc)
  (:documentation "graph に rsc が存在するかを返します。
実装は vertex, edge のところで実装しています。"))


;;;;;
;;;;; 2. 万象
;;;;;
(defgeneric make-banshou (class-symbol data-stor)
  (:documentation "banshou を生成します。
banshou のインスタンスを生成する以外に以下の処理も実行します。
 (1) id-counter が生成されていない場合は生成する。
 (2) master user が存在しない場合は生成する。
 (3) edge の index を作成する。
"))


(defgeneric chek-permission (banshou user &rest param)
  (:documentation "userの権限をチェックします。
-----------
TODO: 作成(停止)中です。
"))


;; index
(defgeneric create-index (banshou user class-symbol slot-list)
  (:documentation "" ))


(defgeneric remove-index (banshou user class-symbol index)
  (:documentation "" ))


(defgeneric rebuild-index (banshou user class-symbol index)
  (:documentation "" ))


;; printer
(defgeneric print-user-list (banshou user &key stream)
  (:documentation ""))



;;;;;
;;;;; 2. Vertex
;;;;;
;; 述語
(defgeneric vertexp (obj)
  (:documentation "symbolで指定された class が vertex のサブクラスかどうかを返す。
-----------
TODO:でも、こんなんでエエんじゃろうか。。。。ほかにスマートな方法がありそうなんじゃけど。。。"))


;; 作成
(defgeneric tx-make-vertex (graph class-symbol &optional slots-and-values)
  (:documentation ""))

(defgeneric make-vertex (graph class-symbol &optional slots-and-values)
  (:documentation ""))


;; 削除
(defgeneric tx-delete-vertex (graph vertex)
  (:documentation "Vertexを削除します。
現在、関係を持っている Vertex は削除できないようにしています。
2014/7/26
なんじゃあるんかいね。
でもこれ、関係があったらそれらをq返すようにしたほうが良さそうじゃね。
どんとなんあるか判断できるもんね。
"))


(defgeneric delete-vertex (graph vertex)
  (:documentation ""))


;;;;;
;;;;; 3. Edge
;;;;;
;; 述語
(defgeneric edgep (obj)
  (:documentation "symbolで指定された class が edge のサブクラスかどうかを返す。
でも、こんなんでエエんじゃろうか。。。。
ほかにスマートな方法がありそうなんじゃけど。。。"))


;; 作成
(defgeneric tx-make-edge (graph class-symbol from to type &optional slots)
  (:documentation "edge を作成します。"))

(defgeneric make-edge (graph class-symbol from to type &optional slots)
  (:documentation "tx-make-edgeをトランザクション実行します。"))


;; 削除
(defgeneric tx-delete-edge (graph edge)
  (:documentation "Vertexを削除します。"))

(defgeneric delete-edge (graph edge)
  (:documentation "Vertexを削除します。"))


;; accsessor
(defgeneric get-from-vertex (graph edge)
  (:documentation "edge のfromノードを取得します。
fromノードのオブジェクトを返します。"))


(defgeneric get-to-vertex (graph edge)
  (:documentation "edge のtoノードを取得します。
toノードのオブジェクトを返します。"))


;; (defun tx-change-from-vertex (graph edge vertex)


(defgeneric tx-change-vertex (graph edge type vertex)
  (:documentation "edge に関連付いているノードを変更します。
type に fromノードか toノードかを指定します。"))


(defgeneric tx-change-type (graph edge type)
  (:documentation ""))



;;;;;
;;;;; 4. Finder
;;;;;
(defgeneric get-r (graph edge-class-symbol start start-vertex end-vertex rtype)
  (:documentation ""))


(defgeneric get-r-edge (graph edge-class-symbol start start-vertex end-vertex rtype)
  (:documentation ""))


(defgeneric get-r-vertex (graph edge-class-symbol start start-vertex end-vertex rtype)
  (:documentation ""))


(defgeneric find-r-edge (graph edge-class-symbol start vertex &key edge-type vertex-class)
  (:documentation ""))


(defgeneric find-r (graph edge-class-symbol start vertex &key edge-type vertex-class)
  (:documentation ""))


(defgeneric find-r-vertex (graph edge-class-symbol start vertex &key edge-type vertex-class)
  (:documentation ""))



;;;;;
;;;;; 5. User
;;;;;
(defgeneric get-user (banshou code)
  (:documentation ""))


(defgeneric make-user (banshou creater code &key name password timestamp)
  (:documentation ""))


(defgeneric tx-make-user (banshou creater code &key name password timestamp)
  (:documentation ""))


(defgeneric master-user (banshou)
  (:documentation ""))


(defgeneric make-master-user (banshou &key code name password timestamp)
  (:documentation ""))


(defgeneric tx-make-master-user (banshou &key code name password timestamp)
  (:documentation ""))





#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#

