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
  (first (find-objects sys 'user :slot 'code :value code)))


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
         (error* :bad-code-is-null name))
        ((and (stringp code) (string= "" (trim-string code)))
         (error* :bad-code-str-len-is-zero code name))
        ((get-user sys code)
         (error :create-failed-exis-user code)))
  (let ((takajin (takajin:make-password password)))
    (values (tx-make-vertex sys 'user
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
(defmethod tx-make-master-user ((sys banshou) &key
                                                (code     *master-user-code*)
                                                (name     *master-user-name*)
                                                (password *master-user-password*)
                                                (timestamp (get-universal-time)))
  (declare (ignore timestamp))
  (when (master-user sys)
    (error* :create-failed-exis-user code))
  (tx-make-vertex sys 'user
                  `((code ,code)
                    (password ,password)
                    (name ,name))))


(defmethod make-master-user ((sys banshou) &key
                                             (code     *master-user-code*)
                                             (name     *master-user-name*)
                                             (password *master-user-password*)
                                             (timestamp (get-universal-time)))
  (up:execute-transaction
   (make-master-user sys :code code :name name :password password :timestamp timestamp)))
