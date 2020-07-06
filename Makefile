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

DEP_FILE_LIST = $(addprefix src/,$(FILE_LIST))

all: html pdf

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
