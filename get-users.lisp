(in-package :quacks)

(defun get-users (db)
  (loop for user in (get-all-users db)
     for quote = (first (sort (copy-seq (quotes user))
                              #'>
                              :key (lambda (quote)
                                     (length (likes quote)))))
     collect `((:name . ,(name user))
               (:id . ,(id user))
               (:score . 0)
               .
               ,(when quote
                      `((:quote
                         .
                         ((:text . ,(text quote))
                          (:id . ,(id quote))
                          (:author-name . ,(name (author quote)))
                          (:author-id . ,(id (author quote))))))))))
