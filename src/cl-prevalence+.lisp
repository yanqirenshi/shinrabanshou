(in-package :cl-prevalence)
;;;;;
;;;;; http://www20380ui.sakura.ne.jp/wiki/cl/prevalence/index.php/Article:Object-index
;;;;;
;;;;;
;;;;;


;;
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
      (setf (gethash id id-map) object))))

(defun slot-index-xxx-remove (index object slot)
  (let ((id-map (gethash (slot-value object slot) index))
        (id     (get-id object)))
    ;; 既に存在するかチェックする。
    ;; 存在する場合は id-map から削除する。
    (when (gethash id id-map)
      (remhash id id-map))
    ;; id-map が空になったら、index から削除する。
    (when (= (hash-table-size id-map) 0)
      (remhash (slot-value object slot) index))))


;;
(defun add-object-to-slot-index (system class slot object)
  "Add an index entry using this slot to this object"
  (let* ((index-name (get-objects-slot-index-name class slot))
         (index (get-root-object system index-name)))
    (when (and index  (slot-boundp object slot))
      ;;
      ;; スロット・インデックスにオブジェクトを登録します。
      ;;
      (slot-index-xxx-add index object slot))))


;;
(defun remove-object-from-slot-index (system class slot object)
  "Remove the index entry using this slot to this object"
  (let* ((index-name (get-objects-slot-index-name class slot))
         (index (get-root-object system index-name)))
    (when (and index (slot-boundp object slot))
      ;;
      ;; スロット・インデックスからオブジェクトを削除します。
      ;;
      (slot-index-xxx-remove index object slot))))
