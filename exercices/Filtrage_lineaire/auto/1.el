(TeX-add-style-hook
 "1"
 (lambda ()
   (LaTeX-add-environments
    '("cases" LaTeX-env-args ["argument"] 0)))
 :latex)

