(in-package :quacks)

(defun get-author (id db)
  (let ((author (get-author-db db id)))
    `((:name . ,(name author))
      (:id . ,(id author))
      (:image . ,(src (image author)))
      (:quotes .
               ,(loop for quote in (quotes author)
                   collect
                     `((:id . ,(id quote))
                       (:text . ,(text quote))
                       (:user-name . ,(name (user quote)))
                       (:user-id . ,(id (user quote)))
                       (:likes . ,(length (likes quote)))
                       (:dislikes . ,(length (dislikes quote)))))))))
