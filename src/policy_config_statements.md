# Policy Configuration Statements

- [*policycap*](#policycap)
  - [Adding A New Policy Capability](#adding-a-new-policy-capability)
    - [Kernel Updates](#kernel-updates)
    - [*libsepol* Library Updates](#libsepol-library-updates)
    - [Reference Policy Updates](#reference-policy-updates)
    - [CIL Policy Updates](#cil-policy-updates)

## *policycap*

Policy version 22 introduced the *policycap* statement to allow new
capabilities to be enabled or disabled in the kernel via policy in a
backward compatible way. For example policies that are aware of a new
capability can enable the functionality, while older policies would
continue to use the original functionality.

**The statement definition is:**

```
policycap capability;
```

**Where:**

*policycap*

The *policycap* keyword.

*capability*

A single *capability* identifier that will be enabled for this policy.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Example:**

```
# This statement enables the network_peer_controls to be enabled
# for use by the policy.
#
policycap network_peer_controls;
```

## Adding A New Policy Capability

The kernel, userspace libsepol library and policy must be updated to enable
the new capability as described below. For readability, the new capability
should follow a consistent naming convention, where:

- policy capability identifier is a lower-case string.
- enum definition is ```POLICYDB_CAP_``` with the identifier appended in
  upper-case.
- kernel function call is ```selinux_policycap_``` with the identifier
  appended in lower-case.

### Kernel Updates

In kernel source update the following three files with the new capability:

***security/selinux/include/policycap_names.h***

Add new entry at end of this list:

```
/* Policy capability names */
const char *selinux_policycap_names[__POLICYDB_CAP_MAX] = {
	...
	"genfs_seclabel_symlinks",
	"ioctl_skip_cloexec",
	"new_name"
};
```

***security/selinux/include/policycap.h***

Add new entry at end of this list:

```
/* Policy capabilities */
enum {
	...
	POLICYDB_CAP_GENFS_SECLABEL_SYMLINKS,
	POLICYDB_CAP_IOCTL_SKIP_CLOEXEC,
	POLICYDB_CAP_NEW_NAME,
	__POLICYDB_CAP_MAX
};
```

***security/selinux/include/security.h***

Add a new call to retrieve the loaded policy capability state:

```
static inline bool selinux_policycap_new_name(void)
{
	struct selinux_state *state = &selinux_state;

	return READ_ONCE(state->policycap[POLICYDB_CAP_NEW_NAME]);
}
```

Finally in the updated code that utilises the new policy capability do
something like:

```
if (selinux_policycap_new_name())
	do this;
else
	do that;
```

### *libsepol* Library Updates

In selinux userspace source update the following two files with the new
capability:

***selinux/libsepol/src/polcaps.c***

Add new entry at end of this list:

```
static const char * const polcap_names[] = {
	...
	"genfs_seclabel_symlinks",	/* POLICYDB_CAP_GENFS_SECLABEL_SYMLINKS */
	"ioctl_skip_cloexec",		/* POLICYDB_CAP_IOCTL_SKIP_CLOEXEC */
	"new_name",			/* POLICYDB_CAP_NEW_NAME */
	NULL
};
```

***selinux/libsepol/include/sepol/policydb/polcaps.h***

Add new entry at end of this list:

```
/* Policy capabilities */
enum {
	...
	POLICYDB_CAP_GENFS_SECLABEL_SYMLINKS,
	POLICYDB_CAP_IOCTL_SKIP_CLOEXEC,
	POLICYDB_CAP_NEW_NAME,
	__POLICYDB_CAP_MAX
};
```

### Reference Policy Updates

To enable the new capability in Reference Policy, add a new entry to this file:

***policy/policy_capabilities***

New *policycap* statement added to end of file:

```
# A description of the capability
policycap new_name;
```

To disable the capability, comment out the entry:

```
# A description of the capability
#policycap new_name;
```

### CIL Policy Updates

To enable the capability in policy, add the following entry to a CIL
source file:

```
; A description of the capability
(policycap new_name)
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](kernel_policy_language.md)** **[[ TOP ]](#)** **[[ NEXT ]](default_rules.md)**
