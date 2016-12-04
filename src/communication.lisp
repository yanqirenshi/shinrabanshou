(in-package :shinrabanshou)

(defvar *message-pakage*
  (find-package :shinrabanshou))

(defvar *message-world*
  (w2w::world-at :ja))

(defvar *message-data-list*
  '((:bad-class .
     ((:ja        . "このクラスは ~a のサブクラスではありません。symbol=~a")
      (:hiroshima . "このクラスは ~a のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a")))
    (:delete-failed-have-some-edge .
     ((:ja        . "関係を持っている ~a は削除できません。")
      (:hiroshima . "関係を持っとるけぇ ~a は削除できんのんよ。")))
    (:bad-code-is-null .
     ((:ja        . "code が空(nil)です。code=~a, name=~a")
      (:hiroshima . "code が空(nil)なんじゃけど。code=~a, name=~a")))
    (:bad-code-str-len-is-zero .
     ((:ja        . "code が文字列の場合、0バイトの文字列は許していません。code=~a, name=~a")
      (:hiroshima . "code が文字列の場合、0バイトの文字列は許しとらんのんよ。code=~a, name=~a")))
    (:create-failed-exis-user .
     ((:ja        . "このユーザーはすでに存在します。user-code=~a")
      (:hiroshima . "このユーザーはもう存在するけぇ。作れるわけがなかろぉ。user-code=~a")))
    (:edge-bad-contents .
     ((:ja        . "ID(~a) はおおとるんじゃけど、なんか内容が一致せんけぇ。おかしいじゃろう。")
      (:hiroshima . "ID(~a) はおおとるんじゃけど、なんか内容が一致せんけぇ。おかしいじゃろう。")))
    (:bad-id-is-null .
     ((:ja        . "この ~a、ID 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。")
      (:hiroshima . "この ~a、ID 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。")))
    (:edge-type-is-null .
     ((:ja        . "Edge type が空っちゅうのはイケんよ。なんか適当でエエけぇ決めんさいや。")
      (:hiroshima . "Edge type が空っちゅうのはイケんよ。なんか適当でエエけぇ決めんさいや。")))
    (:understand-this-value .
     ((:ja        . "こんとなん知らんけぇ。~a=~a")
      (:hiroshima . "こんとなん知らんけぇ。~a=~a")))))

(defun add-message-expressions (code expressions)
  (dolist (expression expressions)
    (let ((world-code (car expression))
          (expression (cdr expression)))
      (w2w:add-expression code
                          world-code
                          expression
                          :package (find-package :shinrabanshou)))))

(defun init-messages (message-data-list)
  (dolist (message-data message-data-list)
    (add-message-expressions (car message-data)
                             (cdr message-data))))

(init-messages *message-data-list*)

(defun format* (stream message-code &rest values)
  (apply #'w2w:%format*
         *message-pakage*
         *message-world*
         stream message-code values))
