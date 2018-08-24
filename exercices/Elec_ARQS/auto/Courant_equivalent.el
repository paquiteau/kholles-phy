(TeX-add-style-hook
 "Courant_equivalent"
 (lambda ()
   (LaTeX-add-environments
    '("cases" LaTeX-env-args ["argument"] 0)))
 :latex)

