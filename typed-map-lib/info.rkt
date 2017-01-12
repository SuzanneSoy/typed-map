#lang info
(define collection "typed-map")
(define deps '("base"
               "typed-racket-lib"))
(define build-deps '())
(define pkg-desc
  (string-append "Type inference helper for map with Typed/Racket."
                 " Supports afl, un-annotated lambdas and polymorphic"
                 " functions."))
(define version "1.0")
(define pkg-authors '("Georges Dupéron"))
