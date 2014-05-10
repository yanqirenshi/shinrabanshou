(in-package :cl-prevalence)
#|

http://www20380ui.sakura.ne.jp/wiki/cl/prevalence/index.php/Article:Object-index

なんか目的があいまいになってきたね。

以下のような関係が発生したときに、Edge の from/to にインデックスを貼ると問題が発生します。
<ケース>
1: N1 f--- E1 ---t N2
2: N1 f--- E2 ---t N3

現在の cl-prevalence のスロットインデックスは 単一キーしか対応しとらんのよ。
じゃけぇ上のケースじゃと 2: の追加で 1: の分が消えてしまうんよね。

"from が N1 のもの" ってすると 2: しか出てこんのんよ。
これじゃぁイケんいね。

key: N1,  val: E1, E2  にならんにゃぁイケんけぇ。
key: N1,  val: E1      じゃぁ話しにならんけぇ。

|#


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
      (setf (gethash id id-map) (get-id object)))))

(defun slot-index-xxx-remove (index object slot)
  (let ((id-map (gethash (slot-value object slot) index))
        (id     (get-id object)))
    ;; 既に存在するかチェックする。
    ;; 存在する場合は id-map から削除する。
    (when id-map ;;TODO: このケースって何じゃったっけ？
      (when (gethash id id-map)
        (remhash id id-map))
      ;; id-map が空になったら、index から削除する。
      (when (= (hash-table-size id-map) 0)
        (remhash (slot-value object slot) index)))))


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




;;;;;
;;;;; find-object-with-slot
;;;;;
;; default code
;; (defmethod find-object-with-slot ((system prevalence-system) class slot value &optional (test #'equalp))
;;   "Find and return the object in system of class with slot equal to value, null if not found"
;;   (let* ((index-name (get-objects-slot-index-name class slot))
;;       (index (get-root-object system index-name)))
;;     (if index
;;         (find-object-with-id system class (gethash value index))
;;      (find value (find-all-objects system class)
;;            :key #'(lambda (object) (slot-value object slot)) :test test))))

(defmethod find-object-with-slot-core ((system prevalence-system) class index)
  ;; TODO: index が null のケース
  ;; TODO: index が zero件 のケース
  (let* ((ids (alexandria:hash-table-values  index))
         (len (length ids)))
    (cond ((= len 0) nil)
          ((= len 1) (find-object-with-id system class (first ids)))
          (t (mapcar #'(lambda (id)
                         (find-object-with-id system class id))
                     ids)))))

(defmethod find-object-with-slot ((system prevalence-system) class slot value &optional (test #'equalp))
  "Find and return the object in system of class with slot equal to value, null if not found"
  (let* ((index-name (get-objects-slot-index-name class slot))
         (index      (get-root-object system index-name)))
    (if index
        ;; index が存在した場合は index で検索する。
        (find-object-with-slot-core system class (gethash value index))
        ;; index が存在しない場合は 。。。
        (find value (find-all-objects system class)
              :key #'(lambda (object) (slot-value object slot)) :test test))))


