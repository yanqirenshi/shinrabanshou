(in-package :cl-prevalence)
#|
http://www20380ui.sakura.ne.jp/wiki/cl/prevalence/index.php/Article:Object-index
|#


;;;;;
;;;;; add slot-index
;;;;;
(defun slot-index-xxx-add (index object slot)
  (let ((id-map (gethash (slot-value object slot) index))
        (id     (get-id object)))
    ;; 最初の時ね。
    (when (null id-map)
      (setf id-map   (make-hash-table))
      (setf (gethash (slot-value object slot) index) id-map))
    ;; 既に存在するかチェックする。
    ;; 存在する場合は何もしない。
    (unless (gethash id id-map)
      ;; 存在しない場合は追加する。
      (setf (gethash id id-map) (get-id object)))))


(defun add-object-to-slot-index (system class slot object)
  "スロット・インデックスにオブジェクトを登録します。"
  (let* ((index-name (get-objects-slot-index-name class slot))
         (index (get-root-object system index-name)))
    (when (and index  (slot-boundp object slot))
      ;; 登録は実質こちらでやってます。
      (slot-index-xxx-add index object slot))))



;;;;;
;;;;; remove slot-index
;;;;;
(defun slot-index-xxx-remove (index object slot)
  (let ((id-map (gethash (slot-value object slot) index))
        (id     (get-id object)))
    ;; 既に存在するかチェックする。
    ;; 存在する場合は id-map から削除する。
    (when id-map ;;TODO: このケースって何じゃったっけ？
      (when (gethash id id-map)
        (remhash id id-map))
      ;; id-map が空になったら、index から削除する。
      ;; TODO: これ、削除する必要あるの？
      (when (= (hash-table-size id-map) 0)
        (remhash (slot-value object slot) index)))))


(defun remove-object-from-slot-index (system class slot object)
  "スロット・インデックスからオブジェクトを削除します。"
  (let* ((index-name (get-objects-slot-index-name class slot))
         (index (get-root-object system index-name)))
    (when (and index (slot-boundp object slot))
      ;; 削除は実質こちらでやってます。
      (slot-index-xxx-remove index object slot))))




;;;;;
;;;;; find-object-with-slot
;;;;;
(defgeneric find-object-with-slot-use-index (system class index))
(defmethod find-object-with-slot-use-index ((system prevalence-system) class index)
  (when index
    (let* ((ids (alexandria:hash-table-values  index))
           (len (length ids)))
      (cond ((= len 0) nil)
            ((= len 1) (list (find-object-with-id system class (first ids))))
            (t (mapcar #'(lambda (id)
                           (find-object-with-id system class id))
                       ids))))))

(defgeneric find-object-with-slot-full-scan (system class slot value test))
(defmethod find-object-with-slot-full-scan ((system prevalence-system) class slot value test)
  "オブジェクトを全件検索します。"
  (remove-if #'(lambda (object)
                 (not (funcall test value (slot-value object slot))))
             (find-all-objects system class)))


(defmethod find-object-with-slot ((system prevalence-system) class slot value &optional (test #'equalp))
  "Find and return the object in system of class with slot equal to value, null if not found
オブジェクトのスロットの値を検索して、ヒツトしたものを返します。
対象のスロットにインデックスが貼られている場合はインデックスを利用して検索します。
インデックスが存在しない場合は 全件検索します。

返す値はリスト形式で返します。なもんで、存在しない場合は nil を返します。
"
  (let* ((index-name (get-objects-slot-index-name class slot))
         (index      (get-root-object system index-name)))
    (if index
        ;; index が存在した場合は index で検索する。
        (find-object-with-slot-use-index system class (gethash value index))
        ;; index が存在しない場合は全部検索します。
        (find-object-with-slot-full-scan system class slot value test))))


