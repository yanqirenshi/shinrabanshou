;;;;;
;;;;; Contents
;;;;;   none...
;;;;;

(in-package :shinrabanshou)


(defmethod tx-make-shinra ((banshou banshou) class-symbol slots-and-values)
  ;; TODO: class-symbol は standard-class かどうかを調べる必要があるね。
  ;; TODO: class-symbol は shinra のサブクラスかどうかをチェックする必要があるね。
  ;; TODO: 全体的にタイプチェックについて調べる必要があるね。
  (tx-create-object banshou class-symbol slots-and-values))



(defmethod make-shinra ((banshou banshou) class-symbol slots-and-values)
  (execute-transaction
   (tx-make-shinra banshou class-symbol slots-and-values)))





#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#

