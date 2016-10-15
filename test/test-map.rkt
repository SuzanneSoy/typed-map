#lang afl typed/racket

(require typed-map)

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
