(TeX-add-style-hook
 "6"
 (lambda ()
   (LaTeX-add-environments
    '("cases" LaTeX-env-args ["argument"] 0)))
 :latex)

