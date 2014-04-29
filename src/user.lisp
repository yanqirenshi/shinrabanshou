(in-package :shinrabanshou)

(defvar *master-user-code* "@master")
(defvar *master-user-name* "森羅万象 Master User")
(defvar *master-user-note* "Created by shinrabanshou")
(defvar *password-characters* "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*()_+|[]{};:,./<>?")
;; gen-password
;; life?

;;; master user
(defgeneric master-user (banshou) (:documentation ""))
(defmethod master-user ((sys banshou))
  (find-object-with-slot sys 'user 'code *master-user-code*))


(defgeneric make-master-user (banshou &key code name note timestamp)
  (:documentation ""))
(defmethod make-master-user ((sys banshou) &key
                                             (code *master-user-code*)
                                             (name *master-user-name*)
                                             (note *master-user-note*)
                                             (timestamp (get-universal-time)))
  (when (master-user sys)
    (error "このユーザーはもう存在するけぇ。user-code=~a" code))
  (make-node sys 'user
             'create-time (make-footprint nil :timestamp timestamp)
             'update-time nil
             'buddha (make-footprint nil :timestamp timestamp)
             'nirvana nil
             'code code
             'name name
             'note note))


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


(defmethod lifep ((rsc resource) &key (time (get-universal-time)))
  (let ((from (get-timestamp (get-buddha  rsc)))
        (to   (get-timestamp (get-nirvana rsc))))
    (cond ((and (null to) (<= from time)) t)
          ((and (not (null to))
                (and (<= from time)) (<= time to))
           t)
          (t nil))))



