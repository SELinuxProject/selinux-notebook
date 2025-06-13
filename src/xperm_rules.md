# Extended Access Vector Rules

-   [Extended Permission Evaluation](#extended-permission-evaluation)
-   [*ioctl* Operation Rules](#ioctl-operation-rules)
-   [*nlmsg* Operation Rules](#nlmsg-operation-rules)

There are four extended AV rules implemented from Policy version 30 with the
target platform 'selinux' that expand the permission sets from a fixed 32 bits
to permission sets in 256 bit increments: *allowxperm*, *dontauditxperm*,
*auditallowxperm* and *neverallowxperm*.

The rules for extended permissions are subject to the 'operation' they perform.

-   `ioctl`: With policy version 30 and kernels from 4.3 (if required to be
    declared in modular policy, then libsepol 2.7 minimum is required).
-   `nlmsg`: With kernel from 6.13, using the policy capability `netlink_xperm`.

**The common format for Extended Access Vector Rules are:**

```
rule_name source_type target_type : class operation xperm_set;
```

**Where:**

*rule_name*

The applicable *allowxperm*, *dontauditxperm*, *auditallowxperm* or
*neverallowxperm* rule keyword.

*source_type*

One or more source / target *type*, *typealias* or *attribute* identifiers.
Multiple entries consist of a space separated list enclosed in braces \'{}\'.
Entries can be excluded from the list by using the negative operator \'-\'.

*target_type*

The *target_type* can have the *self* keyword instead of *type*, *typealias* or
*attribute* identifiers. This means that the *target_type* is the same as the
*source_type*.

*class*

One or more object classes. Multiple entries consist of a space separated list
enclosed in braces \'{}\'.

*operation*

A key word defining the operation to be implemented by the rule. Currently only
the *ioctl* and *nlmsg* operations are supported by the kernel policy language
and kernel as described in the sections below.

*xperm_set*

One or more extended permissions represented by numeric values (i.e. *0x8900* or
*35072*). The usage is dependent on the specified *operation*. Multiple entries
consist of a space separated list enclosed in braces \'{}\'. The complement
operator \'\~\' is used to specify all permissions except those explicitly
listed. The range operator \'-\' is used to specify all permissions within the
*low – high* range. An example is shown in the
[*ioctl* Operation Rules](#ioctl-operation-rules) section.

**The statement is valid in:**

Policy Type

Monolithic Policy | Base Policy | Module Policy
----------------- | ----------- | -------------
Yes               | Yes         | Yes

Conditional Policy Statements

*if* Statement | *optional* Statement | *require* Statement
-------------- | -------------------- | -------------------
No             | No                   | No

### Extended Permission Evaluation

Extended permission rules are evaluated as follows:

*   If no extended permissions are defined, the standard SELinux checks around
    AVC rules and constraints will be performed.

*   If an extended permission rule is defined, the policy is evaluated so that
    both the standard AVC checks and the extended permissions must pass. For
    example:

    *   If an *allowxperm* rule is defined, extended permissions will only be
        granted if *allow* is granted to the resource.

    *   If an *auditallowxperm* rule is defined, extended auditing will only be
        performed if *auditallow* is allowed for the resource.

*   If any extended permission rule is defined, the resource and operation are
    fully evaluated according to extended access rules. All unspecified
    permissions within the available *xperm_set* will be automatically denied.

All extended permissions are deny-by-default. If extended permission rules are
used, any allow permissions must be granted explicitly.

### *ioctl* Operation Rules

Use cases and implementation details for ioctl command allowlists are described
in detail in
[[PATCH 0/2 v2] selinux: extended permissions for ioctl commands](http://marc.info/?l=selinux&m=143336061925628&w=2),
with the final policy format changes shown in the example below with a brief
overview (also see
[[PATCH 2/2 v6] selinux: extended permissions for ioctls](http://marc.info/?l=selinux&m=143412575302369&w=2)
that is the final upstream kernel patch).

Ioctl calls are generally used to get or set device options. Policy versions \>
30 only controls whether an *ioctl* permission is allowed or not, for example
this rule allows the object class *tcp_socket* the *ioctl* permission:

```
allow src_t tgt_t : tcp_socket ioctl;
```

From Policy version 30 it is possible to control ***ioctl**(2)* '*request*'
parameters provided the *ioctl* permission is also allowed, for example:

```
allow src_t tgt_t : tcp_socket ioctl;

allowxperm src_t tgt_t : tcp_socket ioctl ~0x8927;
```

The *allowxperm* rule states that all ioctl request parameters are allowed for
the source/target/class with the exception of the value *0x8927* that (using
*include/linux/sockios.h*) is **SIOCGIFHWADDR**, or 'get hardware address'.

An example audit log entry denying an ioctl request to add a routing table entry
(**SIOCADDRT** - *ioctlcmd=890b*) for *goldfish_setup* on a *udp_socket* is:

```
type=1400 audit(1437408413.860:6): avc: denied { ioctl } for pid=81
comm="route" path="socket:[1954]" dev="sockfs" ino=1954 ioctlcmd=890b
scontext=u:r:goldfish_setup:s0 tcontext=u:r:goldfish_setup:s0
tclass=udp_socket permissive=0
```

Notes:

1.  Important: The ioctl operation is not 'deny all', it is targeted at the
    specific source/target/class set of ioctl commands. As no other *allowxperm*
    rules have been defined in the example, all other ioctl calls may continue
    to use any valid request parameters (provided there are *allow* rules for
    the *ioctl* permission).
2.  As the ***ioctl**(2)* function requires a file descriptor, its context must
    match the process context otherwise the *fd { use }* class/permission is
    required.
3.  To deny all ioctl requests for a specific source/target/class the
    *xperm_set* should be set to *0* or *0x0*.
4.  From the 32-bit ioctl request parameter value only the least significant 16
    bits are used. Thus *0x8927*, *0x00008927* and *0xabcd8927* are the same
    extended permission.
5.  To decode a numeric ioctl request parameter into the corresponding textual
    identifier see
    <https://www.kernel.org/doc/html/latest/userspace-api/ioctl/ioctl-decoding.html>

### *nlmsg* Operation Rules

The *nlmsg* extended permissions are available on kernel >= 6.13. The policy
needs to enable the `netlink_xperm` capability.

This permission is available for the following netlink sockets:

-   `NETLINK_ROUTE_SOCKET`
-   `NETLINK_TCPDIAG_SOCKET`
-   `NETLINK_XFRM_SOCKET`
-   `NETLINK_AUDIT_SOCKET`

If the basic permission is granted and no extended permissions are defined for
the tuple (`src_t`, `tgt_t`, `tclass`), then the access is granted: `allow src_t
tgt_t : netlink_route_socket nlmsg;`

Otherwise, it is possible to limit which `nlmsg_type` is accepted for each
netlink socket class. For example to allow only `RTM_GETROUTE`:
``define(`RTM_GETROUTE', `0x12') allow src_t tgt_t : netlink_route_socket nlmsg;
allowxperm src_t tgt_t : netlink_route_socket nlmsg { RTM_GETROUTE };``

The permission values (e.g., `0x12` for `RTM_GETROUTE`) can be found in the
corresponding kernel headers for each netlink class:

-   `NETLINK_ROUTE_SOCKET`:
    [`rtnetlink.h`](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/rtnetlink.h?h=v6.11)
-   `NETLINK_TCPDIAG_SOCKET`:
    [`inet_diag.h`](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/inet_diag.h?h=v6.11)
    and
    [`sock_diag.h`](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/sock_diag.h?h=v6.11)
-   `NETLINK_XFRM_SOCKET`:
    [`xfrm.h`](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/xfrm.h?h=v6.11)
-   `NETLINK_AUDIT_SOCKET`:
    [`audit.h`](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/audit.h?h=v6.11)

<!-- %CUTHERE% -->

--------------------------------------------------------------------------------

**[[ PREV ]](avc_rules.md)** **[[ TOP ]](#)**
**[[ NEXT ]](class_permission_statements.md)**
