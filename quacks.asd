(cl:defpackage :quacks-system
  (:use :cl :asdf))
(cl:in-package :quacks-system)

(defsystem :quacks
  :version "0.1"
  :author "Jürgen Bickert <juergenbickert@gmail.com>"
  :maintainer "Jürgen Bickert <juergenbickert@gmail.com>"
  :description "A quote rating system"
  :components ((:file "package")
               (:file "add-author" :depends-on ("package"))
               (:file "add-user" :depends-on ("package"))
               (:file "add-quote" :depends-on ("package"))
               (:file "add-image" :depends-on ("package"))
               (:file "dislike-quote" :depends-on ("package"))
               (:file "like-quote" :depends-on ("package"))
               (:file "get-author" :depends-on ("package"))
               (:file "get-authors" :depends-on ("package"))
               (:file "get-user" :depends-on ("package"))
               (:file "get-users" :depends-on ("package"))
               (:file "memory-db" :depends-on ("add-author"
                                               "add-user"
                                               "add-quote"))))
