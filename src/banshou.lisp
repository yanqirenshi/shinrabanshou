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
    ;; index の作成
    (index-on sys 'edge '(from to type))
    sys))



;;;;;
;;;;; Permission
;;;;;
(defgeneric chek-permission (banshou user &rest param) )
(defmethod chek-permission ((sys banshou) (user user) &rest param)
  (list sys user param))



;;;;;
;;;;; getter
;;;;;
(defun class-id-indexp (symbol)
  (scan "^(\\S)+-ID-INDEX$"
        (symbol-name symbol)))

(defun class-id-rootp (symbol)
  (scan "^(\\S)+-ROOT$"
        (symbol-name symbol)))


(defgeneric class-id-list (banshou))
(defmethod class-id-list ((sys banshou))
  (remove-if (complement #'class-id-indexp)
             (hash-table-keys
              (cl-prevalence::get-root-objects sys))))

(defgeneric root-list (banshou))
(defmethod root-list ((sys banshou))
  (remove-if (complement #'class-id-rootp)
             (hash-table-keys
              (cl-prevalence::get-root-objects sys))))

(defun object-root-name (symbol)
  (cl-prevalence::get-objects-root-name symbol))


(defgeneric get-object-list (banshou symbol))
(defmethod get-object-list ((sys banshou) (class-symbol symbol))
  (get-root-object sys
                   (object-root-name class-symbol)))



(defgeneric get-at-id (banshou id)
  (:documentation ""))
(defmethod get-at-id ((sys banshou) id)
  "もっと効率良いやりかたがありそうじゃけど。。。"
  (car
   (remove nil
           (mapcar #'(lambda (index)
                       (gethash id
                                (get-root-object sys index)))
                   (class-id-list sys)))))





;;;;;
;;;;; index
;;;;;
;;;;; TODO: これも作らんとね。
;;;;;
;; create
(defgeneric create-index (banshou user class-symbol slot-list)
  (:documentation "" ))
(defmethod create-index ((sys banshou) (user user) (class-symbol symbol) (slot-list list))
  (list sys user class-symbol slot-list))


;; remove
(defgeneric remove-index (banshou user class-symbol index)
  (:documentation "" ))
(defmethod remove-index ((sys banshou) (user user) (class-symbol symbol) index)
  (list sys user class-symbol index))


;; rebuild
(defgeneric rebuild-index (banshou user class-symbol index)
  (:documentation "" ))
(defmethod rebuild-index ((sys banshou) (user user) (class-symbol symbol) index)
  (list sys user class-symbol index))




;;;;;
;;;;; printer
;;;;;
(defgeneric print-root-list (banshou &key stream))
(defmethod print-root-list ((sys banshou) &key (stream t))
  (mapcar #'(lambda (root)
              (format stream "~10a : count=~a~%"
                      root
                      (length (get-root-object sys root))))
          (root-list sys))
  sys)



;; (print-user-list *sys* (master-user *sys*))
(defgeneric print-user-list (banshou user &key stream))
(defmethod print-user-list ((sys banshou) (user user) &key (stream t))
  (mapcar #'(lambda (u)
              (format stream
                      "| ~20a | ~a~%"
                      (get-code u)
                      (get-name u)))
          (get-object-list sys 'user)))

