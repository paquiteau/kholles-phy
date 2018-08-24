(TeX-add-style-hook
 "3"
 (lambda ()
   (LaTeX-add-environments
    '("cases" LaTeX-env-args ["argument"] 0)))
 :latex)

