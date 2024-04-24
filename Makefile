##
# The SELinux Notebook
#

SED = sed
PANDOC = pandoc
# Find if Calibre ebook-convert command is installed, if so produce a
# Kindle version in azw3 format
EBOOK_CONVERT = $(shell whereis -b ebook-convert | cut -f 2 -d :)
CWD ?= $(shell pwd)
SCRIPTS = $(CWD)/scripts
SRCDIR = $(CWD)/src
HTMLDIR ?= $(CWD)/html
PDFDIR ?= $(CWD)/pdf
EPUBDIR ?= $(CWD)/epub
IMAGES = $(SRCDIR)/images
EXAMPLES = $(SRCDIR)/notebook-examples
EXAMPLES_EPUB = $(shell echo $(EXAMPLES) | $(SED) 's;/;\\/;g')
METADATA = $(SRCDIR)/metadata.yaml
EXAMPLES_GITHUB = $(shell echo https://github.com/SELinuxProject/selinux-notebook/tree/main/src/notebook-examples | $(SED) 's;/;\\/;g')

HTML_OUT = SELinux_Notebook.html
PDF_OUT = SELinux_Notebook.pdf
EPUB_OUT = SELinux_Notebook.epub
AZW3_OUT = SELinux_Notebook.azw3

PANDOC_OPTS  = --from markdown+pipe_tables
PANDOC_OPTS += -V mainfont='DejaVu Serif' -V monofont='DejaVu Sans Mono'

# the individual section files, in order
FILE_LIST = $(shell cat src/section_list.txt)
DEP_FILE_LIST = $(addprefix src/,$(FILE_LIST))

help:
	@echo "targets:"
	@grep "^#@ " Makefile | cut -c4-

#@   all             build the PDF, HTML, and EPUB versions
all: html pdf epub

#@   navlinks        update the navigation links in the markdown sources
.PHONY: navlinks
navlinks:
	for i in $(DEP_FILE_LIST); do \
		file=$$(basename $$i); \
		prev=$$(sed -n "/$$file/{x;p;d;}; x" src/section_list.txt); \
		next=$$(sed -n "/$$file/{n;p;}" src/section_list.txt); \
		sed "/<!-- %CUTHERE% -->/q" -i $$i; \
		echo "" >> $$i; \
		echo "---" >> $$i; \
		[[ "x$$prev" != "x" ]] && echo -n "**[[ PREV ]]($$prev)**" >> $$i; \
		echo -n " **[[ TOP ]](#)** " >> $$i; \
		[[ "x$$next" != "x" ]] && echo -n "**[[ NEXT ]]($$next)**" >> $$i; \
		echo "" >> $$i; \
	done

#@   pdf             build PDF version
.PHONY: pdf
pdf: $(DEP_FILE_LIST) $(METADATA)
	mkdir -p $(PDFDIR)
	cat $(METADATA) > $(PDFDIR)/.full_document.md
	cat $(SRCDIR)/cover.md | $(SCRIPTS)/macros_section.sh \
		>> $(PDFDIR)/.full_document.md
	for i in $(DEP_FILE_LIST); do \
		cat $$i | $(SCRIPTS)/macros_section.sh \
			>> $(PDFDIR)/.full_document.md; \
		echo '<!-- %PAGEBREAK% -->' \
			>> $(PDFDIR)/.full_document.md; \
	done
	$(SCRIPTS)/macros_doc.sh $(PDFDIR)/.full_document.md
	# embed the images into the PDF
	$(SED) -i 's/!\[].*\images/!\[]('"$(subst /,\/,./images)"'/' \
		$(PDFDIR)/.full_document.md
	$(SED) -i 's/](.*\.md#/](#/' $(PDFDIR)/.full_document.md
	# remove the section file name from all HTML links
	$(SED) -i 's/href=.*\.md#/href="#/' $(PDFDIR)/.full_document.md
	# fixup path for examples, directing at the github repo
	$(SED) -i 's/](.\/notebook-examples/]($(EXAMPLES_GITHUB)/g' \
		$(PDFDIR)/.full_document.md
	[ -e $(PDFDIR)/images ] || ln -s $(IMAGES) $(PDFDIR)
	[ -e $(PDFDIR)/notebook-examples ] || ln -s $(EXAMPLES) $(PDFDIR)
	(cd $(PDFDIR); $(PANDOC) --pdf-engine=weasyprint $(PANDOC_OPTS) \
		--css=$(SRCDIR)/styles_pdf.css --self-contained \
		$(PDFDIR)/.full_document.md -o $(PDFDIR)/$(PDF_OUT))

#@   html            build HTML version
.PHONY: html
html: $(DEP_FILE_LIST) $(METADATA)
	mkdir -p $(HTMLDIR)
	cat $(METADATA) > $(HTMLDIR)/.full_document.md
	cat $(SRCDIR)/cover.md | $(SCRIPTS)/macros_section.sh \
		>> $(HTMLDIR)/.full_document.md
	for i in $(DEP_FILE_LIST); do \
		cat $$i | $(SCRIPTS)/macros_section.sh \
			>> $(HTMLDIR)/.full_document.md; \
		echo '<!-- %PAGEBREAK% -->' \
			>> $(HTMLDIR)/.full_document.md; \
	done
	$(SCRIPTS)/macros_doc.sh $(HTMLDIR)/.full_document.md
	# remove the section file name from all MD links
	$(SED) -i 's/](.*\.md#/](#/' $(HTMLDIR)/.full_document.md
	# remove the section file name from all HTML links
	$(SED) -i 's/href=.*\.md#/href="#/' $(HTMLDIR)/.full_document.md
	[ -e $(HTMLDIR)/images ] || ln -s $(IMAGES) $(HTMLDIR)
	[ -e $(HTMLDIR)/notebook-examples ] || ln -s $(EXAMPLES) $(HTMLDIR)
	(cd $(HTMLDIR); $(PANDOC) $(PANDOC_OPTS) \
		--css=$(SRCDIR)/styles_html.css --self-contained \
		$(HTMLDIR)/.full_document.md -o $(HTMLDIR)/$(HTML_OUT))

#@   epub            build EPUB version
.PHONY: epub
epub: $(DEP_FILE_LIST) $(METADATA)
	mkdir -p $(EPUBDIR)
	cat $(METADATA) > $(EPUBDIR)/.full_document.md
	cat $(SRCDIR)/cover_epub.md | $(SCRIPTS)/macros_section.sh \
		>> $(EPUBDIR)/.full_document.md
	for i in $(DEP_FILE_LIST); do \
		cat $$i | $(SCRIPTS)/macros_section.sh \
			>> $(EPUBDIR)/.full_document.md; \
		echo '<!-- %PAGEBREAK% -->' \
			>> $(EPUBDIR)/.full_document.md; \
	done
	$(SCRIPTS)/macros_doc.sh $(EPUBDIR)/.full_document.md
	$(SED) -i 's/](.*\.md#/](#/' $(EPUBDIR)/.full_document.md
	# remove the section file name from all HTML links
	$(SED) -i 's/href=.*\.md#/href="#/' $(EPUBDIR)/.full_document.md
	# fixup path for examples, directing at the github repo
	$(SED) -i 's/](.\/notebook-examples/]($(EXAMPLES_GITHUB)/g' \
		$(EPUBDIR)/.full_document.md
	[ -e $(EPUBDIR)/images ] || ln -s $(IMAGES) $(EPUBDIR)
	[ -e $(EPUBDIR)/notebook-examples ] || ln -s $(EXAMPLES) $(EPUBDIR)
	(cd $(EPUBDIR); $(PANDOC) $(PANDOC_OPTS) \
		--epub-cover-image=$(SRCDIR)/images/selinux-penguin.png \
		--css=$(SRCDIR)/styles_epub.css --self-contained \
		$(EPUBDIR)/.full_document.md -o $(EPUBDIR)/$(EPUB_OUT))
	# Convert to Kindle format if Calibre ebook-convert is installed
	[ -b $(EBOOK_CONVERT) ] || $(EBOOK_CONVERT) $(EPUBDIR)/$(EPUB_OUT) \
		$(EPUBDIR)/$(AZW3_OUT)

#@   clean           clean any build artifacts
.PHONY: clean
clean:
	rm -rf $(HTMLDIR) $(PDFDIR) $(EPUBDIR)
