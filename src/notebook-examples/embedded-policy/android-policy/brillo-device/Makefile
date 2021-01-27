#### Build brillo-m10 + device policy Makefile ####

# git clone https://android.googlesource.com/platform/external/sepolicy
# cd sepolicy
# git checkout brillo-m10-release
# Copy this Makefile to the sepolicy directory and run 'make' to build the
# policy files.
#
# To obtain a buildable device the brillo-m7-dev tar file is downloaded and
# installed into the sepolicy directory.
#
# The policy.conf file can be examined with a text editor and the binary
# sepolicy file can be viewed using tools such as apol(1).

DEV_DIR := brillo-m7-dev

build_policy:
	mkdir -p $(DEV_DIR)
	wget https://android.googlesource.com/device/generic/brillo/+archive/refs/heads/brillo-m7-dev.tar.gz -O - | tar -C $(DEV_DIR) -xz
	m4 -D mls_num_sens=1 \
		-D mls_num_cats=1024 \
		-D target_build_variant=eng \
		-D target_recovery=false \
		-s security_classes \
		$(DEV_DIR)/sepolicy/security_classes \
		initial_sids \
		access_vectors \
		$(DEV_DIR)/sepolicy/access_vectors \
		global_macros \
		mls_macros \
		mls \
		policy_capabilities \
		te_macros \
		$(DEV_DIR)/sepolicy/te_macros \
		neverallow_macros \
		attributes \
		ioctl_macros \
		*.te \
		$(DEV_DIR)/sepolicy/*.te \
		roles \
		users \
		initial_sid_contexts \
		fs_use \
		genfs_contexts \
		port_contexts > policy.conf
	checkpolicy -U deny -M -o sepolicy policy.conf
