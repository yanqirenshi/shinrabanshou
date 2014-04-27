(in-package :shinrabanshou)

(defvar *master-user-code* "@master")
(defvar *master-user-name* "森羅万象 Master User")
(defvar *master-user-note* "Created by shinrabanshou")

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

