# Security ID (SID) Statement

- [*sid*](#sid)
- [*sid context*](#sid-context)

There are two *sid* statements, the first one declares the actual *sid*
identifier and is defined at the start of a policy source file. The
second statement is used to associate an initial security context to the
*sid*, this is used when SELinux initialises but the policy has not yet
been activated or as a default context should an object have an invalid
label.

## *sid*

The *sid* statement declares the actual SID identifier and is defined at
the start of a policy source file.

**The statement definition is:**

```
sid sid_id
```

**Where:**

*sid*

The *sid* keyword.

*sid_id*

The *sid* identifier.

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
# This example has been taken from the Reference Policy source
# policy/flask/initial_sids file and declares some of the initial SIDs:
#

sid kernel
sid security
sid unlabeled
sid fs
```

## *sid context*

The *sid context* statement is used to associate an initial security
context to the SID.

**The statement definition is:**

```
sid sid_id context
```

**Where:**

*sid*

The *sid* keyword.

*sid_id*

The previously declared *sid* identifier.

*context*

The initial security context.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Examples:**

```
# This is from a targeted policy:

sid unlabeled
...
sid unlabeled system_u:object_r:unlabeled_t
```

```
# This is from an MLS policy. Note that the security level
# is set to SystemHigh as it may need to label any object in
# the system.

sid unlabeled
...
sid unlabeled system_u:object_r:unlabeled_t:s15:c0.c255
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](mls_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](file_labeling_statements.md)**
