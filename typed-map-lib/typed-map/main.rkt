#lang typed/racket

(require (only-in racket/base
                  [map orig-map]
                  [foldr orig-foldr]
                  [foldl orig-foldl]))

(provide map foldr foldl)

(module m racket/base
  (provide unoptimizable-false)
  (define (unoptimizable-false) #f))
(require/typed 'm [unoptimizable-false (→ Boolean)])

(define #:∀ (A) (generalize [l : (Listof A)])
  (if (unoptimizable-false)
      l
      ;; the double-reverse is complex enough that Typed/Racket does not
      ;; infer that generalize has type (→ A A) instead of
      ;; (→ (Listof A) (Listof A))
      ;; The unoptimizable-false above means that this is never executed,
      ;; so the performance cost of the double-reverse is not incured.
      (reverse (reverse l))))

(define-syntax (map stx)
  (syntax-case stx (λ)
    [self (identifier? #'self) #'orig-map]
    [(_ (λ (argᵢ ...) body ...) lᵢ ...)
     (andmap identifier? (syntax->list #'(argᵢ ...)))
     #'(foldr (λ (argᵢ ... acc) (cons (let () body ...) acc)) null lᵢ ...)]
    [(_ f lᵢ ...)
     (with-syntax ([(argᵢ ...) (generate-temporaries #'(lᵢ ...))])
       #'(foldr (λ (argᵢ ... acc) (cons (f argᵢ ...) acc)) null lᵢ ...))]))

(define-syntax (foldr stx)
  (syntax-case stx (λ)
    [self (identifier? #'self) #'orig-foldr]
    [(_ f init-acc lᵢ ...)
     #'(foldl f init-acc (reverse lᵢ) ...)]))

(define-syntax (foldl stx)
  (syntax-case stx (λ)
    [self (identifier? #'self) #'orig-foldl]
    [(_ (λ (argᵢ ... arg-acc) body ...) init-acc lᵢ ...)
     (andmap identifier? (syntax->list #'(argᵢ ... arg-acc)))
     (begin
       (unless (equal? (length (syntax->list #'(argᵢ ...)))
                       (length (syntax->list #'(lᵢ ...))))
         (raise-syntax-error 'infer-map
                             "wrong number of argument lists for the function"
                             stx))
       (with-syntax ([(l-cacheᵢ ...) (generate-temporaries #'(lᵢ ...))]
                     [(upcast-lᵢ ...) (generate-temporaries #'(lᵢ ...))]
                     [(l-loopᵢ ...) (generate-temporaries #'(lᵢ ...))])
         #'(let ([l-cacheᵢ lᵢ] ...)
             (let ([upcast-lᵢ (generalize l-cacheᵢ)]
                   ...)
               (if (or (null? l-cacheᵢ) ...)
                   (begin
                     (unless (and (null? l-cacheᵢ) ...)
                       ;; TODO: copy the error message from map.
                       (error "all lists must have same size"))
                     init-acc)
                   ;; Possibility to call (generalize) on the single-element
                   ;; list if Typed Racket does not generalize the (List B)
                   ;; type to (Listof B) thanks to the use of set!.
                   ;; If necessary, use the following structure:
                   ;; ((λ #:∀ (B) ([upcast-first-result : B])
                   ;;    (let ([mutable-list : (Listof B)])
                   ;;      … (set! mutable-list (cons … …) …))
                   ;;  ;; compute the first result:
                   ;;  (let ([argᵢ (car upcast-lᵢ)] ...) body ...))
                   (let ([upcast-result (let ([argᵢ (car upcast-lᵢ)]
                                              ...
                                              [arg-acc init-acc])
                                          body ...)])
                     (let loop ([l-loopᵢ (cdr upcast-lᵢ)]
                                ...)
                       (if (or (null? l-loopᵢ) ...)
                           (begin
                             (unless (and (null? l-loopᵢ) ...)
                               ;; TODO: copy the error message from foldr/map.
                               (error "all lists must have same size"))
                             (void))
                           (begin (set! upcast-result
                                        (let ([argᵢ (car l-loopᵢ)]
                                              ...
                                              [arg-acc upcast-result])
                                          body ...))
                                  (loop (cdr l-loopᵢ) ...))))
                     upcast-result))))))]
    [(_ f init-acc lᵢ ...)
     (with-syntax ([(argᵢ ...) (generate-temporaries #'(lᵢ ...))])
       #'(foldr (λ (argᵢ ... arg-acc) (f argᵢ ... arg-acc)) init-acc lᵢ ...))]))