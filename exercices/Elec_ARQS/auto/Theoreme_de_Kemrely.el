(TeX-add-style-hook
 "Theoreme_de_Kemrely"
 (lambda ()
   (LaTeX-add-environments
    '("cases" LaTeX-env-args ["argument"] 0)))
 :latex)

