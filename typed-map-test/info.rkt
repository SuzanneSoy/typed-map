#lang info
(define collection 'multi)
(define deps '("base"
               "rackunit-lib"
               "typed-racket-lib"
               "typed-racket-more"
               "typed-map-lib"))
(define build-deps '("aful"))
(define pkg-desc "Tests for typed-map-lib")
(define version "1.0")
(define pkg-authors '("Georges Dupéron"))
