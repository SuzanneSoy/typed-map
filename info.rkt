#lang info
(define collection "typed-map")
(define deps '("base"
               "rackunit-lib"
               "typed-racket-lib"
               "typed-racket-more"))
(define build-deps '("scribble-lib"
                     "racket-doc"
                     "afl"
                     "typed-racket-doc"))
(define scribblings '(("scribblings/typed-map.scrbl" ())))
(define pkg-desc
  (string-append "Type inference helper for map with Typed/Racket."
                 " Supports afl, un-annotated lambdas and polymorphic"
                 " functions."))
(define version "1.0")
(define pkg-authors '("Georges Dupéron"))
