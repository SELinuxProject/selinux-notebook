# Modular Policy Support Statements

- [*module*](#module)
- [*require*](#require)
- [*optional*](#optional)

This section contains statements used to support policy modules. They are
not part of the kernel policy language.

## *module*

This statement is mandatory for loadable modules (non-base) and must be
the first line of any module policy source file. The identifier should
not conflict with other module names within the overall policy,
otherwise it will over-write an existing module when loaded via the
semodule command. The *semodule -l* command can be used to list all active
modules within the policy.

**The statement definition is:**

```
module module_name version_number;
```

**Where:**

*module*

The *module* keyword.

*module_name*

The *module* name.

*version_number*

The module version number in M.m.m format (where M = major version number
and m = minor version numbers). Since Reference Policy release 2.20220106
the *version_number* argument is optional. If missing '1' is set as a default
to satisfy the policy syntax.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Example:**

```
# Using the module statement to define a loadable module called
# bind with a version 1.0.0:

module bind 1.0.0;
```

## *require*

The require statement is used for two reasons:

1. Within loadable module policy source files to indicate what policy
   components are required from an external source file (i.e. they are
   not explicitly defined in this module but elsewhere). The examples
   below show the usage.
2. Within a base policy source file, but only if preceded by the
   [***optional***](#optional) to indicate what policy components
   are required from an external source file (i.e. they are not
   explicitly defined in the base policy but elsewhere). The examples
   below show the usage.

**The statement definition is:**

```
require { rule_list }
```

**Where:**

*require*

The *require* keyword.

*require_list*

One or more specific statement keywords with their required identifiers
in a semi-colon ';' separated list enclosed within braces '{}'. The examples
below show these in detail. The valid statement keywords are:

- *role*, *type*, *attribute*, *user*, *bool*, *sensitivity* and
  *category* - The keyword is followed by one or more identifiers in a
  comma ',' separated list, with the last entry being terminated with a
  semi-colon ';'.
- *class* - The class keyword is followed by a single object class identifier
  and one or more permissions. Multiple permissions consist of a space
  separated list enclosed within braces '{}'. The list is then terminated
  with a semi-colon ';'.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| No | Yes (only if proceeded by the *optional* Statement) | Yes              |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| Yes (only if proceeded by the *optional* Statement) | Yes       | No        |

**Examples:**

```
# A series of require statements showing various entries:
require {
	role system_r;
	class security { compute_av compute_create compute_member
	check_context load_policy compute_relabel compute_user
	setenforce setbool setsecparam setcheckreqprot };
	class capability2 { mac_override mac_admin };
}

#
require {
	attribute direct_run_init, direct_init, direct_init_entry;
	type initrc_t;
	role system_r;
	attribute daemon;
}

#
require {
	type nscd_t, nscd_var_run_t;
	class nscd { getserv getpwd getgrp gethost shmempwd shmemgrp
	shmemhost shmemserv };
}
```

## *optional*

The optional statement is used to indicate what policy statements may or
may not be present in the final compiled policy. The statements will be
included in the policy only if all statements within the optional `{ rule
list }` can be expanded successfully, this is generally achieved by using
a [***require***](#require) statement at the start of the list.

**The statement definition is:**

```
optional { rule_list } [ else { rule_list } ]
```

**Where:**

*optional*

The *optional* keyword.

*rule_list*

One or more statements enclosed within braces '{}'. The list of valid
statements is given in
[**Table 3:** of the Kernel Policy Language](kernel_policy_language.md#kernel-policy-language)
section.

*else*

An optional *else* keyword.

*rule_list*

As the *rule_list* above.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | No                      |

**Examples:**

```
# Use of optional block in a base policy source file.
optional {
	require {
		type unconfined_t;
	} # end require

	allow acct_t unconfined_t:fd use;
} # end optional

# Use of optional / else blocks in a base policy source file.
optional {
	require {
		type ping_t, ping_exec_t;
	} # end require

	allow dhcpc_t ping_exec_t:file { getattr read execute };
	.....

	require {
		type netutils_t, netutils_exec_t;
	} # end require

	allow dhcpc_t netutils_exec_t:file { getattr read execute };
	.....

	type_transition dhcpc_t netutils_exec_t:process netutils_t;
	...
} else {
	allow dhcpc_t self:capability setuid;
	.....

} # end optional
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](xen_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](reference_policy.md)**
