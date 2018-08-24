BOOKS_DIR=books/
EXBOOKS := $(wildcard $(BOOKS_DIR)/*.bk)
TARGETS = $(EXBOOKS:$(BOOKS_DIR)/%.bk=%)

PDF = $(TARGETS:%=%.pdf)

MAKE_EXBOOK=./exbook.py

LATEX=pdflatex -interaction=nonstop-mode -halt-on-error

############################################################
### Targets

default: complet.pdf

all: $(PDF)

clean:
	@rm -f $(TARGETS:%=%.tex) $(TARGETS:%=%.aux) $(TARGETS:%=%.toc) $(TARGETS:%=%.out) $(TARGETS:%=%.log) $(TARGETS:%=%.loe)
	@rm -f *.pyc

cleanall: clean
	@rm -f $(PDF)

############################################################

$(PDF): %.pdf: %.tex

%.tex: $(BOOKS_DIR)/%.bk
	$(MAKE_EXBOOK) -b $< -o $@

%.pdf:
	$(LATEX) $< ; $(LATEX) $<
