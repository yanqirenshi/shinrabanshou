(in-package :json)


(defun put-object-class (function object)
  (let ((class (class-name (class-of object))))
    (funcall function "@symbol"
             (concatenate 'string
                          (symbol-name class)
                          "@"
                          (package-name (symbol-package class))))))


(defun map-slots (function object)
  "Call FUNCTION on the name and value of every bound slot in OBJECT."
  (put-object-class function object)
  (loop for slot in (class-slots (class-of object))
     for slot-name = (slot-definition-name slot)
     if (slot-boundp object slot-name)
     do (funcall function slot-name (slot-value object slot-name))))
