#### Build brillo-m10 base policy Makefile ####

# git clone https://android.googlesource.com/platform/external/sepolicy
# cd sepolicy
# git checkout brillo-m10-release
# Copy this Makefile to the sepolicy directory and run 'make' to build the
# policy files.
#
# The policy.conf file can be examined with a text editor and the binary
# sepolicy file can be viewed using tools such as apol(1).
#
# Note this is built with 'target_build_variant=eng' and will have the 'su'
# permissive domain. Set to 'user' to remove the 'su' permissive domain.

build_policy:
	m4 -D mls_num_sens=1 \
		-D mls_num_cats=1024 \
		-D target_build_variant=eng \
		-D target_recovery=false \
		-s security_classes \
		initial_sids \
		access_vectors \
		global_macros \
		mls_macros \
		mls \
		policy_capabilities \
		te_macros \
		neverallow_macros \
		attributes \
		ioctl_macros \
		*.te \
		roles \
		users \
		initial_sid_contexts \
		fs_use \
		genfs_contexts \
		port_contexts > policy.conf
	checkpolicy -U deny -M -o sepolicy policy.conf
