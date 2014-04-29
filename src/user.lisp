(in-package :shinrabanshou)


;;;;;
;;;;; password
;;;;;
(defun password-charp (string &key (charcters *password-characters*))
  (search string charcters))

(defun check-password-char (password &key (charcters *password-characters*))
  (if (string= "" password)
      t
      (let ((char (subseq password 0 1)))
        (if (not (password-charp char :charcters charcters))
            nil
            (check-password-char (subseq password 1))))))

(defun gen-password (&key (length 8) (use-chars *password-characters*))
  (let ((out ""))
    (dotimes (i length)
      (let ((col (random (length use-chars))))
        (setf out
              (concatenate 'string out (subseq use-chars col (+ 1 col))))))
    out))


;;;;;
;;;;; mail address
;;;;;



;;;;;
;;;;; resource
;;;;;
(defmethod lifep ((rsc resource) &key (time (get-universal-time)))
  (let ((from (get-timestamp (get-buddha  rsc)))
        (to   (get-timestamp (get-nirvana rsc))))
    (cond ((and (null to) (<= from time)) t)
          ((and (not (null to))
                (and (<= from time)) (<= time to))
           t)
          (t nil))))


;;;;;
;;;;; master user
;;;;;
(defgeneric get-user (banshou code) (:documentation ""))
(defmethod get-user ((sys banshou) code)
  (find-object-with-slot sys 'user 'code code))

(defgeneric make-user (banshou creater code &key name password note timestamp)
  (:documentation ""))
(defmethod make-user ((sys banshou)
                      (creater user)
                      code
                      &key
                        (name "@未設定")
                        (password (gen-password))
                        (note "")
                        (timestamp (get-universal-time)))
  (cond ((null code)
         (error "code が空(nil)なんじゃけど。code=~a, name=~a" code name))
        ((and (stringp code) (string= "" (cl+:trim-string code)))
         (error "code が文字列の場合、0バイトの文字列は許しとらんのんよ。code=~a, name=~a" code name))
        ((get-user sys code)
         (error "このユーザーはもう存在するけぇ。作れるわけがなかろぉ。user-code=~a" code)))
  (make-node sys 'user
             'create-time (make-footprint nil :timestamp timestamp)
             'update-time nil
             'buddha (make-footprint nil :timestamp timestamp)
             'nirvana nil
             'code code
             'password password
             'name name
             'note note))

;;;;;
;;;;; master user
;;;;;
(defgeneric master-user (banshou) (:documentation ""))
(defmethod master-user ((sys banshou)) (get-user sys *master-user-code*))


(defgeneric make-master-user (banshou &key code name password note timestamp)
  (:documentation ""))
(defmethod make-master-user ((sys banshou) &key
                                             (code     *master-user-code*)
                                             (name     *master-user-name*)
                                             (password *master-user-password*)
                                             (note     *master-user-note*)
                                             (timestamp (get-universal-time)))
  (when (master-user sys)
    (error "このユーザーはもう存在するけぇ。user-code=~a" code))
  (make-node sys 'user
             'create-time (make-footprint nil :timestamp timestamp)
             'update-time nil
             'buddha (make-footprint nil :timestamp timestamp)
             'nirvana nil
             'code code
             'password password
             'name name
             'note note))


