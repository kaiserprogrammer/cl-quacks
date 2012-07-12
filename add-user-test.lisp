(defpackage add-user-test
  (:use :cl :quacks :fiveam))
(in-package add-user-test)

(def-suite add-user)
(in-suite add-user)

(test adding-a-user
  (let* ((db (make-instance 'memory-db))
         (user-id (add-user "John" db))
         (user (get-user-db db user-id)))
    (is (equal "John" (name user)))))

(test adding-a-second-user
  (let* ((db (make-instance 'memory-db))
         (first-id (add-user "Jim" db))
         (second-id (add-user "John" db))
         (first (get-user-db db first-id))
         (second (get-user-db db second-id)))
    (is (equal "Jim" (name first)))
    (is (equal first-id (id first)))
    (is (equal "John" (name second)))
    (is (equal second-id (id second)))))

(test adding-the-same-user
  (let* ((db (make-instance 'memory-db))
         (first-id (add-user "John" db))
         (second-id (add-user "John" db))
         (first (get-user-db db first-id))
         (second (get-user-db db second-id)))
    (is (eql first second))))

(run!)
