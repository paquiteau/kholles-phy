(TeX-add-style-hook
 "Microscopie_electronique."
 (lambda ()
   (LaTeX-add-environments
    '("cases" LaTeX-env-args ["argument"] 0)))
 :latex)

