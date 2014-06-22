(in-package :shinrabanshou)


;;;;;
;;;;; shinra 。。。 TODO:これ up に必要なんじゃ？
;;;;;
(defgeneric lifep (resource &key time)
  (:documentation"リソースが生きているかを返します。"))
(defmethod lifep ((rsc resource) &key (time (get-universal-time)))
  (let ((from (get-buddha  rsc)) (to   (get-nirvana rsc)))
    (cond ((and (null to)
                (<= (get-timestamp from) time))
           t)
          ((and (not (null to))
                (and (<= (get-timestamp from) time)
                     (<= (get-timestamp time) to)))
           t)
          (t nil))))



;;;;;
;;;;; 作る系の基礎
;;;;;
;; shinra
(defgeneric tx-make-shinra (banshou class-symbol slots-and-values)
  (:documentation ""))
(defmethod tx-make-shinra ((banshou banshou) class-symbol slots-and-values)
  ;; TODO: class-symbol は standard-class かどうかを調べる必要があるね。
  ;; TODO: class-symbol は shinra のサブクラスかどうかをチェックする必要があるね。
  ;; TODO: 全体的にタイプチェックについて調べる必要があるね。
  (tx-create-object banshou class-symbol slots-and-values))


;; 推奨しない。 いずれは廃棄予定。
(defgeneric make-shinra (banshou class-symbol slots-and-values)
  (:documentation ""))
(defmethod make-shinra ((banshou banshou) class-symbol slots-and-values)
  (execute-transaction
   (tx-make-shinra banshou class-symbol slots-and-values)))
