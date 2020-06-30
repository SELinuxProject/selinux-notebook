# build-sepolicy

This will build CIL or kernel policy files based on the Reference Policy
*initial_sids*, *security_classes* and *access_vectors* Flask files.

See the *cil/README.md* and *kernel/README.md* for build details.

```
Usage: build-sepolicy [-k] [-M] [-c|-p|-s] -d flask_directory -o output_file

	-k	Output kernel classes only (exclude # userspace entries in the
		security_classes file).
	-M	Output an MLS policy.
	-c	Output a policy in CIL language (otherwise gererate a kernel policy
		language policy).
	-p	Output a file containing class and classpermissionsets + their order
		for use by CIL policies.
	-s	Output a file containing initial SIDs + their order for use by
		CIL policies.
	-o	The output file that will contain the policy source or header file.
	-d	Directory containing the initial_sids, security_classes and
		access_vectors Flask files.
```
