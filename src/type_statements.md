# Type Statements

- [*type*](#type)
- [*attribute*](#attribute)
- [*expandattribute*](#expandattribute)
- [*typeattribute*](#typeattribute)
- [*typealias*](#typealias)
- [*permissive*](#permissive)
- [*type_transition*](#type_transition)
- [*type_change*](#type_change)
- [*type_member*](#type_member)

These statements share the same namespace, therefore the general
convention is to use *\_t* as the final two characters of a *type*
identifier to differentiate it from an attribute identifier as shown in
the following examples:

```
# Statement Identifier  Comment
#----------------------------------------------------------------------------
type bin_t;              # A type identifier generally ends with _t

attribute file_type;     # An attribute identifier generally ends with _type
```

## *type*

The *type* statement declares the type identifier and any optional
associated *alias* or *attribute* identifiers. Type identifiers are a
component of the [**Security Context**](security_context.md#security-context).

**The statement definition is:**

```
type type_id [alias alias_id] [, attribute_id];
```

**Where:**

*type*

The *type* keyword.

*type_id*

The *type* identifier.

*alias*

Optional *alias* keyword that signifies alternate identifiers for the *type_id*
that are declared in the *alias_id* list.

*alias_id*

One or more *alias* identifiers that have been previously declared by the
[*typealias*](#typealias) statement. Multiple entries consist of a space
separated list enclosed in braces '{}'.

*attribute_id*

One or more optional *attribute* identifiers that have been previously declared
by the [*attribute*](#attribute) statement. Multiple entries consist of a comma
',' separated list, also note the lead comma.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | Yes                     |

**Examples:**

```
# Using the type statement to declare a type of shell_exec_t,
# where exec_t is used to identify a file as an executable type.

type shell_exec_t;
```

```
# Using the type statement to declare a type of bin_t, where
# bin_t is used to identify a file as an ordinary program type.

type bin_t;
```

```
# Using the type statement to declare a type of bin_t with two
# alias names. The sbin_t is used to identify the file as a
# system admin program type.

type bin_t alias { ls_exec_t sbin_t };
```

```
# Using the type statement to declare a type of boolean_t that also
# associates it to a previously declared attribute booleans_type statement

attribute booleans_type; # declare the attribute

type boolean_t, booleans_type; # and associate with the type
```

```
# Using the type statement to declare a type of setfiles_t that
# also has an alias of restorecon_t and one previously declared
# attribute of can_relabelto_binary_policy associated with it.

attribute can_relabelto_binary_policy;

type setfiles_t alias restorecon_t, can_relabelto_binary_policy;
```

```
# Using the type statement to declare a type of
# ssh_server_packet_t that also associates it to two previously
# declared attributes packet_type and server_packet_type.

attribute packet_type; # declare attribute 1
attribute server_packet_type; # declare attribute 2

# Associate the type identifier with the two attributes:
type ssh_server_packet_t, packet_type, server_packet_type;
```

## *attribute*

An *attribute* statement declares an identifier that can then be used to
refer to a group of *type* identifiers.

**The statement definition is:**

```
attribute attribute_id;
```

**Where:**

*attribute*

The *attribute* keyword.

*attribute_id*

The *attribute* identifier.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | Yes                     |

**Examples:**

```
# Using the attribute statement to declare attributes domain,
# daemon, file_type and non_security_file_type:

attribute domain;
attribute daemon;
attribute file_type;
attribute non_security_file_type;
```

## *expandattribute*

Overrides the compiler defaults for the expansion of one or more
previously declared [*attribute*](#attribute) identifiers.

This rule gives more control over type attribute expansion and
removal. When the value is true, all rules involving the type
attribute will be expanded and the type attribute will be removed from
the policy. When the value is false, the type attribute will not be
removed from the policy, even if the default expand rules or "-X"
option cause the rules involving the type attribute to be expanded.

**The statement definition is:**

`expandattribute attribute_id expand_value;`

**Where:**

*expandattribute*

The *expandattribute* keyword.

*attribute_id*

One or more *attribute* identifiers that have been previously declared by the
[*attribute*](#attribute) statement. Multiple entries consist of a space
separated list enclosed in braces '{}'.

*expand_value*

Either true or false.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

**Examples:**

```
# Using the expandattribute statement to forcibly expand a
# previously declared domain attribute.

# The previously declared attribute:
attribute domain;

# The attribute stripping using the expandattribute statement:
expandattribute domain true;
```

## *typeattribute*

The *typeattribute* statement allows the association of previously
declared types to one or more previously declared attributes.

**The statement definition is:**

```
typeattribute type_id attribute_id;
```

**Where:**

*typeattribute*

The *typeattribute* keyword.

*type_id*

The identifier of a previously declared *type*.

*attribute_id*

One or more previously declared *attribute* identifiers. Multiple entries
consist of a comma ',' separated list.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | No                      |

**Examples:**

```
# Using the typeattribute statement to associate a previously
# declared type of setroubleshootd_t to a previously declared
# domain attribute.

# The previously declared attribute:
attribute domain;

# The previously declared type:
type setroubleshootd_t;

# The association using the typeattribute statement:
typeattribute setroubleshootd_t domain;
```

```
# Using the typeattribute statement to associate a type of
# setroubleshootd_exec_t to two attributes file_type and
# non_security_file_type.
# These are the previously declared attributes:

attribute file_type;
attribute non_security_file_type;

# The previously declared type:
type setroubleshootd_exec_t;

# These are the associations using the typeattribute statement:
typeattribute setroubleshootd_exec_t file_type, non_security_file_type;
```

## *typealias*

The *typealias* statement allows the association of a previously declared
*type* to one or more *alias* identifiers (an alternative way is to use the
*type* statement).

**The statement definition is:**

```
typealias type_id alias alias_id;
```

**Where:**

*typealias*

The *typealias* keyword.

*type_id*

The identifier of a previously declared *type*.

*alias*

The *alias* keyword.

*alias_id*

One or more *alias* identifiers. Multiple entries consist of a space separated
list enclosed in braces '{}'.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | No                      |

**Examples:**

```
# Using the typealias statement to associate the previously
# declared type mount_t with an alias of mount_ntfs_t.
# Declare the type:
type mount_t;

# Then alias the identifier:
typealias mount_t alias mount_ntfs_t;
```

```
# Using the typealias statement to associate the previously
# declared type netif_t with two alias, lo_netif_t and netif_lo_t.

# Declare the type:
type netif_t;

# Then assign two alias identifiers lo_netif_t and netif_lo_t:
typealias netif_t alias { lo_netif_t netif_lo_t };
```

## *permissive*

Policy version 23 introduced the *permissive* statement to allow the named
domain to run in permissive mode instead of running all SELinux domains
in permissive mode (that was the only option prior to version 23). Note
that the *permissive* statement only tests the source context for any
policy denial.

**The statement definition is:**

```
permissive type_id;
```

**Where:**

*permissive*

The *permissive* keyword.

*type_id*

The *type* identifier of the domain that will be run in permissive mode.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | No                      |

**Examples:**

Set a permissive domain using the ***semanage**(8)* command :

```
# semanage supports enabling and disabling of permissive
# mode using the following command:

semanage permissive -a|d type

# This example will add a new module in:
#     /var/lib/selinux/<SELINUXTYPE>/active/modules/400/
# called permissive_unconfined_t and then reload the policy:

semanage permissive -a unconfined_t
```

Build a loadable policy module so that permissive mode can be easily enabled
or disabled by adding or removing the module:

```
# This is an example loadable module that would allow the
# domain to be set to permissive mode.
#
module permissive_unconfined_t 1.0.0;

require {
	type unconfined_t;
}

permissive unconfined_t;
```

## *type_transition*

The type_transition rule specifies the default type to be used for
domain transistion or object creation. Kernels from 2.6.39 with Policy
versions from 25 also support the 'name transition rule' extension. See the
[**Computing Security Contexts**](computing_security_contexts.md#computing-security-contexts)
section for more details. Note than an *allow* rule must be used to authorise
the transition.

**The statement definitions are:**

```
type_transition source_type target_type : class default_type;
```

Policy versions 25 and above also support a 'name transition' rule
however, this is only appropriate for the file classes:

```
type_transition source_type target_type : class default_type object_name;
```

Kernel 5.12 introduced the 'name transition' rule for anonymous inodes that is
described with an example in the
[**anon_inode Object Class**](object_classes_permissions.md#anon_inode) section.

**Where:**

*type_transition*

The *type_transition* rule keyword.

*source_type*
*target_type*

One or more source / target *type*, *typealias* or *attribute* identifiers.
Multiple entries consist of a space separated list enclosed in braces '{}'.
Entries can be excluded from the list by using the negative operator '-'.

*class*

One or more object classes. Multiple entries consist of a space separated list
enclosed in braces '{}'.

*default_type*

A single *type* or *typealias* identifier that will become the default process
*type* for a domain transition or the *type* for object transitions.

*object_name*

For the 'name transition' rule this is matched against the objects name
(i.e. the last component of a path). If *object_name* exactly matches the
object name, then use *default_type* for the *type*.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement            | *optional* Statement   | *require* Statement     |
| ------------------------- | ---------------------- | ----------------------- |
| Yes (no name transitions) | Yes                    | No                      |

**Example - Domain Transition:**

```
# Using the type_transition statement to show a domain
# transition (as the statement has the process object class).

# The rule states that when a process of type initrc_t executes
# a file of type acct_exec_t, the process type should be changed
# to acct_t if allowed by the policy (i.e. Transition from the
# initrc_t domain to the acc_t domain).

type_transition initrc_t acct_exec_t:process acct_t;

# Note that to be able to transition to the acc_t domain the
# following minimum permissions need to be granted in the policy
# using allow rules (as shown in the allow rule section).
# File needs to be executable in the initrc_t domain:
allow initrc_t acct_exec_t:file execute;

# The executable file needs an entry point into the acct_t domain:
allow acct_t acct_exec_t:file entrypoint;

# Process needs permission to transition into the acct_t domain:
allow initrc_t acct_t:process transition;
```

**Example - Object Transition:**

```
# Using the type_transition statement to show an object
# transition (as it has other than process in the class).
# The rule states that when a process of type acct_t creates a
# file in the directory of type var_log_t, by default it should
# have the type wtmp_t if allowed by the policy.

type_transition acct_t var_log_t:file wtmp_t;

# Note that to be able to create the new file object with the
# wtmp_t type, the following minimum permissions need to be
# granted in the policy using allow rules (as shown in the
# allow rule section).

# A minimum of: add_name, write and search on the var_log_t
# directory. The actual policy has:
#
allow acct_t var_log_t:dir { read getattr lock search ioctl add_name remove_name write };

# A minimum of: create and write on the wtmp_t file. The actual policy has:
#
allow acct_t wtmp_t:file { create open getattr setattr read write append rename link unlink ioctl lock };
```

**Example - Name Transition:**

```
# type_transition to allow using the last path component as
# part of the information in making labeling decisions for
# new objects. An example rule:
#

type_transition unconfined_t etc_t : file system_conf_t eric;

# This rule says if unconfined_t creates a file in a directory
# labeled etc_t and the last path component is "eric" (must be
# an exact strcmp) it should be labeled system_conf_t.
```

## *type_change*

The *type_change* rule specifies a default *type* when relabeling an
existing object. For example userspace SELinux-aware applications would
use ***security_compute_relabel**(3)* and *type_change* rules in
policy to determine the new context to be applied. Note that an *allow*
rule must be used to authorise access. See the
[**Computing Security Contexts**](computing_security_contexts.md#computing-security-contexts)
section for more details.

**The statement definition is:**

```
type_change source_type target_type : class change_type;
```

**Where:**

*type_change*

The *type_change* rule keyword.

*source_type*
*target_type*

One or more source / target *type*, *typealias* or *attribute* identifiers.
Multiple entries consist of a space separated list enclosed in braces '{}'.
Entries can be excluded from the list by using the negative operator '-'.

*class*

One or more object classes. Multiple entries consist of a space separated list
enclosed in braces '{}'.

*change_type*

A single *type* or *typealias* identifier that will become the new *type*. 

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

**Examples:**

```
# Using the type_change statement to show that when relabeling a
# character file with type sysadm_devpts_t on behalf of
# auditadm_t, the type auditadm_devpts_t should be used:

type_change auditadm_t sysadm_devpts_t:chr_file auditadm_devpts_t;
```

```
# Using the type_change statement to show that when relabeling a
# character file with any type associated to the attribute
# server_ptynode on behalf of staff_t, the type staff_devpts_t
# should be used:

type_change staff_t server_ptynode:chr_file staff_devpts_t;
```

## *type_member*

The *type_member* rule specifies a default type when creating a
polyinstantiated object. For example a userspace SELinux-aware
application would use ***avc_compute_member**(3)* or
***security_compute_member**(3)* with *type_member* rules in policy
to determine the context to be applied. Note that an *allow* rule must
be used to authorise access. See the
[**Computing Security Contexts**](computing_security_contexts.md#computing-security-contexts)
section for more details.

**The statement definition is:**

```
type_member source_type target_type : class member_type;
```

**Where:**

*type_member*

The *type_member* rule keyword.

*source_type*
*target_type*

One or more source / target *type*, *typealias* or *attribute* identifiers.
Multiple entries consist of a space separated list enclosed in braces '{}'. 
Entries can be excluded from the list by using the negative operator '-'.

*class*

One or more object classes. Multiple entries consist of a space separated list
enclosed in braces '{}'.

*member_type*

A single *type* or *typealias* identifier that will become the polyinstantiated
*type*. 

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

**Example:**

```
# Using the type_member statement to show that if the source
# type is sysadm_t, and the target type is user_home_dir_t,
# then use user_home_dir_t as the type on the newly created
# directory object.

type_member sysadm_t user_home_dir_t:dir user_home_dir_t;
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](role_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](bounds_rules.md)**
