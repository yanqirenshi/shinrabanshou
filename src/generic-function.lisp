;;;;;
;;;;; 森羅万象の総称関数
;;;;;
;;;;; Contents
;;;;;   1. 森羅
;;;;;   2. Node
;;;;;   3. Edge
;;;;;   4. Finder
;;;;;   5. User
;;;;;

(in-package :shinrabanshou)

;;;;;
;;;;; 1. 森羅
;;;;;
(defgeneric existp (pool rsc)
  (:documentation "pool に rsc が存在するかを返します。
実装は node, edge のところで実装しています。"))


(defgeneric tx-make-shinra (banshou class-symbol slots-and-values)
  (:documentation ""))


(defgeneric make-shinra (banshou class-symbol slots-and-values)
  (:documentation ""))



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


(defgeneric class-id-list (banshou)
  (:documentation "banshouに登録されているクラスの一覧(list)を返します。"))


(defgeneric root-list (banshou)
  (:documentation "banshouに登録されているルートオブジェクトの一覧(list)を返します。"))


(defgeneric get-object-list (banshou symbol)
  (:documentation "banshouで管理されている symbolクラスのオブジェクトの一覧(list)を返します。"))


(defgeneric get-at-id (banshou id)
  (:documentation ""))


;; index
(defgeneric create-index (banshou user class-symbol slot-list)
  (:documentation "" ))


(defgeneric remove-index (banshou user class-symbol index)
  (:documentation "" ))


(defgeneric rebuild-index (banshou user class-symbol index)
  (:documentation "" ))


;; printer
(defgeneric print-root-list (banshou &key stream)
  (:documentation ""))


(defgeneric print-user-list (banshou user &key stream)
  (:documentation ""))



;;;;;
;;;;; 2. Node
;;;;;
;; 述語
(defgeneric nodep (obj)
  (:documentation "symbolで指定された class が node のサブクラスかどうかを返す。
-----------
TODO:でも、こんなんでエエんじゃろうか。。。。ほかにスマートな方法がありそうなんじゃけど。。。"))


;; 作成
(defgeneric tx-make-node (banshou class-symbol &optional slots-and-values)
  (:documentation ""))


(defgeneric make-node (banshou class-symbol &optional slots-and-values)
  (:documentation ""))


(defgeneric make-node (banshou class-symbol &optional slots-and-values)
  (:documentation ""))


;; 削除
(defgeneric tx-delete-node (banshou node)
  (:documentation "Nodeを削除します。
現在、関係を持っている Node は削除できないようにしています。
2014/7/26
なんじゃあるんかいね。
でもこれ、関係があったらそれらをq返すようにしたほうが良さそうじゃね。
どんとなんあるか判断できるもんね。
"))



;;;;;
;;;;; 3. Edge
;;;;;
;; 述語
(defgeneric edgep (obj)
  (:documentation "symbolで指定された class が edge のサブクラスかどうかを返す。
でも、こんなんでエエんじゃろうか。。。。
ほかにスマートな方法がありそうなんじゃけど。。。"))


;; 削除
(defgeneric tx-delete-edge (banshou edge)
  (:documentation "Nodeを削除します。"))


;; 作成
(defgeneric tx-make-edge (banshou class-symbol from to type &optional slots)
  (:documentation "edge を作成します。"))


(defgeneric make-edge (banshou class-symbol from to type &optional slots)
  (:documentation "tx-make-edgeをトランザクション実行します。"))


;; accsessor
(defgeneric get-from-node (banshou edge)
  (:documentation "edge のfromノードを取得します。
fromノードのオブジェクトを返します。"))


(defgeneric get-to-node (banshou edge)
  (:documentation "edge のtoノードを取得します。
toノードのオブジェクトを返します。"))


;; (defun tx-change-from-node (pool edge node)


(defgeneric tx-change-node (pool edge type node)
  (:documentation "edge に関連付いているノードを変更します。
type に fromノードか toノードかを指定します。"))


(defgeneric tx-change-type (pool edge type)
  (:documentation ""))



;;;;;
;;;;; 4. Finder
;;;;;
(defgeneric get-r (pool edge-class-symbol start start-node end-node rtype)
  (:documentation ""))


(defgeneric get-r-edge (pool edge-class-symbol start start-node end-node rtype)
  (:documentation ""))


(defgeneric get-r-node (pool edge-class-symbol start start-node end-node rtype)
  (:documentation ""))


(defgeneric find-r-edge (pool edge-class-symbol start node)
  (:documentation ""))


(defgeneric find-r (pool edge-class-symbol start node)
  (:documentation ""))


(defgeneric find-r-node (pool edge-class-symbol start node)
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

