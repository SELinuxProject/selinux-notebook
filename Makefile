#
# This is work in progress as the PDF files produced have issues
# rendering complex tables and/or images to fit a page.
#

CWD ?= $(shell pwd)
SCRIPTS = $(CWD)/scripts
SRCDIR = $(CWD)/src
HTMLDIR ?= $(CWD)/html
PDFDIR ?= $(CWD)/pdf
IMAGES = $(SRCDIR)/images
EXAMPLES = $(SRCDIR)/notebook-examples
METADATA = $(SRCDIR)/metadata.yaml

HTML_OUT = SELinux_Notebook.html
PDF_OUT = SELinux_Notebook.pdf

SED = sed
PANDOC = pandoc
PANDOC_OPTS=-V mainfont='DejaVu Serif' -V monofont='DejaVu Sans Mono'

# the individual section files, in order
FILE_LIST = $(shell cat src/section_list.txt)
DEP_FILE_LIST = $(addprefix src/,$(FILE_LIST))

all: html pdf

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

.PHONY: pdf
pdf: $(DEP_FILE_LIST) $(METADATA)
	mkdir -p $(PDFDIR)
	cat $(METADATA) > $(PDFDIR)/.full_document.md
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
	[ -e $(PDFDIR)/images ] || ln -s $(IMAGES) $(PDFDIR)
	[ -e $(PDFDIR)/notebook-examples ] || ln -s $(EXAMPLES) $(PDFDIR)
	(cd $(PDFDIR); $(PANDOC) --pdf-engine=weasyprint $(PANDOC_OPTS) \
		--css=$(SRCDIR)/styles_pdf.css --self-contained \
		$(PDFDIR)/.full_document.md -o $(PDFDIR)/$(PDF_OUT))

.PHONY: html
html: $(DEP_FILE_LIST) $(METADATA)
	mkdir -p $(HTMLDIR)
	cat $(METADATA) > $(HTMLDIR)/.full_document.md
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

.PHONY: clean
clean:
	rm -rf $(HTMLDIR) $(PDFDIR)
