# Extended Access Vector Rules

There are three extended AV rules implemented from Policy version 30
with the target platform 'selinux' that expand the permission sets from
a fixed 32 bits to permission sets in 256 bit increments: *allowxperm*,
*dontauditxperm*, *auditallowxperm* and *neverallowxperm*.

The rules for extended permissions are subject to the 'operation' they
perform with Policy version 30 and kernels from 4.3 supporting ioctl
whitelisting (if required to be declared in modular policy, then
libsepol 2.7 minimum is required).

**The common format for Extended Access Vector Rules are:**

```
rule_name source_type target_type : class operation xperm_set;
```

**Where:**

*rule_name*

The applicable *allowxperm*, *dontauditxperm*, *auditallowxperm*
or *neverallowxperm* rule keyword.

*source_type*

One or more source / target *type*, *typealias* or *attribute* identifiers.
Multiple entries consist of a space separated list enclosed in braces \'{}\'.
Entries can be excluded from the list by using the negative operator \'-\'.

*target_type*

The target_type can have the *self* keyword instead of *type*, *typealias* or
*attribute* identifiers. This means that the *target_type* is the same as the
*source_type*.

*class*

One or more object classes. Multiple entries consist of a space separated list
enclosed in braces \'{}\'.

*operation*

A key word defining the operation to be implemented by the rule. Currently only
the *ioctl* operation is supported by the kernel policy language and kernel as
described in the [*ioctl* Operation Rules](#ioctl-operation-rules) section.

*xperm_set*

One or more extended permissions represented by numeric values (i.e. *0x8900*
or *35072*). The usage is dependent on the specified *operation*. Multiple
entries consist of a space separated list enclosed in braces \'{}\'. The
complement operator \'\~\' is used to specify all permissions except those
explicitly listed. The range operator \'-\' is used to specify all permissions
within the *low – high* range. An example is shown in the
[*ioctl* Operation Rules](#ioctl-operation-rules) section.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

### *ioctl* Operation Rules

Use cases and implementation details for ioctl command whitelisting are
described in detail at
<http://marc.info/?l=selinux&m=143336061925628&w=2>, with the final
policy format changes shown in the example below with a brief overview
(also see <http://marc.info/?l=selinux&m=143412575302369&w=2>) that is
the final upstream kernel patch).

Ioctl calls are generally used to get or set device options. Policy
versions &lt; 30 only controls whether an *ioctl* permission is allowed
or not, for example this rule allows the object class *tcp_socket* the
*ioctl* permission:

```
allow src_t tgt_t : tcp_socket ioctl;
```

From Policy version 30 it is possible to control ***ioctl**(2)*
'*request*' parameters provided the *ioctl* permission is also allowed,
for example:

```
allow src_t tgt_t : tcp_socket ioctl;

allowxperm src_t tgt_t : tcp_socket ioctl ~0x8927;
```

The *allowxperm* rule states that all ioctl request parameters are
allowed for the source/target/class with the exception of the value
*0x8927* that (using *include/linux/sockios.h*) is **SIOCGIFHWADDR**, or
'get hardware address'.

An example audit log entry denying an ioctl request to add a routing
table entry (**SIOCADDRT** - *ioctlcmd=890b*) for *goldfish_setup* on a
*udp_socket* is:

```
type=1400 audit(1437408413.860:6): avc: denied { ioctl } for pid=81
comm="route" path="socket:[1954]" dev="sockfs" ino=1954 ioctlcmd=890b
scontext=u:r:goldfish_setup:s0 tcontext=u:r:goldfish_setup:s0
tclass=udp_socket permissive=0
```

Notes:

1.  Important: The ioctl operation is not 'deny all' ioctl requests
    (hence whitelisting). It is targeted at the specific
    source/target/class set of ioctl commands. As no other *allowxperm*
    rules have been defined in the example, all other ioctl calls may
    continue to use any valid request parameters (provided there are
    *allow* rules for the *ioctl* permission).
2.  As the ***ioctl**(2)* function requires a file descriptor, its
    context must match the process context otherwise the *fd { use }*
    class/permission is required.
3.  To deny all ioctl requests for a specific source/target/class the
    *xperm_set* should be set to *0* or *0x0*.

<!-- %CUTHERE% -->

---
**[[ PREV ]](avc_rules.md)** **[[ TOP ]](#)** **[[ NEXT ]](class_permission_statements.md)**
