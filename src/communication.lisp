;;;;;
;;;;; Contents
;;;;;   1. ...
;;;;;   2. ...
;;;;;   3. ...
;;;;;   4. ...
;;;;;   5. ...
;;;;;

(in-package :shinrabanshou)

(w2w:refresh-language)

(setf w2w::*message* (make-hash-table))
(setf w2w::*default-world* (make-instance 'w2w::world :language :ja))

(mapcar #'(lambda (param) (apply #'w2w:add-message param))
        '((:bad-class :ja "このクラスは ~a のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a")
          (:delete-failed-have-some-edge :ja "関係を持っている ~a は削除できません。")
          (:bad-code-is-null :ja "code が空(nil)なんじゃけど。code=~a, name=~a")
          (:bad-code-str-len-is-zero :ja "code が文字列の場合、0バイトの文字列は許しとらんのんよ。code=~a, name=~a")
          (:create-failed-exis-user :ja "このユーザーはもう存在するけぇ。作れるわけがなかろぉ。user-code=~a")
          (:edge-bad-contents :ja "ID(~a) はおおとるんじゃけど、なんか内容が一致せんけぇ。おかしいじゃろう。 ")
          (:bad-id-is-null :ja "この ~a、ID 空なんじゃけど、作りかた間違ごぉとらんか？ きちんとしぃや。")
          (:edge-type-is-null :ja "Edge type が空っちゅうのはイケんよ。なんか適当でエエけぇ決めんさいや。")
          (:understand-this-value :ja "こんとなん知らんけぇ。~a=~a")))
