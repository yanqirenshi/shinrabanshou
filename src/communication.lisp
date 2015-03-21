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

(mapcar #'(lambda (param) (apply #'w2w:add-message param))
        '((:bad-class :ja "このクラスは ~a のクラスじゃないね。こんとなん許せんけぇ。絶対だめよ。symbol=~a")))



#|
This file is a part of shinrabanshou project.
Copyright (c) 2015 Satoshi Iwasaki (yanqirenshi@gmail.com)
|#

