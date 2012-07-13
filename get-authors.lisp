(in-package :quacks)

(defun get-authors (db)
  (loop for author in (get-all-authors db)
     for qquote = (first
                   (sort (copy-seq (quotes author))
                         #'>
                         :key (lambda (quote)
                                (length (likes quote)))))
     collect `((:name . ,(name author))
               (:id . ,(id author))
               (:image . ,(src (image author)))
               ,(when qquote
                      `(:qquote
                        (:id . ,(id qquote))
                        (:text . ,(text qquote))
                        (:likes . ,(length (likes qquote)))
                        (:dislikes . ,(length (dislikes qquote)))
                        (:user-name . ,(name (user qquote)))
                        (:user-id . ,(id (user qquote))))))))
