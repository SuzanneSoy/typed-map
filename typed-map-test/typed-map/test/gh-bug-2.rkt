#lang typed/racket
(require typed-map
         typed/rackunit)

(check-equal? (foldl (λ (x [acc : (Rec R (U Null (Pairof R Positive-Index)))])
                       (cons acc (add1 x)))
                     '()
                     '(1 2 3))
              '(((() . 2) . 3) . 4))