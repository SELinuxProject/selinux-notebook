# Modular Policy Support Statements

This section contains statements used to support policy modules. They are
not part of the kernel policy language.


## `module`

This statement is mandatory for loadable modules (non-base) and must be
the first line of any module policy source file. The identifier should
not conflict with other module names within the overall policy,
otherwise it will over-write an existing module when loaded via the
semodule command. The ***semodule -l*** command can be used to list all active
modules within the policy.

**The statement definition is:**

`module module_name version_number;`

**Where:**

<table>
<tbody>
<tr>
<td><code>module</code></td>
<td>The <code>module</code> keyword.</td>
</tr>
<tr>
<td><code>module_name</code></td>
<td>The <code>module</code> name. </td>
</tr>
<tr>
<td><code>version_number</code></td>
<td>The module version number in M.m.m format (where M = major version number and m = minor version numbers).</td>
</tr>
</tbody>
</table>

**The statement is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>No</td>
<td>No</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example:**

```
# Using the module statement to define a loadable module called
# bind with a version 1.0.0:

module bind 1.0.0;
```

## `require`

The require statement is used for two reasons:

1.  Within loadable module policy source files to indicate what policy
    components are required from an external source file (i.e. they are
    not explicitly defined in this module but elsewhere). The examples
    below show the usage.
2.  Within a base policy source file, but only if preceded by the
    [**`optional`**](#optional) to indicate what policy components
    are required from an external source file (i.e. they are not
    explicitly defined in the base policy but elsewhere). The examples
    below show the usage.

**The statement definition is:**

`require { rule_list }`

**Where:**

<table>
<tbody>
<tr>
<td><code>require</code></td>
<td>The <code>require</code> keyword.</td>
</tr>
<tr>
<td><code>require_list</code></td>
<td><p>One or more specific statement keywords with their required identifiers in a semi-colon ';' separated list enclosed within braces '{}'. </p>
<p>The valid statement keywords are:</p>
<p><code>role</code>, <code>type</code>, <code>attribute</code>, <code>user</code>, <code>bool</code>, <code>sensitivity</code> and <code>category</code>. The keyword is followed by one or more identifiers in a comma ',' separated list, with the last entry being terminated with a semi-colon (;).</p>
<p><code>class</code> - The class keyword is followed by a single object class identifier and one or more permissions. Multiple permissions consist of a space separated list enclosed within braces '{}'. The list is then terminated with a semi-colon ';'.</p>
<p>The examples below show these in detail.</p></td>
</tr>
</tbody>
</table>

**The statement is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes - But only if proceeded by the <code>optional</code> Statement</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>Yes - But only if proceeded by the <code>optional</code> Statement</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

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

## `optional`

The optional statement is used to indicate what policy statements may or
may not be present in the final compiled policy. The statements will be
included in the policy only if all statements within the optional `{ rule
list }` can be expanded successfully, this is generally achieved by using
a [**`require`**](#require) statement at the start of the list.

**The statement definition is:**

`optional { rule_list } [ else { rule_list } ]`

**Where:**

<table>
<tbody>
<tr>
<td><code>optional</code></td>
<td>The <code>optional</code> keyword.</td>
</tr>
<tr>
<td><code>rule_list</code></td>
<td>One or more statements enclosed within braces '{}'. The list of valid statements is given in <em><a href="kernel_policy_language.md#kernel-policy-language"><strong>Table 3:</strong> The policy language statements and rules that are allowed within each type of policy source file</a></em>.</td>
</tr>
<tr>
<td><code>else</code></td>
<td>An optional <code>else</code> keyword.</td>
</tr>
<tr>
<td><code>rule_list</code></td>
<td>As the <code>rule_list</code> above.</td>
</tr>
</tbody>
</table>

**The statement is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
</tbody>
</table>

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
