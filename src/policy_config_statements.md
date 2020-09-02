# Policy Configuration Statements

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

<!-- %CUTHERE% -->

---
**[[ PREV ]](kernel_policy_language.md)** **[[ TOP ]](#)** **[[ NEXT ]](default_rules.md)**
