#lang scribble/manual
@require[scribble/example
         @for-label[typed-map]]

@title{typed-map}
@author[@author+email["Georges Dupéron" "georges.duperon@gmail.com"]]

@(module orig racket/base
   (require scribble/manual
            (for-label racket/base))
   (provide orig:map)
   (define orig:map @racket[map]))
@(require 'orig)

@defmodule[typed-map]

@defproc[#:kind "syntax"
         (map [f (→ A ... B)] [l (Listof A)] ...) (Listof B)]{
 Like @orig:map from @racketmodname[typed/racket/base], but with better type
 inference for Typed Racket.
 
 When @racket[f] is a literal lambda of the form
 @racket[(λ (arg ...) body ...)], it is not necessary to specify the type of
 the arguments, as they will be inferred from the list.

 @examples[#:eval ((make-eval-factory '(typed-map) #:lang 'typed/racket))
           (map (λ (x) (* x 2)) '(1 2 3))
           (let ([l '(4 5 6)])
             (map (λ (x) (* x 2)) l))]

 This enables the use of @racket[#,(hash-lang) #,(racketmodname afl)] for
 @racket[map] in Typed Racket.

 Furthermore, when @racket[f] is a polymorphic function, type annotations are
 not needed:

 @examples[#:eval ((make-eval-factory '(typed-map) #:lang 'typed/racket))
           (map car '([a . 1] [b . 2] [c . 3]))]

 Compare this with the behaviour of @orig:map from
 @racketmodname[racket/base], which generates a type error:
 
 @examples[#:eval ((make-eval-factory '() #:lang 'typed/racket))
           (eval:alts (#,orig:map car '([a . 1] [b . 2] [c . 3]))
                      (eval:error (map car '([a . 1] [b . 2] [c . 3]))))]

 When used as an identifier, the @racket[map] macro expands to the original
 @orig:map from @racketmodname[typed/racket/base]:

 @examples[#:eval ((make-eval-factory '(typed-map) #:lang 'typed/racket))
           (eval:alts (require (only-in racket/base [#,orig:map orig:map]))
                      (require (only-in racket/base [map orig:map])))
           (equal? map orig:map)]

 Note that the implementation expands to a large expression, and makes use of
 @racket[set!] internally to build the result list. The trick used proceeds as
 follows:
 @itemlist[
 @item{It uses @racket[(reverse (reverse l))] to generalise the type of the
   list, without having to express that type, so that Type / Racket infers a
   more general type of the form @racket[(Listof A)], without detecting that the
   output is identical to the input. An unoptimizable guard prevents the
   double-reverse from actually being executed, so it does not incur a
   performance cost.}
 @item{It uses a
   @seclink["Named_let" #:doc '(lib "scribblings/guide/guide.scrbl")]{named
    @racket[let]} to perform the loop. The function @racket[f] is never passed
   as an argument to another polymorphic function, and is instead directly
   called with the appropriate arguments. The error message ``Polymorphic
   function `map' could not be applied to arguments'' is therefore not raised.}
 @item{To have the most precise and correct types, it uses a named let with a
   single variable containing the list (with the generalized type). An outer let
   binds a mutable accumulator, initialized with a single-element list
   containing the result of applying @racket[f] on the first element of the
   list. Since all elements of the list belong to the generalized type, the
   result of calling @racket[f] on any element has the same type, therefore the
   accumulator has the type @racket[(Listof B)], where @racket[B] is the
   inferred type of the result of @racket[f].}]}
