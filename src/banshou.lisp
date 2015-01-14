(in-package :shinrabanshou)


;;;;;
;;;;; 万象
;;;;;
(defgeneric make-banshou (class-symbol data-stor)
  (:documentation "banshou を生成します。

banshou のインスタンスを生成する以外に以下の処理も実行します。
 (1) id-counter が生成されていない場合は生成する。
 (2) master ghost が存在しない場合は生成する。
 (3) edge の index を作成する。
")
  (:method ((class-symbol symbol) data-stor)
    (let ((pool (make-pool data-stor :pool-class class-symbol)))
      (when (null (get-root-object pool :id-counter))
        (execute-transaction (tx-create-id-counter pool)))
      (when (null (master-ghost pool))
        (execute-transaction (tx-make-master-ghost pool)))
      (index-on pool 'edge '(from to type))
      pool)))



;;;;;
;;;;; Permission
;;;;;
(defgeneric chek-permission (banshou ghost &rest param)
  (:documentation "ghostの権限をチェックします。
-----------
TODO: 作成(停止)中です。
")
  (:method ((pool banshou) (ghost ghost) &rest param)
    (list pool ghost param)))



;;;;;
;;;;; getter
;;;;;
(defun class-id-indexp (symbol)
  (scan "^(\\S)+-ID-INDEX$"
        (symbol-name symbol)))


(defun class-id-rootp (symbol)
  (scan "^(\\S)+-ROOT$"
        (symbol-name symbol)))


(defgeneric class-id-list (banshou)
  (:documentation "banshouに登録されているクラスの一覧(list)を返します。")
  (:method ((pool banshou))
    (remove-if (complement #'class-id-indexp)
               (hash-table-keys
                (upanishad::get-root-objects pool)))))


(defgeneric root-list (banshou)
  (:documentation "banshouに登録されているルートオブジェクトの一覧(list)を返します。")
  (:method ((pool banshou))
    (remove-if (complement #'class-id-rootp)
               (hash-table-keys
                (upanishad::get-root-objects pool)))))


(defun object-root-name (symbol)
  (upanishad::get-objects-root-name symbol))


(defgeneric get-object-list (banshou symbol)
  (:documentation "banshouで管理されている symbolクラスのオブジェクトの一覧(list)を返します。")
  (:method ((pool banshou) (class-symbol symbol))
    (get-root-object pool
                     (object-root-name class-symbol))))



(defgeneric get-at-id (banshou id)
  (:documentation "")
  (:method ((pool banshou) id)
    "もっと効率良いやりかたがありそうじゃけど。。。"
    (car
     (remove nil
             (mapcar #'(lambda (index)
                         (gethash id
                                  (get-root-object pool index)))
                     (class-id-list pool))))))





;;;;;
;;;;; index
;;;;;
;;;;; TODO: これも作らんとね。
;;;;;
;; create
(defgeneric create-index (banshou ghost class-symbol slot-list)
  (:documentation "" )
  (:method ((pool banshou) (ghost ghost) (class-symbol symbol) (slot-list list))
    (list pool ghost class-symbol slot-list)))


;; remove
(defgeneric remove-index (banshou ghost class-symbol index)
  (:documentation "" )
  (:method ((pool banshou) (ghost ghost) (class-symbol symbol) index)
    (list pool ghost class-symbol index)))


;; rebuild
(defgeneric rebuild-index (banshou ghost class-symbol index)
  (:documentation "" )
  (:method ((pool banshou) (ghost ghost) (class-symbol symbol) index)
    (list pool ghost class-symbol index)))




;;;;;
;;;;; printer
;;;;;
(defgeneric print-root-list (banshou &key stream)
  (:documentation "")
  (:method ((pool banshou) &key (stream t))
    (mapcar #'(lambda (root)
                (format stream "~10a : count=~a~%"
                        root
                        (length (get-root-object pool root))))
            (root-list pool))
    pool))



;; (print-ghost-list *sys* (master-ghost *sys*))
(defgeneric print-ghost-list (banshou ghost &key stream)
  (:documentation "")
  (:method ((pool banshou) (ghost ghost) &key (stream t))
    (mapcar #'(lambda (u)
                (format stream
                        "| ~20a | ~a~%"
                        (get-code u)
                        (get-name u)))
            (get-object-list pool 'ghost))))

