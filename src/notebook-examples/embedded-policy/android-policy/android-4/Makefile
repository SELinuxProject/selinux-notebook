#### Build android-4.1.1_r1 base policy Makefile ####

# git clone https://android.googlesource.com/platform/external/sepolicy
# cd sepolicy
# git checkout android-4.1.1_r1
# Copy this Makefile to the sepolicy directory and run 'make' to build the
# policy files.
#
# The policy.conf file can be examined with a text editor and the binary
# sepolicy file can be viewed using tools such as apol(1).

build_policy:
	#
	# Note the order in which the policy.conf file is built:
	#
	m4 -D mls_num_sens=1 \
		-D mls_num_cats=1024 \
		-s security_classes \
		initial_sids \
		access_vectors \
		global_macros \
		mls_macros \
		mls \
		policy_capabilities \
		te_macros \
		attributes \
		*.te \
		roles \
		users \
		ocontexts > policy.conf
	checkpolicy -U deny -M -o sepolicy policy.conf
