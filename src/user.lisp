(in-package :shinrabanshou)


;;;;;
;;;;; master user
;;;;;
(defgeneric get-user (banshou code)
  (:documentation "")
  (:method ((sys banshou) code)
    (first (find-object-with-slot sys 'user 'code code))))


(defgeneric make-user (banshou creater code &key name password timestamp)
  (:documentation "")
  (:method ((sys banshou)
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
                          `((create-time ,(make-footprint nil :timestamp timestamp))
                            ((update-time nil))
                            ((buddha      ,(make-footprint nil :timestamp timestamp)))
                            ((nirvana nil))
                            ((code ,code))
                            ((password ,password))
                            ((name ,name))))
            password)))


(defgeneric tx-make-user (banshou creater code &key name password timestamp)
  (:documentation "")
  (:method ((sys banshou)
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
                          `(((create-time ,(make-footprint nil :timestamp timestamp)))
                            ((update-time nil))
                            ((buddha ,(make-footprint nil :timestamp timestamp)))
                            ((nirvana nil))
                            ((code ,code))
                            ((password ,password))
                            ((name ,name))))
            password)))



;;;;;
;;;;; master user
;;;;;
(defgeneric master-user (banshou)
  (:documentation "")
  (:method ((sys banshou))
    (get-user sys *master-user-code*)))

(defgeneric make-master-user (banshou &key code name password timestamp)
  (:documentation "")
  (:method ((sys banshou) &key
                            (code     *master-user-code*)
                            (name     *master-user-name*)
                            (password *master-user-password*)
                            (timestamp (get-universal-time)))
    (when (master-user sys)
      (error "このユーザーはもう存在するけぇ。user-code=~a" code))
    (tx-make-node sys 'user
                  `((create-time ,(make-footprint nil :timestamp timestamp))
                    (update-time nil)
                    (buddha ,(make-footprint nil :timestamp timestamp))
                    (nirvana nil)
                    (code ,code)
                    (password ,password)
                    (name ,name)))))


(defgeneric tx-make-master-user (banshou &key code name password timestamp)
  (:documentation "")
  (:method ((sys banshou) &key
                            (code     *master-user-code*)
                            (name     *master-user-name*)
                            (password *master-user-password*)
                            (timestamp (get-universal-time)))
    (when (master-user sys)
      (error "このユーザーはもう存在するけぇ。user-code=~a" code))
    (tx-make-node sys 'user
                  `((create-time ,(make-footprint nil :timestamp timestamp))
                    (update-time nil)
                    (buddha ,(make-footprint nil :timestamp timestamp))
                    (nirvana nil)
                    (code ,code)
                    (password ,password)
                    (name ,name)))))


