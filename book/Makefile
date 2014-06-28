# This is Makefile for building LaTeX documents.
# Usage: make <command>
# Available commands:
#   <without command> - build PDF from TEX
#   clean - remove build directory
#   cleanall - remove build directory and tarballs
#   tarball - create tarball (without build directory, so without PDF)
#

# Editable parameters
# ===================

# set target to the name of the main file without the .tex
# (the default value 'document' is overridden by the command line value)
target = book

# set path to graphics storage
GRAPHICS_PATH = graphics

# You may set extra directories, where latex will search .tex, .cls, graphics and others.
# Separator in TEXINPUTS is : (TEXINPUTS _must_ end with :).
# Example:
TEXINPUTS = $(GRAPHICS_PATH):


# DO NOT edit anything below if you unsure
# ========================================

# directory for latex auxiliary and temporary files
AUX_DIR = build
TEX = TEXINPUTS=$(TEXINPUTS) latex --output-directory=$(AUX_DIR)
#TEX2HTML = TEXINPUTS=$(TEXINPUTS) latex2html --dir $(AUX_DIR) --rootdir $(AUX_DIR)
#TEX2HTML = TEXINPUTS=$(TEXINPUTS) htlatex
#TEX2HTML_OPTIONS = 
DVIPS = TEXINPUTS=$(TEXINPUTS) dvips
MAKEINDEX = makeindex
EXCLUDE_PATTERN = --exclude=$(AUX_DIR)

# sam2p is an image convertor from any format to EPS
SAM2P = sam2p

#$(target).html : $(target).tex 
#	$(TEX2HTML) $(target).tex $(TEX2HTML_OPTIONS)

$(AUX_DIR)/$(target).pdf : $(AUX_DIR)/$(target).ps
	ps2pdf $(AUX_DIR)/$(target).ps $(AUX_DIR)/$(target).pdf

$(AUX_DIR)/$(target).ps : $(AUX_DIR)/$(target).dvi
	$(DVIPS) $(AUX_DIR)/$(target).dvi -o $(AUX_DIR)/$(target).ps

$(AUX_DIR)/$(target).dvi : graphics preamble.tex $(target).tex blocks/* 
	mkdir -p $(AUX_DIR)
	# check for bibliography file and execute bibtex if needed
	@if [ -f *.bib ] ; \
		then echo "processing bibliography..." ; \
		$(TEX) $(target).tex ; bibtex $(AUX_DIR)/$(target) ; $(TEX) $(target).tex \
		else echo "no bibliography found." ; \
		fi
	@if [ -f $(AUX_DIR)/$(target).nlo ] ; \
		then echo "processing nomenclature..." ; \
		$(MAKEINDEX) $(AUX_DIR)/$(target).nlo -s nomencl.ist -o $(AUX_DIR)/$(target).nls ; \
		fi
	# run latex several times until all references are resolved from *.aux files
	@while ($(TEX) $(target).tex && \
		grep -q "Rerun to get " $(AUX_DIR)/$(target).log ); do \
			echo "rebuilding until all references resolved..." ; \
		done

GRAPHICS = $(wildcard $(GRAPHICS_PATH)/*.png)
EPS_GRAPHICS = $(patsubst %.png,%.eps,$(GRAPHICS))

graphics : $(EPS_GRAPHICS)

%.eps : %.png
	$(SAM2P) $< $@


clean :
	rm -r $(AUX_DIR) $(GRAPHICS_PATH)/*.eps

cleanall :
	rm -r $(AUX_DIR) *.tar.gz $(GRAPHICS_PATH)/*.eps

# create archive with complete file set 
# (tex, styles, bibliography and final documents)
tarball:
	tar -czvf $(target).tar.gz $(EXCLUDE_PATTERN) * 
