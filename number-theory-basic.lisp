(defpackage :number-theory-basic
  (:nicknames :nt)
  (:use :cl :ol)
  (:export
   :xgcd))

(in-package :number-theory-basic)

;;; gcd

(defun xgcd (m n)
  "Calculate the greatest common divisor D of integers M and N.
Return (values D U V) with D = U * M + V * N."
  (let ((id (list 1 0 0 1)))
    (labels ((matr-mult (q mat)
               (destructuring-bind (a b c d) mat
                 (list c d (- a (* q c)) (- b (* q d)))))
             (rek (m n mat)
               (if (zerop n)
                   (values m (first mat) (second mat))
                   (multiple-value-bind (q r) (truncate m n)
                     (rek n r (matr-mult q mat))))))
      (rek m n id))))

(defun xgcd/rec (m n)
  "Calculate the greatest common divisor D of integers M and N.
Return (values D U V) with D = U * M + V * N. (recursive version)"
  (if (zerop n)
      (values (abs m) (signum m) 0)
      (multiple-value-bind (q r) (floor m n)
        (multiple-value-bind (d u v) (xgcd n r)
          (values d v (- u (* v q)))))))

;;; square roots of rationals and integers
(defmethod gm:sqrt ((number integer))
  (let ((r1 (isqrt number))
        (r2 (sqrt number)))
    (if (= r1 r2)
        (values r1 t)
        (values r2 nil))))

(defmethod gm:sqrt ((number rational))
  (let ((num (numerator number))
        (den (denominator number)))
    (multiple-value-bind (num-r num-nice) (gm:sqrt num)
      (multiple-value-bind (den-r den-nice) (gm:sqrt den)
        (if (and num-nice den-nice)
            (values (/ num-r den-r) t)
            (values (sqrt number) nil))))))
