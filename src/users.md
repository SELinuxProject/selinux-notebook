# SELinux Users

Users in Linux are generally associated to human users (such as
Alice and Bob) or operator/system functions (such as admin), while this
can be implemented in SELinux, SELinux user names are generally groups
or classes of user. For example all the standard system users could be
assigned an SELinux user name of `user_u` and administration staff
under `staff_u`.

There is one special SELinux user defined that must never be associated
to a Linux user as it a special identity for system processes and
objects, this user is `system_u`.

The SELinux user name is the first component of a
[**Security Context**](security_context.md#security-context) and
by convention SELinux user names end in `_u`, however this is not
enforced by any SELinux service (i.e. it is only to identify the user
component), although CIL with namespaces does make identification of an
SELinux user easier for example a 'user' could be declared as
`unconfined.user`.

It is possible to add constraints and bounds on SELinux users as discussed in
the [**Type Enforcement (TE)**](type_enforcement.md#type-enforcement) section.

Some policies, for example Android, only make use of one user called `u`.


<br>

<!-- %CUTHERE% -->

<table>
<tbody>
<td><center>
<p><a href="mac.md#mandatory-access-control" title="Mandatory Access Control (MAC)"> <strong>Previous</strong></a></p>
</center></td>
<td><center>
<p><a href="README.md#the-selinux-notebook" title="The SELinux Notebook"> <strong>Home</strong></a></p>
</center></td>
<td><center>
<p><a href="rbac.md#role-based-access-control" title=""> <strong>Next</strong></a></p>
</center></td>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>
