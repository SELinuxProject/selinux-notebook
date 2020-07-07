# Role-Based Access Control

To further control access to TE domains SELinux makes use of role-based
access control (RBAC). This feature allows SELinux users to be
associated to one or more roles, where each role is then associated to
one or more domain types as shown in **Figure 4: Role Based Access Control**.

The SELinux role name is the second component of a 'security context'
and by convention SELinux roles end in `_r`, however this is not
enforced by any SELinux service (i.e. it is only used to identify the
role component), although CIL with namespaces does make identification
of a role easier for example a 'role' could be declared as
`unconfined.role`.

It is possible to add constraints and bounds on roles as discussed in
the [**Type Enforcement**](type_enforcement.md#type-enforcement) section.

Some policies, for example Android, only make use of one role called `r`.

![](./images/4-RBAC.png)

**Figure 4: Role Based Access Control** - *Showing how SELinux controls
access via user, role and domain type association.*


<br>

<!-- %CUTHERE% -->

---
**[[ PREV ]](users.md)** **[[ TOP ]](#)** **[[ NEXT ]](type_enforcement.md)**
