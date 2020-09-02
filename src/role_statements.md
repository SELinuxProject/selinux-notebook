# Role Statements

- [*role*](#role)
- [*attribute_role*](#attribute_role)
- [*roleattribute*](#roleattribute)
- [*allow*](#allow)
- [*role_transition*](#role_transition)
- [*dominance* - Deprecated](#dominance---deprecated)

Policy version 26 introduced two new role statements aimed at replacing
the deprecated role *dominance* rule by making role relationships easier to
understand. These new statements: *attribute_role* and *roleattribute*
are defined in this section with examples.

## *role*

The *role* statement either declares a role identifier or associates a
role identifier to one or more types (i.e. authorise the role to access
the domain or domains). Where there are multiple role statements
declaring the same role, the compiler will associate the additional
types with the role.

**The statement definition to declare a role is:**

```
role role_id;
```

**The statement definition to associate a role to one or more types is:**

```
role role_id types type_id;
```

**Where:**

*role*

The *role* keyword.

*role_id*

The identifier of the role being declared. The same *role* identifier can be
declared more than once in a policy, in which case the *type_id* entries will
be amalgamated by the compiler.

*types*

The optional *types* keyword.

*type_id*

When used with the *types* keyword, one or more type, *typealias* or
*attribute* identifiers associated with the *role_id*. Multiple entries
consist of a space separated list enclosed in braces '{}'. Entries can be
excluded from the list by using the negative operator '-'.
For *role* statements, only *type*, *typealias* or *attribute* identifiers
associated to domains have any meaning within SELinux.

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
# Declare the roles:
role system_r;
role sysadm_r;
role staff_r;
role user_r;
role secadm_r;
role auditadm_r;

# Within the policy the roles are then associated to the
# required types with this example showing the user_r role
# being associated to two domains:

role user_r types user_t;
role user_r types chfn_t;
```

## *attribute_role*

The *attribute_role* statement declares a role attribute identifier that
can then be used to refer to a group of roles.

**The statement definition is:**

```
attribute_role attribute_id;
```

**Where:**

*attribute_role*

The *attribute_role* keyword.

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
# Using the attribute_role statement to declare attributes that
# can then refers to a list of roles. Note that there are no
# roles associated with them yet.

attribute_role role_list_1;
attribute_role srole_list_2;
```

## *roleattribute*

The *roleattribute* statement allows the association of previously
declared roles to one or more previously declared *attribute_roles*.

**The statement definition is:**

```
roleattribute role_id attribute_id;
```

**Where:**

*roleattribute*

The *roleattribute* keyword.

*role_id*

The identifier of a previously declared *role*.

*attribute_id*

One or more previously declared *attribute_role* identifiers. Multiple entries
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
# Using the roleattribute statement to associate a previously
# declared role of service_r to a previously declared
# role_list_1 attribute_role.

attribute_role role_list_1;
role service_r;

# The association using the roleattribute statement:
roleattribute service_r role_list_1;
```

## *allow*

The 'role *allow*' rule checks whether a request to change roles is allowed,
if it is, then there may be a further request for a *role_transition* so
that the process runs with the new role or role set.

Note that the 'role *allow*' rule has the same keyword as the *allow* AV rule.

**The statement definition is:**

```
allow from_role_id to_role_id;
```

**Where:**

*allow*

The role *allow* rule keyword.

*from_role_id*

One or more *role* or *attribute_role* identifiers that identify the current
role. Multiple entries consist of a space separated list enclosed in braces '{}'.

*to_role_id*

One or more *role* or *attribute_role* identifiers that identify the current
role. Multiple entries consist of a space separated list enclosed in braces '{}'.

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
# Using the role allow rule to define authorised role
# transitions in the Reference Policy. The current role
# sysadm_r is granted permission to transition to the secadm_r
# role in the MLS policy.

allow sysadm_r secadm_r;
```

## *role_transition*

The *role_transition* rule specifies that a role transition is required,
and if allowed, the process will run under the new role. From policy
version 25, the *class* can now be defined.

**The statement definition is:**

```
role_transition current_role_id type_id new_role_id;
```

Or from Policy version 25:

```
role_transition current_role_id type_id : class new_role_id;
```

**Where:**

*role_transition*

The *role_transition* keyword.

*current_role_id*

One or more *role* or *attribute_role* identifiers that identify the current
role. Multiple entries consist of a space separated list enclosed in braces '{}'.

*type_id*

One or more *type*, *typealias* or *attribute* identifiers. Multiple entries
consist of a space separated list enclosed in braces '{}'. Entries can be
excluded from the list by using the negative operator '-'.

*class*

For policy versions \>= 25 an object *class* that applies to the role
transition. If omitted defaults to the *process* object class.

*new_role_id*

A single *role* identifier that will become the new role.

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
role_transition system_r unconfined_exec_t:process unconfined_r;
```

## *dominance* - Deprecated

This rule has been deprecated and therefore should not be used. The role
dominance rule allows the *dom_role_id* to dominate the *role_id*
(consisting of one or more roles). The dominant role will automatically
inherit all the type associations of the other roles.

Notes:

1. There is another dominance rule for MLS (see the
   [**MLS *dominance***](mls_statements.md#dominance) statement.
2. The role dominance rule is not used by the **Reference Policy** as
   the policy manages role dominance using the
   [***constrain***](constraint_statements.md#constraint-statements) statement.
3. Note the usage of braces '{}' and the ';' in the statement.

**The statement definition is:**

```
dominance { role dom_role_id { role role_id; } }
```

**Where:**

*dominance*

The *dominance* keyword.

*role*

The *role* keyword.

*dom_role_id*

The dominant role identifier.

*role_id*

For the simple case each *{ role role_id; }* pair defines the *role_id* that
will be dominated by the *dom_role_id*.

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
# This shows the dominance role rule, note however that it
# has been deprecated and should not be used.

dominance { role message_filter_r { role unconfined_r };}
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](user_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](type_statements.md)**
