#lang info
(define collection 'multi)
(define deps '("base"))
(define build-deps '("scribble-lib"
                     "racket-doc"
                     "typed-racket-doc"
                     "aful"
                     "typed-map-lib"))
(define pkg-desc
  (string-append "Documentation for typed-map-lib, a"
                 " type inference helper for map with Typed/Racket."
                 " Supports afl, un-annotated lambdas and polymorphic"
                 " functions."))
(define version "1.0")
(define pkg-authors '(|Suzanne Soy|))
