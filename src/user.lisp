(in-package :shinrabanshou)


;;;;;
;;;;; master user
;;;;;
(defmethod get-user ((sys banshou) code)
  (first (find-object-with-slot sys 'user 'code code)))


(defmethod make-user ((sys banshou)
                      (creater user)
                      code
                      &key
                        (name "@未設定")
                        (password (gen-password))
                        (timestamp (get-universal-time)))
  (cond ((null code)
         (error "code が空(nil)なんじゃけど。code=~a, name=~a" code name))
        ((and (stringp code) (string= "" (cl+:trim-string code)))
         (error "code が文字列の場合、0バイトの文字列は許しとらんのんよ。code=~a, name=~a" code name))
        ((get-user sys code)
         (error "このユーザーはもう存在するけぇ。作れるわけがなかろぉ。user-code=~a" code)))
  (values (tx-make-node sys 'user
                        `(((code ,code))
                          ((password ,password))
                          ((name ,name))))
          password))


(defmethod tx-make-user ((sys banshou)
                         (creater user)
                         code
                         &key
                           (name "@未設定")
                           (password (gen-password))
                           (timestamp (get-universal-time)))
  (cond ((null code)
         (error "code が空(nil)なんじゃけど。code=~a, name=~a" code name))
        ((and (stringp code) (string= "" (cl+:trim-string code)))
         (error "code が文字列の場合、0バイトの文字列は許しとらんのんよ。code=~a, name=~a" code name))
        ((get-user sys code)
         (error "このユーザーはもう存在するけぇ。作れるわけがなかろぉ。user-code=~a" code)))
  (values (tx-make-node sys 'user
                        `(((code ,code))
                          ((password ,password))
                          ((name ,name))))
          password))



;;;;;
;;;;; master user
;;;;;
(defmethod master-user ((sys banshou))
  (get-user sys *master-user-code*))

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


