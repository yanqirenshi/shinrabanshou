(in-package :shinrabanshou)


;;;;
;;;;
;;;;
(defgeneric existp (pool rsc)
  (:documentation "pool に rsc が存在するかを返します。
実装は node, edge のところで実装しています。"))



;;;;;
;;;;; shinra 。。。 TODO:これ up に必要なんじゃ？
;;;;;
(defgeneric lifep (buddha-nature &key time)
  (:documentation"リソースが生きているかを返します。")
  (:method ((rsc buddha-nature) &key (time (get-universal-time)))
    (let ((from (get-buddha  rsc)) (to   (get-nirvana rsc)))
      (cond ((and (null to)
                  (<= (get-timestamp from) time))
             t)
            ((and (not (null to))
                  (and (<= (get-timestamp from) time)
                       (<= (get-timestamp time) to)))
             t)
            (t nil)))))



;;;;;
;;;;; 作る系の基礎
;;;;;
(defgeneric tx-make-shinra (banshou class-symbol slots-and-values)
  (:documentation "")
  (:method ((banshou banshou) class-symbol slots-and-values)
    ;; TODO: class-symbol は standard-class かどうかを調べる必要があるね。
    ;; TODO: class-symbol は shinra のサブクラスかどうかをチェックする必要があるね。
    ;; TODO: 全体的にタイプチェックについて調べる必要があるね。
    (tx-create-object banshou class-symbol slots-and-values)))


(defgeneric make-shinra (banshou class-symbol slots-and-values)
  (:documentation "")
  (:method ((banshou banshou) class-symbol slots-and-values)
    (execute-transaction
     (tx-make-shinra banshou class-symbol slots-and-values))))




