# Role Statements

Policy version 26 introduced two new role statements aimed at replacing
the deprecated role `dominance` rule by making role relationships easier to
understand. These new statements: `attribute_role` and `roleattribute`
are defined in this section with examples.

## `role`

The `role` statement either declares a role identifier or associates a
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

<table>
<tbody>
<tr>
<td><code>role</code></td>
<td>The <code>role</code> keyword.</td>
</tr>
<tr>
<td><code>role_id</code></td>
<td>The identifier of the role being declared. The same role identifier can be declared more than once in a policy, in which case the <code>type_id</code> entries will be amalgamated by the compiler.</td>
</tr>
<tr>
<td><code>types</code></td>
<td>The optional <code>types</code> keyword.</td>
</tr>
<tr>
<td><code>type_id</code></td>
<td><p>When used with the <code>types</code> keyword, one or more type, <code>typealias</code> or <code>attribute</code> identifiers associated with the <code>role_id</code>. Multiple entries consist of a space separated list enclosed in braces '{}'. Entries can be excluded from the list by using the negative operator '-'.</p>
<p>For <code>role</code> statements, only <code>type</code>, <code>typealias</code> or <code>attribute</code> identifiers associated to domains have any meaning within SELinux.</p></td>
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
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
</tr>
</tbody>
</table>

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


## `attribute_role`

The `attribute_role` statement declares a role attribute identifier that
can then be used to refer to a group of roles.

**The statement definition is:**

```
attribute_role attribute_id;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>attribute_role</code></td>
<td>The <code>attribute_role</code> keyword.</td>
</tr>
<tr>
<td><code>attribute_id</code></td>
<td>The <code>attribute</code> identifier.</td>
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
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
</tr>
</tbody>
</table>

**Examples:**

```
# Using the attribute_role statement to declare attributes that
# can then refers to a list of roles. Note that there are no
# roles associated with them yet.

attribute_role role_list_1;
attribute_role srole_list_2;
```


## `roleattribute`

The <code>roleattribute</code> statement allows the association of previously
declared roles to one or more previously declared <code>attribute_roles</code>.

**The statement definition is:**

```
roleattribute role_id attribute_id;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>roleattribute</code></td>
<td>The <code>roleattribute</code> keyword.</td>
</tr>
<tr>
<td><code>role_id</code></td>
<td>The identifier of a previously declared <code>role</code>.</td>
</tr>
<tr>
<td><code>attribute_id</code></td>
<td>One or more previously declared <code>attribute_role</code> identifiers. Multiple entries consist of a comma ',' separated list.</td>
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
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

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


## `allow`

The role `allow` rule checks whether a request to change roles is allowed,
if it is, then there may be a further request for a `role_transition` so
that the process runs with the new role or role set.

Note that the role allow rule has the same keyword as the allow AV rule.

**The statement definition is:**

```
allow from_role_id to_role_id;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>allow</code></td>
<td>The <code>role allow</code> rule keyword.</td>
</tr>
<tr>
<td><code>from_role_id</code></td>
<td>One or more <code>role</code> or <code>attribute_role</code> identifiers that identify the current role. Multiple entries consist of a space separated list enclosed in braces '{}'.</td>
</tr>
<tr>
<td><code>to_role_id</code></td>
<td>One or more <code>role</code> or <code>attribute_role</code> identifiers that identify the current role. Multiple entries consist of a space separated list enclosed in braces '{}'.</td>
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
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example:**

```
# Using the role allow rule to define authorised role
# transitions in the Reference Policy. The current role
# sysadm_r is granted permission to transition to the secadm_r
# role in the MLS policy.

allow sysadm_r secadm_r;
```


## `role_transition`

The `role_transition` rule specifies that a role transition is required,
and if allowed, the process will run under the new role. From policy
version 25, the `class` can now be defined.

**The statement definition is:**

```
role_transition current_role_id type_id new_role_id;
```

Or from Policy version 25:

```
role_transition current_role_id type_id : class new_role_id;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>role_transition</code></td>
<td>The <code>role_transition</code> keyword.</td>
</tr>
<tr>
<td><code>current_role_id</code></td>
<td>One or more <code>role</code> or <code>attribute_role</code> identifiers that identify the current role. Multiple entries consist of a space separated list enclosed in braces '{}'.</td>
</tr>
<tr>
<td><code>type_id</code></td>
<td>One or more <code>type</code>, <code>typealias</code> or <code>attribute</code> identifiers. Multiple entries consist of a space separated list enclosed in braces '{}'. Entries can be excluded from the list by using the negative operator '-'. </td>
</tr>
<tr>
<td><code>class</code></td>
<td>For policy versions &gt;= 25 an object <code>class</code> that applies to the role transition. If omitted defaults to the <code>process</code> object class.</td>
</tr>
<tr>
<td><code>new_role_id</code></td>
<td>A single <code>role</code> identifier that will become the new role. </td>
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
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example:**

```
role_transition system_r unconfined_exec_t:process unconfined_r;
```


## `dominance` - Deprecated

This rule has been deprecated and therefore should not be used. The role
dominance rule allows the `dom_role_id` to dominate the `role_id`
(consisting of one or more roles). The dominant role will automatically
inherit all the type associations of the other roles.

Notes:

1.  There is another dominance rule for MLS (see the
    [**MLS `dominance`**](mls_statements.md#dominance) statement.
2.  The role dominance rule is not used by the **Reference Policy** as
    the policy manages role dominance using the
    [**`constrain`**](constraint_statements.md#constraint-statements) statement.
3.  Note the usage of braces '{}' and the ';' in the statement.

**The statement definition is:**

```
dominance { role dom_role_id { role role_id; } }
```

Where:

<table>
<tbody>
<tr>
<td><code>dominance</code></td>
<td>The <code>dominance</code> keyword.</td>
</tr>
<tr>
<td><code>role</code></td>
<td>The <code>role</code> keyword.</td>
</tr>
<tr>
<td><code>dom_role_id</code></td>
<td>The dominant role identifier.</td>
</tr>
<tr>
<td><code>role_id</code></td>
<td>For the simple case each <code>{ role role_id; }</code> pair defines the <code>role_id</code> that will be dominated by the <code>dom_role_id</code>.</td>
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
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example:**

```
# This shows the dominance role rule, note however that it
# has been deprecated and should not be used.

dominance { role message_filter_r { role unconfined_r };}
```


<!-- %CUTHERE% -->

---
**[[ PREV ]](user_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](type_statements.md)**
