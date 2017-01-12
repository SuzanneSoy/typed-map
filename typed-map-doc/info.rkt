#lang info
(define collection "typed-map")
(define deps '("base"))
(define build-deps '("scribble-lib"
                     "racket-doc"
                     "typed-racket-doc"))
(define scribblings '(("scribblings/typed-map.scrbl" ())))
(define pkg-desc
  (string-append "Documentation for typed-map-lib, a"
                 " type inference helper for map with Typed/Racket."
                 " Supports afl, un-annotated lambdas and polymorphic"
                 " functions."))
(define version "1.0")
(define pkg-authors '("Georges Dupéron"))
