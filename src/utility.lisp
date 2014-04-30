(in-package :shinrabanshou)

;;;;;
;;;;; Node
;;;;;
(defun pairify (list)
  (when list (concatenate 'list
                          (list (subseq list 0 2))
                          (pairify (rest (rest list))))))

;;;;;
;;;;; Graph
;;;;;



