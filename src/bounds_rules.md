# Bounds Rules

- [*typebounds*](#typebounds)

Bounds handling was added in version 24 of the policy and consisted of
adding *userbounds*, *rolebounds* and *typebounds* information to the
policy. However only the *typebounds* rule is currently implemented by
***checkpolicy**(8)* and ***checkmodule**(8)* with kernel support from
2.6.28.

The CIL language does support *userbounds* and *rolebounds* but these are
resolved at policy compile time, not via the kernel at run-time (i.e. they are
NOT enforced by the SELinux kernel services). The
[**CIL Reference Guide**](./notebook-examples/selinux-policy/cil/CIL_Reference_Guide.pdf)
gives details.

## *typebounds*

The *typebounds* rule was added in version 24 of the policy. This
defines a hierarchical relationship between domains where the bounded
domain cannot have more permissions than its bounding domain (the
parent). It requires kernel 2.6.28 and above to control the security
context associated to threads in multi-threaded applications.

**The statement definition is:**

```
typebounds bounding_domain bounded_domain;
```

**Where:**

*typebound*

The *typebounds* keyword.

*bounding_domain*

The *type* or *typealias* identifier of the parent domain.

*bounded_domain*

One or more *type* or *typealias* identifiers of the child domains.
Multiple entries consist of a comma ',' separated list.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | No                      |

**Example:**

```
# This example states that:
#   The httpd_child_t cannot have file:{write} due to lack of permissions
#   on httpd_t which is the parent. It means the child domains will always
#   have equal or less privileges than the parent.

# The typebounds statement:
typebounds httpd_t httpd_child_t;

# The parent is allowed file 'getattr' and 'read':
allow httpd_t etc_t : file { getattr read };

# However the child process has been given 'write' access that
# will not be allowed by the kernel SELinux security server.
allow httpd_child_t etc_t : file { read write };
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](type_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](avc_rules.md)**
