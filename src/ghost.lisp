(in-package :shinrabanshou)


;;;;;
;;;;; master ghost
;;;;;
(defgeneric get-ghost (banshou code)
  (:documentation "")
  (:method ((sys banshou) code)
    (first (find-object-with-slot sys 'ghost 'code code))))


(defgeneric make-ghost (banshou creater code &key name password timestamp)
  (:documentation "")
  (:method ((sys banshou)
            (creater ghost)
            code
            &key
              (name "@未設定")
              (password (gen-password))
              (timestamp (get-universal-time)))
    (cond ((null code)
           (error "code が空(nil)なんじゃけど。code=~a, name=~a" code name))
          ((and (stringp code) (string= "" (cl+:trim-string code)))
           (error "code が文字列の場合、0バイトの文字列は許しとらんのんよ。code=~a, name=~a" code name))
          ((get-ghost sys code)
           (error "このユーザーはもう存在するけぇ。作れるわけがなかろぉ。ghost-code=~a" code)))
    (values (tx-make-node sys 'ghost
                          `((create-time ,(make-footprint nil :timestamp timestamp))
                            ((update-time nil))
                            ((buddha      ,(make-footprint nil :timestamp timestamp)))
                            ((nirvana nil))
                            ((code ,code))
                            ((password ,password))
                            ((name ,name))))
            password)))


(defgeneric tx-make-ghost (banshou creater code &key name password timestamp)
  (:documentation "")
  (:method ((sys banshou)
            (creater ghost)
            code
            &key
              (name "@未設定")
              (password (gen-password))
              (timestamp (get-universal-time)))
    (cond ((null code)
           (error "code が空(nil)なんじゃけど。code=~a, name=~a" code name))
          ((and (stringp code) (string= "" (cl+:trim-string code)))
           (error "code が文字列の場合、0バイトの文字列は許しとらんのんよ。code=~a, name=~a" code name))
          ((get-ghost sys code)
           (error "このユーザーはもう存在するけぇ。作れるわけがなかろぉ。ghost-code=~a" code)))
    (values (tx-make-node sys 'ghost
                          `(((create-time ,(make-footprint nil :timestamp timestamp)))
                            ((update-time nil))
                            ((buddha ,(make-footprint nil :timestamp timestamp)))
                            ((nirvana nil))
                            ((code ,code))
                            ((password ,password))
                            ((name ,name))))
            password)))



;;;;;
;;;;; master ghost
;;;;;
(defgeneric master-ghost (banshou)
  (:documentation "")
  (:method ((sys banshou))
    (get-ghost sys *master-ghost-code*)))

(defgeneric make-master-ghost (banshou &key code name password timestamp)
  (:documentation "")
  (:method ((sys banshou) &key
                            (code     *master-ghost-code*)
                            (name     *master-ghost-name*)
                            (password *master-ghost-password*)
                            (timestamp (get-universal-time)))
    (when (master-ghost sys)
      (error "このユーザーはもう存在するけぇ。ghost-code=~a" code))
    (tx-make-node sys 'ghost
                  `((create-time ,(make-footprint nil :timestamp timestamp))
                    (update-time nil)
                    (buddha ,(make-footprint nil :timestamp timestamp))
                    (nirvana nil)
                    (code ,code)
                    (password ,password)
                    (name ,name)))))


(defgeneric tx-make-master-ghost (banshou &key code name password timestamp)
  (:documentation "")
  (:method ((sys banshou) &key
                            (code     *master-ghost-code*)
                            (name     *master-ghost-name*)
                            (password *master-ghost-password*)
                            (timestamp (get-universal-time)))
    (when (master-ghost sys)
      (error "このユーザーはもう存在するけぇ。ghost-code=~a" code))
    (tx-make-node sys 'ghost
                  `((create-time ,(make-footprint nil :timestamp timestamp))
                    (update-time nil)
                    (buddha ,(make-footprint nil :timestamp timestamp))
                    (nirvana nil)
                    (code ,code)
                    (password ,password)
                    (name ,name)))))


