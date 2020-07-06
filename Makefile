#
# This is work in progress as the PDF files produced have issues
# rendering complex tables and/or images to fit a page.
#

CWD ?= $(shell pwd)
IMAGES = ../images
EXAMPLES = ../notebook-examples
HTMLDIR ?= $(CWD)/html
PDFDIR ?= $(CWD)/pdf
TMPDIR ?= $(CWD)/.tmp

HTML_OUT = SELinux_Notebook.html
PDF_OUT = SELinux_Notebook.pdf
PDFIMAGE=$(subst /,\/,$(CWD)/images)
SED = sed
PANDOC = pandoc
PANDOC_OPTS=-V mainfont='DejaVu Serif' -V monofont='DejaVu Sans Mono'

METADATA = metadata.yaml

# These are in README.md index order
FILE_LIST = \
	README.md \
	terminology.md \
	selinux_overview.md \
	core_components.md \
	mac.md \
	users.md \
	rbac.md \
	type_enforcement.md \
	security_context.md \
	subjects.md \
	objects.md \
	computing_security_contexts.md \
	computing_access_decisions.md \
	domain_object_transitions.md \
	mls_mcs.md \
	types_of_policy.md \
	modes.md \
	auditing.md \
	polyinstantiation.md \
	pam_login.md \
	lsm_selinux.md \
	userspace_libraries.md \
	network_support.md \
	vm_support.md \
	x_windows.md \
	postgresql.md \
	apache_support.md \
	configuration_files.md \
	global_config_files.md \
	policy_store_config_files.md \
	policy_config_files.md \
	policy_languages.md \
	cil_overview.md \
	kernel_policy_language.md \
	policy_config_statements.md \
	default_rules.md \
	user_statements.md \
	role_statements.md \
	type_statements.md \
	bounds_rules.md \
	avc_rules.md \
	xperm_rules.md \
	class_permission_statements.md \
	conditional_statements.md \
	constraint_statements.md \
	mls_statements.md \
	sid_statement.md \
	file_labeling_statements.md \
	network_statements.md \
	infiniband_statements.md \
	xen_statements.md \
	modular_policy_statements.md \
	reference_policy.md \
	implementing_seaware_apps.md \
	seandroid.md \
	object_classes_permissions.md \
	libselinux_functions.md \
	selinux_cmds.md \
	debug_policy_hints.md \
	policy_validation_example.md

TMP_FILE_LIST = $(addprefix $(TMPDIR)/,$(FILE_LIST))

all: html pdf

.PHONY: pdf
pdf: $(FILE_LIST) $(METADATA)
	mkdir -p $(TMPDIR)/pdf $(PDFDIR)
	cp -f $(FILE_LIST) $(TMPDIR)/pdf
	for i in $(FILE_LIST) ; do \
		$(SED) -i '/<!-- Cut Here -->/Q' $(TMPDIR)/pdf/$$i ; \
		echo "<div style='page-break-after:always'></div>" \
			>> $(TMPDIR)/pdf/$$i ; \
	done
	cat $(METADATA) > $(TMPDIR)/pdf/full_document.md
	cat $(addprefix $(TMPDIR)/pdf/,$(FILE_LIST)) \
		>> $(TMPDIR)/pdf/full_document.md
	# Embed the images into the PDF
	$(SED) -i 's/!\[].*\images/!\[]('"$(PDFIMAGE)"'/' \
		$(TMPDIR)/pdf/full_document.md
	$(SED) -i 's/](.*\.md#/](#/' $(TMPDIR)/pdf/full_document.md
	# Remove the section file name from all HTML links
	$(SED) -i 's/href=.*\.md#/href="#/' $(TMPDIR)/pdf/full_document.md
	[ -e $(PDFDIR)/notebook-examples ] || ln -s $(EXAMPLES) $(PDFDIR)
	$(PANDOC) --pdf-engine=weasyprint $(PANDOC_OPTS) \
		--css=styles_pdf.css --self-contained \
		$(TMPDIR)/pdf/full_document.md -o $(PDFDIR)/$(PDF_OUT)

.PHONY: html
html: $(FILE_LIST) $(METADATA)
	mkdir -p $(TMPDIR)/html $(HTMLDIR)
	cp -f $(FILE_LIST) $(TMPDIR)/html
	for i in $(FILE_LIST) ; do \
		$(SED) -i '/<!-- Cut Here -->/Q' $(TMPDIR)/html/$$i ; \
		echo "<div style='page-break-after:always'></div>" \
			>> $(TMPDIR)/html/$$i ; \
	done
	cat $(METADATA) > $(TMPDIR)/html/full_document.md
	cat $(addprefix $(TMPDIR)/html/,$(FILE_LIST)) \
		>> $(TMPDIR)/html/full_document.md
	# Remove the section file name from all MD links
	$(SED) -i 's/](.*\.md#/](#/' $(TMPDIR)/html/full_document.md
	# Remove the section file name from all HTML links
	$(SED) -i 's/href=.*\.md#/href="#/' $(TMPDIR)/html/full_document.md
	[ -e $(HTMLDIR)/images ] || ln -s $(IMAGES) $(HTMLDIR)
	[ -e $(HTMLDIR)/notebook-examples ] || ln -s $(EXAMPLES) $(HTMLDIR)
	$(PANDOC) $(PANDOC_OPTS) \
		--css=styles_html.css --self-contained \
		$(TMPDIR)/html/full_document.md -o $(HTMLDIR)/$(HTML_OUT)

.PHONY: clean
clean:
	rm -rf $(TMPDIR) $(HTMLDIR) $(PDFDIR)
