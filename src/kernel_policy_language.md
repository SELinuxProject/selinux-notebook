# Kernel Policy Language

This section covers the policy source file types and what kernel policy
statements and rule are allowed in each. The [**Section Contents**](#section-contents)
then has links to each section within this document.

## Policy Source Files

There are three basic types of policy source file<strong><a href="#fn1" class="footnote-ref" id="fnker1"><sup>1</sup></a></strong> that can contain language statements
and rules. The three types of policy
source file<strong><a href="#fn2" class="footnote-ref" id="fnker2"><sup>2</sup></a></strong> are:

**Monolithic Policy** - This is a single policy source file that
contains all statements. By convention this file is called policy.conf
and is compiled using the **checkpolicy**(8) command that produces the
binary policy file.

**Base Policy** - This is the mandatory base policy source file that
supports the loadable module infrastructure. The whole system policy
could be fully contained within this file, however it is more usual for
the base policy to hold the mandatory components of a policy, with the
optional components contained in loadable module source files. By
convention this file is called base.conf and is compiled using the
***checkpolicy**(8)* or ***checkmodule**(8)* command.

**Module (or Non-base) Policy** - These are optional policy source files
that when compiled, can be dynamically loaded or unloaded within the
policy store. By convention these files are named after the module or
application they represent, with the compiled binary having a '.pp'
extension. These files are compiled using the ***checkmodule**(8)* command.

**Table 1** shows the order in which the statements should
appear in source files with the mandatory statements that must be
present.


<table>
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Base Entries</strong></td>
<td><strong>M&#47;O</strong></td>
<td><strong>Module Entries</strong></td>
<td><strong>M&#47;O</strong></td>
</tr>
<tr>
<td>Security Classes (class)</td>
<td>m</td>
<td>module Statement</td>
<td>o</td>
</tr>
<tr>
<td>Initial SIDs</td>
<td>m</td>
<td></td>
<td></td>
</tr>
<tr>
<td>Access Vectors (permissions)</td>
<td>m</td>
<td>require Statement</td>
<td>o</td>
</tr>
<tr>
<td>MLS sensitivity, category and level Statements</td>
<td>o</td>
<td></td>
<td></td>
</tr>
<tr>
<td>MLS Constraints</td>
<td>o</td>
<td></td>
<td></td>
</tr>
<tr>
<td>Policy Capability Statements</td>
<td>o</td>
<td></td>
<td></td>
</tr>
<tr>
<td>Attributes</td>
<td>o</td>
<td>Attributes</td>
<td>o</td>
</tr>
<tr>
<td>Booleans</td>
<td>o</td>
<td>Booleans</td>
<td>o</td>
</tr>
<tr>
<td>Default user, role, type, range rules</td>
<td>o</td>
<td></td>
<td></td>
</tr>
<tr>
<td>Type / Type Alias</td>
<td>m</td>
<td>Type / Type Alias</td>
<td>o</td>
</tr>
<tr>
<td>Roles</td>
<td>m</td>
<td>Roles</td>
<td>o</td>
</tr>
<tr>
<td>Policy Rules</td>
<td>m</td>
<td>Policy Rules</td>
<td>o</td>
</tr>
<tr>
<td>Users</td>
<td>m</td>
<td>Users</td>
<td>o</td>
</tr>
<tr>
<td>Constraints</td>
<td>o</td>
<td></td>
<td></td>
</tr>
<tr>
<td>Default SID labeling</td>
<td>m</td>
<td></td>
<td></td>
</tr>
<tr>
<td>fs_use_xattr Statements</td>
<td>o</td>
<td></td>
<td></td>
</tr>
<tr>
<td>fs_use_task and fs_use_trans Statements</td>
<td>o</td>
<td></td>
<td></td>
</tr>
<tr>
<td>genfscon Statements</td>
<td>o</td>
<td></td>
<td></td>
</tr>
<tr>
<td>portcon, netifcon and nodecon Statements</td>
<td>o</td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

**Table 1: Base and Module Policy Statements** -*There must be at least one
of each of the mandatory statements, plus at least one allow rule in a policy
to successfully build.*

The language grammar defines what statements and rules can be used
within the different types of source file. To highlight these rules, the
following table is included in each statement and rule section to show
what circumstances each one is valid within a policy source file:

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>Yes/No</td>
<td>Yes/No</td>
<td>Yes/No</td>
</tr>
</tbody>
</table>

Where:

<table>
<tbody>
<tr>
<td>Monolithic Policy</td>
<td>Whether the statement is allowed within a monolithic policy source file or not.</td>
</tr>
<tr>
<td>Base Policy</td>
<td>Whether the statement is allowed within a base (for loadable module support) policy source file or not.</td>
</tr>
<tr>
<td>Module Policy</td>
<td>Whether the statement is allowed within the optional loadable module policy source file or not.</td>
</tr>
</tbody>
</table>

**Table 3** shows a cross reference matrix of statements
and rules allowed in each type of policy source file.


## Conditional, Optional and Require Statement Rules

The language grammar specifies what statements and rules can be included
within:

1.   [**Conditional Policy**](conditional_statements.md#conditional-policy-statements)
     rules that are part of the kernel policy language.
2.   *optional* and *require* rules that are NOT part of the kernel policy
     language, but **Reference Policy** ***m4**(1)* macros used to control
     policy builds (see the
     [**Modular Policy Support Statements**](modular_policy_statements.md#modular-policy-support-statements)
     section.

To highlight these rules the following table is included in each
statement and rule section to show what circumstances each one is valid
within a policy source file:

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>Yes/No</td>
<td>Yes/No</td>
<td>Yes/No</td>
</tr>
</tbody>
</table>

Where:

<table>
<tbody>
<tr>
<td>Conditional Policy (if) Statement</td>
<td>Whether the statement is allowed within a conditional statement (<code>if/else</code> construct). Conditional statements can be in all types of policy source file.</td>
</tr>
<tr>
<td>optional Statement</td>
<td>Whether the statement is allowed within the <code>optional { rule_list }</code> construct.</td>
</tr>
<tr>
<td>require Statement</td>
<td>Whether the statement is allowed within the <code>require { rule_list }</code> construct.</td>
</tr>
</tbody>
</table>

**Table 3** shows a cross reference matrix of statements
and rules allowed in each of the above policy statements.


## MLS Statements and Optional MLS Components

The [**MLS Statements**](mls_statements.md#mls-statements) section defines
statements specifically for MLS support. However when MLS is enabled,
there are other statements that require the MLS component of a security
context as an argument, (for example the
[**Network Labeling Statements**](network_statements.md#network-labeling-statements)),
therefore these statements show an example taken from the MLS **Reference Policy** build.


## General Statement Information

1.  Identifiers can generally be any length but should be restricted to
    the following characters: a-z, A-Z, 0-9 and \_ (underscore).
2.  A '\#' indicates the start of a comment in policy source files.
3.  All statements available to policy version 29 have been included.
4.  When multiple source and target entries are shown in a single
    statement or rule, the compiler (***checkpolicy**(8)* or
    ***checkmodule**(8)*) will expand these to individual statements or
    rules as shown in the following example:

```
# This allow rule has two target entries console_device_t and tty_device_t:
allow apm_t { console_device_t tty_device_t }:chr_file { getattr read write append ioctl lock };

# The compiler will expand this to become:
allow apm_t console_device_t:chr_file { getattr read write append ioctl lock };
# and:
allow apm_t tty_device_t:chr_file { getattr read write append ioctl lock };
```

Therefore when comparing the actual source code with a compiled binary
using (for example) ***apol**(8)*, **sedispol** or **sedismod**, the
results will differ (however the resulting policy rules will be the
same).

1.  Some statements can be added to a policy via the policy store using
    the **semanage**(8) command. Examples of these are shown where
    applicable, however the **semanage** man page should be consulted
    for all the possible command line options.
2.  **Table 2** lists words reserved for the SELinux  policy language.

<table>
<tbody>
<tr>
<td>alias</td>
<td>allow</td>
<td>and </td>
</tr>
<tr>
<td>attribute</td>
<td>attribute_role</td>
<td>auditallow</td>
</tr>
<tr>
<td>auditdeny</td>
<td>bool</td>
<td>category</td>
</tr>
<tr>
<td>cfalse</td>
<td>class</td>
<td>clone</td>
</tr>
<tr>
<td>common</td>
<td>constrain</td>
<td>ctrue </td>
</tr>
<tr>
<td>dom</td>
<td>domby</td>
<td>dominance</td>
</tr>
<tr>
<td>dontaudit</td>
<td>else</td>
<td>equals</td>
</tr>
<tr>
<td>false</td>
<td>filename</td>
<td>filesystem</td>
</tr>
<tr>
<td>fscon</td>
<td>fs_use_task</td>
<td>fs_use_trans</td>
</tr>
<tr>
<td>fs_use_xattr</td>
<td>genfscon</td>
<td>h1 </td>
</tr>
<tr>
<td>h2</td>
<td>identifier</td>
<td>if</td>
</tr>
<tr>
<td>incomp</td>
<td>inherits</td>
<td>iomemcon</td>
</tr>
<tr>
<td>ioportcon</td>
<td>ipv4_addr</td>
<td>ipv6_addr</td>
</tr>
<tr>
<td>l1</td>
<td>l2</td>
<td>level</td>
</tr>
<tr>
<td>mlsconstrain</td>
<td>mlsvalidatetrans</td>
<td>module </td>
</tr>
<tr>
<td>netifcon</td>
<td>neverallow</td>
<td>nodecon </td>
</tr>
<tr>
<td>not</td>
<td>notequal</td>
<td>number</td>
</tr>
<tr>
<td>object_r</td>
<td>optional</td>
<td>or</td>
</tr>
<tr>
<td>path</td>
<td>pcidevicecon</td>
<td>permissive</td>
</tr>
<tr>
<td>pirqcon</td>
<td>policycap</td>
<td>portcon</td>
</tr>
<tr>
<td>r1</td>
<td>r2</td>
<td>r3 </td>
</tr>
<tr>
<td>range</td>
<td>range_transition</td>
<td>require </td>
</tr>
<tr>
<td>role</td>
<td>roleattribute</td>
<td>roles</td>
</tr>
<tr>
<td>role_transition</td>
<td>sameuser</td>
<td>sensitivity</td>
</tr>
<tr>
<td>sid</td>
<td>source</td>
<td>t1 </td>
</tr>
<tr>
<td>t2</td>
<td>t3</td>
<td>target</td>
</tr>
<tr>
<td>true</td>
<td>type</td>
<td>typealias</td>
</tr>
<tr>
<td>typeattribute</td>
<td>typebounds</td>
<td>type_change</td>
</tr>
<tr>
<td>type_member</td>
<td>types</td>
<td>type_transition</td>
</tr>
<tr>
<td>u1</td>
<td>u2</td>
<td>u3 </td>
</tr>
<tr>
<td>user</td>
<td>validatetrans</td>
<td>version_identifier </td>
</tr>
<tr>
<td>xor</td>
<td>default_user</td>
<td>default_role</td>
</tr>
<tr>
<td>default_type</td>
<td>default_range</td>
<td>low</td>
</tr>
<tr>
<td>high</td>
<td>low_high</td>
<td></td>
</tr>
</tbody>
</table>

**Table 2: Policy language reserved words**


**Table 3** shows what policy language statements and rules are allowed
within each type of policy source file, and whether the statement is valid
within an *if/else* construct, *optional {rule_list}*, or
*require {rule_list}* statement.

<table>
<tbody>
<tr>
<td>allow</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>allow - Role</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>attribute</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr>
<td>attribute_role</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr>
<td>auditallow</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>auditdeny (Deprecated)</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>bool</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr>
<td>category</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>Yes</td>
</tr>
<tr>
<td>class</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>Yes</td>
</tr>
<tr>
<td>common</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>constrain</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>default_user</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>default_role</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>default_type</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>default_range</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>dominance - MLS</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>dominance - Role (Deprecated)</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>dontaudit</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>fs_use_task</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>fs_use_trans</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>fs_use_xattr</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>genfscon</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>if</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>level</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>mlsconstrain</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>mlsvalidatetrans</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>module</td>
<td>No</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>netifcon </td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>neverallow</td>
<td>Yes</td>
<td>Yes</td>
<td><strong>Yes</strong><sup><strong><a href="#fnk3" class="footnote-ref" id="fnker3"><sup>3</sup></a></strong></sup></td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>nodecon</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>optional</td>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr>
<td>permissive</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>policycap</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>portcon</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>range_transition</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>require</td>
<td>No</td>
<td><strong>Yes</strong><sup><strong><a href="#fnk4" class="footnote-ref" id="fnker4"><sup>4</sup></a></strong></sup></td>
<td>Yes</td>
<td><strong>Yes</strong><sup><strong><a href="#fnk5" class="footnote-ref" id="fnker5"><sup>5</sup></a></strong></sup></td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>role</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr>
<td>roleattribute</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>role_transition</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>sensitivity</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>Yes</td>
</tr>
<tr>
<td>sid</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
<tr>
<td>type</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>Yes</td>
</tr>
<tr>
<td>type_change</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>type_member</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>type_transition</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>typealias</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>typeattribute</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>typebounds</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr>
<td>user</td>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr>
<td>validatetrans</td>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>

**Table 3: The policy language statements and rules that are allowed within
each type of policy source file** - *The left hand side of the table shows
what Policy Language Statements and Rules are allowed within each type of
policy source file. The right hand side of the table shows whether the
statement is valid within the *if/else* construct, *optional {rule_list}*,
or *require {rule_list}* statement.*


## Section Contents

The policy language statement and rule sections are as follows:

-   [Policy Configuration Statements](policy_config_statements.md#policy-configuration-statements)
-   [Default Rules](default_rules.md#default-object-rules)
-   [User Statements](user_statements.md#user-statements)
-   [Role Statements](role_statements.md#role-statements)
-   [Type Statements](type_statements.md#type-statements)
-   [Bounds Rules](bounds_rules.md#bounds-rules)
-   [Access Vector Rules](avc_rules.md#access-vector-rules)
-   [Extended Access Vector Rules](xperm_rules.md#extended-access-vector-rules)
-   [Object Class and Permission Statements](class_permission_statements.md#object-class-and-permission-statements)
-   [Conditional Policy Statements](conditional_statements.md#conditional-policy-statements)
-   [Constraint Statements](constraint_statements.md#constraint-statements)
-   [MLS Statements](mls_statements.md#mls-statements)
-   [Security ID (SID) Statement](sid_statement.md#security-id-sid-statement)
-   [File System Labeling Statements](file-labeling-statements.md#file-system-labeling-statements)
-   [Network Labeling Statements](network_statements.md#network-labeling-statements)
-   [InfiniBand Labeling Statements](infiniband_statements.md#infiniband-labeling-statements)
-   [XEN Statements](xen_statements.md#xen-statements)

Note these are not kernel policy statements, but used by the Reference Policy
to assist policy build:
-   [Modular Policy Support Statements](modular_policy_statements.md#modular-policy-support-statements)


<section class="footnotes">
<ol>
<li id="fn1"><p>It is important to note that the <strong>Reference Policy</strong> builds policy using makefiles and m4 support macros within its own source file structure. However, the end result of the make process is that there can be three possible types of source file built (depending on the <strong>MONOLITHIC=Y/N</strong> build option). These files contain the policy language statements and rules that are finally complied into a binary policy.<a href="#fnker1" class="footnote-back">↩</a></p></li>
<li id="fn2"><p>This does not include the <em>file_contexts</em> file as it does not contain policy statements, only default security contexts (labels) that will be used to label files and directories.<a href="#fnker2" class="footnote-back">↩</a></p></li>
<li id="fnk3"><p><code>neverallow</code> statements are allowed in modules, however to detect these the <em>semanage.conf</em> file must have the <code>expand-check=1</code> entry present.<a href="#fnker3" class="footnote-back">↩</a></p></li>
<li id="fnk4"><p>Only if preceded by the <code>optional</code> statement.<a href="#fnker4" class="footnote-back">↩</a></p></li>
<li id="fnk5"><p>Only if preceded by the <code>optional</code> statement.<a href="#fnker5" class="footnote-back">↩</a></p></li>
</ol>
</section>


<!-- %CUTHERE% -->

---
**[[ PREV ]](cil_overview.md)** **[[ TOP ]](#)** **[[ NEXT ]](policy_config_statements.md)**
