(in-package :shinrabanshou)


(defgeneric existp (pool rsc)
  (:documentation "pool に rsc が存在するかを返します。
実装は node, edge のところで実装しています。"))



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




