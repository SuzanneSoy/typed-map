#lang info
(define collection 'multi)
(define deps '("typed-map-lib"
               "typed-map-test"))
(define implies '("typed-map-lib"
                  "typed-map-test"))
(define build-deps '())
(define pkg-desc
  (string-append "Type inference helper for map with Typed/Racket."
                 " Supports afl, un-annotated lambdas and polymorphic"
                 " functions."))
(define version "1.0")
(define pkg-authors '("Georges Dupéron"))
