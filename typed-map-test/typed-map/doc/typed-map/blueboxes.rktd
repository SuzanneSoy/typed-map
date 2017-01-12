188
((3) 0 () 1 ((q lib "typed-map/main.rkt")) () (h ! (equal) ((c def c (c (? . 0) q foldl)) q (90 . 5)) ((c def c (c (? . 0) q foldr)) q (204 . 5)) ((c def c (c (? . 0) q map)) q (0 . 4))))
syntax
(map f l ...) -> (Listof B)
  f : (→ A ... B)
  l : (Listof A)
syntax
(foldl f init l ...) -> Acc
  f : (→ A ... Acc Acc)
  init : Acc
  l : (Listof A)
syntax
(foldr f init l ...) -> Acc
  f : (→ A ... Acc Acc)
  init : Acc
  l : (Listof A)
