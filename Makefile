#
# This is work in progress as the PDF files produced have issues
# rendering complex tables and/or images to fit a page.
#

CWD ?= $(shell pwd)
IMAGES = ../images
EXAMPLES = ../notebook-examples
HTMLDIR ?= $(CWD)/html
PDFDIR ?= $(CWD)/pdf
TMPDIR ?= $(CWD)/tmp

PDFIMAGE=$(subst /,\/,${CWD}/images)
PDF_OUT=SELinux_Notebook.pdf
HTML_OUT=SELinux_Notebook.html
SED = sed
PANDOC = pandoc
PANDOC_OPTS=-V geometry:margin=.75in -V linkcolor:blue -V mainfont='DejaVu Serif' -V monofont='DejaVu Sans Mono'

# These are in README.md index order
FILE_LIST = README.md \
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
	libselinux_functions.md \
	object_classes_permissions.md \
	selinux_cmds.md \
	debug_policy_hints.md \
	policy_validation_example.md

TMP_FILE_LIST = $(addprefix $(TMPDIR)/,$(FILE_LIST))

all: html pdf

pdf: $(FILE_LIST)
	mkdir -p $(PDFDIR)
	mkdir -p $(TMPDIR)
	cp -f $(FILE_LIST) $(TMPDIR)/
	# Chop its nuts off and add page break for PDF output:
	for i in $(FILE_LIST) ; do \
		$(SED) -i '/<!-- Cut Here -->/Q' $(TMPDIR)/$$i ; \
		# --pdf-engine=weasyprint requires this for page breaks: \
		echo "<div style='page-break-after:always'></div>" >> $(TMPDIR)/$$i ; \
		# --pdf-engine=xelatex requires this for page breaks: \
		# echo "\newpage" >> $(TMPDIR)/$$i ; \
	done
	# Make one file
	cat $(TMP_FILE_LIST) > $(TMPDIR)/full_document.md
	# Embed the images into the PDF
	$(SED) -i 's/!\[].*\images/!\[]('"$(PDFIMAGE)"'/' $(TMPDIR)/full_document.md
	$(SED) -i 's/](.*\.md#/](#/' $(TMPDIR)/full_document.md
	# Remove the section file name from all HTML links
	$(SED) -i 's/href=.*\.md#/href="#/' $(TMPDIR)/full_document.md
	# Add style for table lines
	$(SED) -i '1i <head>\n<style>\ntable {\n  border-collapse: collapse;\n}\ntable, td, tr, th {\n  border: 1px solid black;\n}\n</style>\n</head>\n' $(TMPDIR)/full_document.md
	$(PANDOC) --pdf-engine=weasyprint $(PANDOC_OPTS) --standalone $(TMPDIR)/full_document.md -o $(PDFDIR)/W-$(PDF_OUT)
	$(PANDOC) --pdf-engine=xelatex $(PANDOC_OPTS) --standalone $(TMPDIR)/full_document.md -o $(PDFDIR)/X-$(PDF_OUT)
	ln -s $(EXAMPLES) $(PDFDIR)/notebook-examples

html: $(FILE_LIST)
	mkdir -p $(TMPDIR)
	mkdir -p $(HTMLDIR)
	cp -f $(FILE_LIST) $(TMPDIR)/
	# Chop its nuts off and add page break for PDF output:
	for i in $(FILE_LIST) ; do \
		$(SED) -i '/<!-- Cut Here -->/Q' $(TMPDIR)/$$i ; \
		# --pdf-engine=weasyprint requires this for page breaks: \
		echo "<div style='page-break-after:always'></div>" >> $(TMPDIR)/$$i ; \
		# --pdf-engine=xelatex requires this for page breaks: \
		# echo "\newpage" >> $(TMPDIR)/$$i ; \
	done
	# Make one file
	cat $(TMP_FILE_LIST) > $(TMPDIR)/full_document.md
	# Remove the section file name from all MD links
	$(SED) -i 's/](.*\.md#/](#/' $(TMPDIR)/full_document.md
	# Remove the section file name from all HTML links
	$(SED) -i 's/href=.*\.md#/href="#/' $(TMPDIR)/full_document.md
	# Add style for table lines
	$(SED) -i '1i <head>\n<style>\ntable {\n  border-collapse: collapse;\n}\ntable, td, tr, th {\n  border: 1px solid black;\n}\n</style>\n</head>\n' $(TMPDIR)/full_document.md
	$(PANDOC) -t html $(TMPDIR)/full_document.md -o $(HTMLDIR)/$(HTML_OUT)
	ln -s $(IMAGES) $(HTMLDIR)/images
	ln -s $(EXAMPLES) $(HTMLDIR)/notebook-examples
	$(PANDOC) --pdf-engine=weasyprint $(PANDOC_OPTS) --standalone $(HTMLDIR)/$(HTML_OUT) -o $(HTMLDIR)/W-$(PDF_OUT)
	$(PANDOC) --pdf-engine=xelatex $(PANDOC_OPTS) --standalone $(HTMLDIR)/$(HTML_OUT) -o $(HTMLDIR)/X-$(PDF_OUT)

clean:
	rm -rf $(HTMLDIR)
	rm -rf $(PDFDIR)
	rm -rf $(TMPDIR)
