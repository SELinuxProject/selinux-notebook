# Sample Policy Builds

**Have a recovery disk at the ready**

This area contains the following:

***tools*** - Contains the `build-sepolicy` script and man page. This is used
to build the kernel and CIL policy files. It does have many hardcoded items.
Another basic kernel policy build is avilable in the kernel source, see the
*scripts/selinux/mdp* and *Documentation/admin-guide/LSM/SELinux.rst* files.

***cil*** - Contains the CIL_Reference_Guide, Makefile to build CIL policy
(MLS or non MLS).

***kernel*** - Contains the Makefile to build kernel language policy
(MLS or non MLS).

***policy-files*** - Contains the kernel and CIL policy configuration files.

***flask-files*** - Contains the Fedora 31 policy source initial_sids,
security_classes and access_vectors flask files.

<br>

## Building the Kernel Source MDP

**Note** that the kernel mdp `install_policy.sh` script will not build
the policy if SELinux is already enabled. The sample MLS policy source
can be built after a kernel build by:

	./mdp -m policy.conf file_contexts

**IMPORTANT:** If the MDP policy is going to run on a system with
Xwayland, then the XSELinux object manager **must be** disabled
by adding the highlighted `bool` statement in the *policy.conf*
file (as on Fedora 32 WS it currently core dumps if enabled
when in permissive mode):

```
mlsconstrain lockdown {
	integrity
	confidentiality
} (l2 eq h2 and h1 dom h2);
```
**`bool xserver_object_manager false;`**
```
type base_t;
```

The binary policy can then be built by:

	checkpolicy -U allow -M -c 32 -o policy.32 policy.conf
