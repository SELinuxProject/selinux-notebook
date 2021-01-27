#### Build android-10 base policy Makefile ####

# git clone https://android.googlesource.com/platform/system/sepolicy
# cd sepolicy
# git checkout android10-dev
# Copy this Makefile to the sepolicy directory and run 'make' to build the
# policy files.
#
# The policy.conf file can be examined with a text editor and the binary
# sepolicy file can be viewed using tools such as apol(1).
#
# Note this is built with 'target_build_variant=user' and will not have the
# 'su' permissive domain. Set to 'eng' to add 'su' permissive domain.

build_policy:
	m4 -D mls_num_sens=1 \
		-D mls_num_cats=1024 \
		-D target_build_variant=user \
		-D target_recovery=false \
		-s private/security_classes \
		private/initial_sids \
		private/access_vectors \
		public/global_macros \
		public/neverallow_macros \
		private/mls_macros \
		private/mls_decl \
		private/mls \
		private/policy_capabilities \
		public/te_macros \
		public/attributes \
		public/ioctl_defines \
		public/ioctl_macros \
		public/*.te \
		private/*.te \
		private/roles_decl \
		public/roles \
		private/users \
		private/initial_sid_contexts \
		private/fs_use \
		private/genfs_contexts \
		private/port_contexts > policy.conf
	checkpolicy -U deny -M -o sepolicy policy.conf
