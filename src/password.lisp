;;;;;
;;;;; Contents
;;;;;   none...
;;;;;

(in-package :shinrabanshou)


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




#|
This file is a part of shinrabanshou project.
Copyright (c) 2014 Satoshi Iwasaki (yanqirenshi@gmail.com)

|#
