(TeX-add-style-hook
 "exbook"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "a4paper" "includeheadfoot" "hmarginratio=1:1" "outer=1.8cm" "vmarginratio=1:1" "bmargin=1.3cm") ("exercise" "lastexercise")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "book"
    "bk10"
    "graphicx"
    "geometry"
    "hyperref"
    "exercise")
   (TeX-add-symbols
    "saveparinfos"
    "useparinfo"
    "subtitle"
    "orgbeginExerciseEnv"
    "orgendExerciseEnv"
    "orgbeginAnswerEnv"
    "orgendAnswerEnv"))
 :latex)

