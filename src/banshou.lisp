(in-package :shinrabanshou)


;;;;;
;;;;; 万象
;;;;;
(defgeneric make-banshou (class-symbol data-stor) (:documentation ""))
(defmethod make-banshou ((class-symbol symbol) data-stor)
  (let ((sys (make-prevalence-system data-stor :prevalence-system-class class-symbol)))
    ;; id-counter が生成されていない場合は生成する。
    (when (null (get-root-object sys :id-counter))
      (execute-transaction (tx-create-id-counter sys)))
    ;; master user が存在しない場合は生成する。
    (when (null (master-user sys))
      (make-master-user sys))
    ;; TODO: edege の from to type に INDEX を貼るよー INDEX-ONね。
    ;;       でも index を貼るのに安全に貼れるような関数が必要じゃね。
    ;;       ここで作成したようなんは簡単に削除出来んようにコントロールせんといけんねぇ。
    sys))


(defun class-id-ndexp (symbol)
  (scan "^(\\S)+-ID-INDEX"
        (symbol-name symbol)))


(defmethod class-id-list ((sys banshou))
  (remove-if (complement #'class-id-ndexp)
             (hash-table-keys
              (cl-prevalence::get-root-objects sys))))


(defmethod get-object-list ((sys banshou) (class-symbol symbol))
  (get-root-object sys
                   (cl-prevalence::get-objects-root-name class-symbol)))
