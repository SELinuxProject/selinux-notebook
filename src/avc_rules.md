# Access Vector Rules

- [Access Vector Rules](#access-vector-rules)
  - [*allow*](#allow)
  - [*dontaudit*](#dontaudit)
  - [*auditallow*](#auditallow)
  - [*neverallow*](#neverallow)

The AV rules define what access control privileges are allowed for
processes and objects. There are four types of AV rule: *allow*,
*dontaudit*, *auditallow*, and *neverallow* as explained in the sections that
follow with a number of examples to cover all the scenarios.

The general format of an AV rule is that the *source_type* is the
identifier of a process that is attempting to access an object
identifier *target_type*, that has an object class of *class*, and
*perm_set* defines the access permissions *source_type* is allowed.

From Policy version 30 with the target platform '*selinux*', the AVC
rules have been extended to expand the permission sets from a fixed 32
bits to permission sets in 256 bit increments. The format of the new
*allowxperm*, *dontauditxperm*, *auditallowxperm* and *neverallowxperm*
rules are discussed in the
[**Extended Access Vector Rules**](xperm_rules.md#extended-access-vector-rules)
section.

**The common format for Access Vector Rules are:**

```
rule_name source_type target_type : class perm_set;
```

**Where:**

*rule_name*

The applicable *allow*, *dontaudit*, *auditallow*, and *neverallow* rule keyword.

*source_type*, *target_type*

One or more source / target *type*, *typealias* or *attribute* identifiers.
Multiple entries consist of a space separated list enclosed in braces \'\{\}\'.
Entries can be excluded from the list by using the negative operator \'-\'.
The *target_type* can have the self keyword instead of *type*, *typealias*
or *attribute* identifiers. This means that the *target_type* is the same
as the *source_type*.
The *neverallow* rule also supports the wildcard operator \'\*\' to specify
that all types are to be included and the complement operator \'\~\' to
specify all types are to be included except those explicitly listed.

*class*

One or more object classes. Multiple entries consist of a space separated
list enclosed in braces \'\{\}\'.

*perm_set*

The access permissions the source is allowed to access for the target
object (also known as the Access Vector). Multiple entries consist of a
space separated list enclosed in braces \'\{\}\'.
The optional wildcard operator \'\*\' specifies that all permissions for
the object *class* can be used.
The complement operator \'\~\' is used to specify all permissions except
those explicitly listed (although the compiler issues a warning if the
*dontaudit* rule has \'\~\'.

**The statements are valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| Yes: *allow*, *dontaudit*, *auditallow* No: *neverallow* | Yes     | No     |

## *allow*

The allow rule checks whether the operations between the *source_type*
and *target_type* are allowed for the class and permissions defined. It
is the most common statement that many of the **Reference Policy**
helper macros and interface definitions expand into multiple allow rules.

**Examples:**

```
# Using the allow rule to show that initrc_t is allowed access
# to files of type acct_exec_t that have the getattr, read and
# execute file permissions:

allow initrc_t acct_exec_t:file { getattr read execute };
```

```
# This rule includes an attribute filesystem_type and states
# that kernel_t is allowed mount permissions on the filesystem
# object for all types associated to the filesystem_type attribute:

allow kernel_t filesystem_type:filesystem mount;
```

```
# This rule includes the self keyword in the target_type that
# states that staff_t is allowed setgid, chown and fowner
# permissions on the capability object:

allow staff_t self:capability { setgid chown fowner };

# This would be the same as the above:
allow staff_t staff_t:capability { setgid chown fowner };
```

```
# This rule includes the wildcard operator (*) on the perm_set
# and states that bootloader_t is allowed to use all permissions
# available on the dbus object that are type system_dbusd_t:
allow bootloader_t system_dbusd_t:dbus *;

# This would be the same as the above:
allow bootloader_t system_dbusd_t:dbus { acquire_svc send_msg };
```

```
# This rule includes the complement operator (~) on the perm_set
# and two class entries file and chr_file.
#
# The allow rule states that all types associated with the
# attribute files_unconfined_type are allowed to use all
# permissions available on the file and chr_file objects except
# the execmod permission when they are associated to the types
# listed within the attribute file_type:

allow files_unconfined_type file_type:{ file chr_file } ~execmod;
```

## *dontaudit*

The *dontaudit* rule stops the auditing of denial messages as it is known
that this event always happens and does not cause any real issues. This
also helps to manage the audit log by excluding known events.

**Example:**

```
# Using the dontaudit rule to stop auditing events that are
# known to happen. The rule states that when the traceroute_t
# process is denied access to the name_bind permission on a
# tcp_socket for all types associated to the port_type
# attribute (except port_t), then do not audit the event:

dontaudit traceroute_t { port_type -port_t }:tcp_socket name_bind;
```

## *auditallow*

Audit the event as a record as it is useful for auditing purposes. Note
that this rule only audits the event, it still requires the *allow* rule
to grant permission.

**Example:**

```
# Using the auditallow rule to force an audit event to be
# logged. The rule states that when the ada_t process has
# permission to execstack, then that event must be audited:

auditallow ada_t self:process execstack;
```

## *neverallow*

This rule specifies that an *allow* rule must not be generated for the
operation, even if it has been previously allowed. The *neverallow*
statement is a compiler enforced action, where the ***checkpolicy**(8)*,
***checkmodule**(8)*[^fn_avc_1] or ***secilc**(8)*[^fn_avc_2]
compiler checks if any allow rules have been generated in the policy source,
if so it will issue a warning and stop.

**Examples**:

```
# Using the neverallow rule to state that no allow rule may ever
# grant any file read access to type shadow_t except those
# associated with the can_read_shadow_passwords attribute:

neverallow ~can_read_shadow_passwords shadow_t:file read;
```

```
# Using the neverallow rule to state that no allow rule may ever
# grant mmap_zero permissions any type associated to the domain
# attribute except those associated to the mmap_low_domain_type
# attribute (as these have been excluded by the negative operator '-'):

neverallow { domain -mmap_low_domain_type } self:memprotect mmap_zero;
```

[^fn_avc_1]: *neverallow* statements are allowed in modules, however to detect
these the *semanage.conf* file must have the 'expand-check=1' entry present.

[^fn_avc_2]: The *\-\-disable-neverallow* option can be used with ***secilc**(8)*
to disable *neverallow* rule checking.

<!-- %CUTHERE% -->

---
**[[ PREV ]](bounds_rules.md)** **[[ TOP ]](#)** **[[ NEXT ]](xperm_rules.md)**
