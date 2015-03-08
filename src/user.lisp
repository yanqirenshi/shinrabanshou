;;;;;
;;;;; Contents
;;;;;   1. Get User
;;;;;   2. Make User
;;;;;   3. Get Master User
;;;;;   4. Make Master User
;;;;;

(in-package :shinrabanshou)

;;;;;
;;;;; 1. Get User
;;;;;
(defmethod get-user ((sys banshou) code)
  (first (find-object-with-slot sys 'user 'code code)))


;;;;;
;;;;; 2. Make User
;;;;;
(defmethod tx-make-user ((sys banshou)
                         (creater user)
                         code
                         &key
                           (name "@未設定")
                           (password (takajin:gen-spell))
                           (timestamp (get-universal-time)))
  (declare (ignore timestamp))
  (cond ((null code)
         (error "code が空(nil)なんじゃけど。code=~a, name=~a" code name))
        ((and (stringp code) (string= "" (cl+:trim-string code)))
         (error "code が文字列の場合、0バイトの文字列は許しとらんのんよ。code=~a, name=~a" code name))
        ((get-user sys code)
         (error "このユーザーはもう存在するけぇ。作れるわけがなかろぉ。user-code=~a" code)))
  (let ((takajin (takajin:make-password password)))
    (values (tx-make-node sys 'user
                          `(((code ,code))
                            ((password ,takajin))
                            ((name ,name))))
            password)))


(defmethod make-user ((sys banshou)
                      (creater user)
                      code
                      &key
                        (name "@未設定")
                        (password (takajin:gen-spell))
                        (timestamp (get-universal-time)))
  (up:execute-transaction
   (tx-make-user sys creater code :name name :password password :timestamp timestamp)))



;;;;;
;;;;; 3. Get Master User
;;;;;
(defmethod master-user ((sys banshou))
  (get-user sys *master-user-code*))



;;;;;
;;;;; 4. Make Master User
;;;;;
(defmethod make-master-user ((sys banshou) &key
                                             (code     *master-user-code*)
                                             (name     *master-user-name*)
                                             (password *master-user-password*)
                                             (timestamp (get-universal-time)))
  (when (master-user sys)
    (error "このユーザーはもう存在するけぇ。user-code=~a" code))
  (tx-make-node sys 'user
                `((code ,code)
                  (password ,password)
                  (name ,name))))


(defmethod tx-make-master-user ((sys banshou) &key
                                                (code     *master-user-code*)
                                                (name     *master-user-name*)
                                                (password *master-user-password*)
                                                (timestamp (get-universal-time)))
  (declare (ignore timestamp))
  (when (master-user sys)
    (error "このユーザーはもう存在するけぇ。user-code=~a" code))
  (tx-make-node sys 'user
                `((code ,code)
                  (password ,password)
                  (name ,name))))





#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#

