(in-package :quacks)

(defun get-user (id db)
  (let ((user (get-user-db db id)))
    `((:name . ,(name user))
      (:id . ,(id user))
      (:score . ,(reduce #'+ (quotes user)
                         :key
                         (lambda (quote)
                           (length (likes quote)))))
      (:quotes-added .
                     ,(loop for quote in (quotes user)
                         collect `((:text . ,(text quote))
                                   (:id . ,(id quote))
                                   (:likes . ,(length (likes quote)))
                                   (:dislikes . ,(length (dislikes quote)))
                                   (:author-name . ,(name (author quote)))
                                   (:author-id . ,(id (author quote)))))))))
