(TeX-add-style-hook
 "seance"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1") ("babel" "french") ("siunitx" "separate-uncertainty=true") ("circuitikz" "european" "cuteinductors" "siunitx" "straightvoltages")))
   (TeX-run-style-hooks
    "/home/pierre-antoine/Scripts/Raccourcis"
    "inputenc"
    "fontenc"
    "eurosym"
    "babel"
    "nopageno"
    "amsmath"
    "amsfonts"
    "amssymb"
    "cancel"
    "siunitx"
    "tikz"
    "circuitikz")
   (TeX-add-symbols
    '("gdr" 3))
   (LaTeX-add-siunitx-units
    "v"))
 :latex)

