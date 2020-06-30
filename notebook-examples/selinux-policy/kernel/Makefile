#
###############################################################
#                                                             #
# Makefile for the Kernel Policy                              #
#                                                             #
###############################################################
#

BASE_DIR = /etc/selinux
FLASK_FILES = ../flask-files
POLICY_FILES = ../policy-files
TOOLS = ../tools
POL_VERS := $(shell checkpolicy -V | cut -f 1 -d ' ')

build_policy:
	$(TOOLS)/build-sepolicy -o policy.conf -d $(FLASK_FILES)
	checkpolicy -U allow -c $(POL_VERS) -o policy.$(POL_VERS) policy.conf

build_mls_policy:
	$(TOOLS)/build-sepolicy -M -o mls-policy.conf -d $(FLASK_FILES)
	checkpolicy -U allow -M -c $(POL_VERS) -o mls-policy.$(POL_VERS) mls-policy.conf

install_policy: build_policy
	mkdir -p $(BASE_DIR)/nb-kernel/policy
	mkdir -p $(BASE_DIR)/nb-kernel/contexts/files
	install -m 644 $(POLICY_FILES)/seusers $(BASE_DIR)/nb-kernel
	install -m 644 $(POLICY_FILES)/dbus_contexts $(BASE_DIR)/nb-kernel/contexts
	install -m 644 $(POLICY_FILES)/default_contexts $(BASE_DIR)/nb-kernel/contexts
	install -m 644 $(POLICY_FILES)/default_type $(BASE_DIR)/nb-kernel/contexts
	install -m 644 $(POLICY_FILES)/x_contexts $(BASE_DIR)/nb-kernel/contexts
	install -m 644 $(POLICY_FILES)/file_contexts $(BASE_DIR)/nb-kernel/contexts/files
	install -m 644 policy.$(POL_VERS) $(BASE_DIR)/nb-kernel/policy

install_mls_policy: build_mls_policy
	mkdir -p $(BASE_DIR)/nb-mls-kernel/policy
	mkdir -p $(BASE_DIR)/nb-mls-kernel/contexts/files
	install -m 644 $(POLICY_FILES)/mls/seusers $(BASE_DIR)/nb-mls-kernel
	install -m 644 $(POLICY_FILES)/dbus_contexts $(BASE_DIR)/nb-mls-kernel/contexts
	install -m 644 $(POLICY_FILES)/mls/default_contexts $(BASE_DIR)/nb-mls-kernel/contexts
	install -m 644 $(POLICY_FILES)/mls/default_type $(BASE_DIR)/nb-mls-kernel/contexts
	install -m 644 $(POLICY_FILES)/mls/x_contexts $(BASE_DIR)/nb-mls-kernel/contexts
	install -m 644 $(POLICY_FILES)/mls/file_contexts $(BASE_DIR)/nb-mls-kernel/contexts/files
	install -m 644 mls-policy.$(POL_VERS) $(BASE_DIR)/nb-mls-kernel/policy/policy.$(POL_VERS)

clean:
	rm -f *.$(POL_VERS)
	rm -f *.conf
