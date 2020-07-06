#
###############################################################
#                                                             #
# Makefile for the CIL Policy                                 #
#                                                             #
###############################################################
#

BASE_DIR = /etc/selinux
FLASK_FILES = ../flask-files
POLICY_FILES = ../policy-files
TOOLS = ../tools
POL_VERS := $(shell checkpolicy -V | cut -f 1 -d ' ')

build_policy:
	$(TOOLS)/build-sepolicy -c -o policy.cil -d $(FLASK_FILES)
	secilc -f file_contexts policy.cil -o policy.$(POL_VERS)

build_mls_policy:
	$(TOOLS)/build-sepolicy -c -M -o mls-policy.cil -d $(FLASK_FILES)
	secilc mls-policy.cil -o mls-policy.$(POL_VERS)

install_policy: build_policy
	mkdir -p $(BASE_DIR)/nb-cil/policy
	mkdir -p $(BASE_DIR)/nb-cil/contexts/files
	install -m 644 $(POLICY_FILES)/seusers $(BASE_DIR)/nb-cil
	install -m 644 $(POLICY_FILES)/dbus_contexts $(BASE_DIR)/nb-cil/contexts
	install -m 644 $(POLICY_FILES)/default_contexts $(BASE_DIR)/nb-cil/contexts
	install -m 644 $(POLICY_FILES)/default_type $(BASE_DIR)/nb-cil/contexts
	install -m 644 $(POLICY_FILES)/x_contexts $(BASE_DIR)/nb-cil/contexts
	install -m 644 $(POLICY_FILES)/file_contexts $(BASE_DIR)/nb-cil/contexts/files
	install -m 644 policy.$(POL_VERS) $(BASE_DIR)/nb-cil/policy

install_mls_policy: build_mls_policy
	mkdir -p $(BASE_DIR)/nb-mls-cil/policy
	mkdir -p $(BASE_DIR)/nb-mls-cil/contexts/files
	install -m 644 $(POLICY_FILES)/mls/seusers $(BASE_DIR)/nb-mls-cil
	install -m 644 $(POLICY_FILES)/dbus_contexts $(BASE_DIR)/nb-mls-cil/contexts
	install -m 644 $(POLICY_FILES)/mls/default_contexts $(BASE_DIR)/nb-mls-cil/contexts
	install -m 644 $(POLICY_FILES)/mls/default_type $(BASE_DIR)/nb-mls-cil/contexts
	install -m 644 $(POLICY_FILES)/mls/x_contexts $(BASE_DIR)/nb-mls-cil/contexts
	install -m 644 $(POLICY_FILES)/mls/file_contexts $(BASE_DIR)/nb-mls-cil/contexts/files
	install -m 644 mls-policy.$(POL_VERS) $(BASE_DIR)/nb-mls-cil/policy/policy.$(POL_VERS)

clean:
	rm -f *.$(POL_VERS)
	rm -f *.cil
	rm -f file_contexts
