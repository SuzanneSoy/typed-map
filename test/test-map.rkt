#lang afl typed/racket

(require typed-map
         typed/rackunit)

;; without ann
(let ()
  (map (λ (x) (* x 2)) '())
  (map (λ (x) (* x 2)) '(1))
  (map (λ (x) (* x 2)) '(1 2))
  (map (λ (x) (* x 2)) '(1 2 3))
  (map + '(1 2 3) '(4 5 6))
  (map car '((1 2) (3 4)))
  (map #λ(+ % 1) '(1 2 3))

  ;; used as a function (identifier macro), looses the inference abilities
  (map map (list add1 sub1) '((1 2 3) (4 5 6)))
  (map map
       (ann (list car cdr) (Listof (→ (List Number) (U Number Null))))
       '(((1) (2) (3)) ((4) (5) (6))))

  (λ #:∀ (A) ([l : (Listof A)])
    (map (λ (x) x) l))

  (void))

;; with ann
(ann (map (λ (x) (* x 2)) '()) Null)
(ann (map (λ (x) (* x 2)) '(1)) (Listof Positive-Byte))
(ann (map (λ (x) (* x 2)) '(1 2)) (Listof Positive-Index))
(ann (map (λ (x) (* x 2)) '(1 2 3)) (Listof Positive-Index))
(ann (map + '(1 2 3) '(4 5 6)) (Listof Positive-Index))
(ann (map car '((1 2) (3 4))) (Listof Positive-Byte))
(ann (map #λ(+ % 1) '(1 2 3)) (Listof Positive-Index))

(ann (λ #:∀ (A) ([l : (Listof A)])
       (map (λ (x) x) l))
     (∀ (A) (→ (Listof A) (Listof A))))

;; with check-equal?
(check-equal? (map (λ (x) (* x 2)) '()) '())
(check-equal? (map (λ (x) (* x 2)) '(1)) '(2))
(check-equal? (map (λ (x) (* x 2)) '(1 2)) '(2 4))
(check-equal? (map (λ (x) (* x 2)) '(1 2 3)) '(2 4 6))
(check-equal? (map + '(1 2 3) '(4 5 6)) '(5 7 9))
(check-equal? (map car '((1 2) (3 4))) '(1 3))
(check-equal? (map #λ(+ % 1) '(1 2 3)) '(2 3 4))

(check-equal? (map map (list add1 sub1) '((1 2 3) (4 5 6)))
              '((2 3 4) (3 4 5)))
(check-equal? (map map
                   (ann (list car cdr)
                        (Listof (→ (List Number) (U Number Null))))
                   '(((1) (2) (3)) ((4) (5) (6))))
              '((1 2 3) (() () ())))

(check-equal? ((λ #:∀ (A) ([l : (Listof A)])
                 (map (λ (x) x) l))
               '(a b c))
              '(a b c))

;; foldr:

(check-equal? (foldr (λ (x acc) (cons (add1 x) acc)) '() '(1 2 3))
              (map add1 '(1 2 3)))
(check-equal? (foldr (λ (x acc) (cons (add1 x) acc)) '() '(1 2 3))
              '(2 3 4))

(let ()
  (ann (foldr (λ (x acc) (cons (add1 x) acc)) '() '()) Null)
  (void))

;; foldl:

(check-equal? (foldl (λ (x acc) (cons (add1 x) acc)) '() '(1 2 3))
              '(4 3 2))
;; Does not work because the type changes.
#;(check-equal? (foldl (λ (x acc) (cons acc (add1 x))) '() '(1 2 3))
                '(4 (3 (2))))
(foldl (λ (x [acc : (Rec R (U Null (Pairof R Positive-Index)))])
         (cons acc (add1 x)))
       '()
       '(1 2 3))

(let ()
  (ann (foldl (λ (x acc) (cons (add1 x) acc)) '() '()) Null)
  (void))