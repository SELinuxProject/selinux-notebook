# Kernel Policy Language

- [Policy Source Files](#policy-source-files)
- [Conditional, Optional and Require Statement Rules](#conditional-optional-and-require-statement-rules)
- [MLS Statements and Optional MLS Components](#mls-statements-and-optional-mls-components)
- [General Statement Information](#general-statement-information)
- [Policy Language Index](#policy-language-index)

This section covers the policy source file types and what kernel policy
statements and rule are allowed in each. The
[**Policy Language Index**](#policy-language-index)
then has links to each section within this document.

## Policy Source Files

There are three basic types of policy source file[^fn_kpl_1] that can contain
language statements and rules. The three types of policy source file[^fn_kpl_2]
are:

**Monolithic Policy** - This is a single policy source file that
contains all statements. By convention this file is called policy.conf
and is compiled using the ***checkpolicy**(8)* command that produces the
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

| Base Entries                                   | M/O |
| :--------------------------------------------- | :-: |
| Security Classes (class)                       | m   |
| Initial SIDs                                   | m   |
| Access Vectors (permissions)                   | m   |
| require Statement                              | o   |
| MLS sensitivity, category and level Statements | o   |
| MLS Constraints                                | m   |
| Policy Capability Statements                   | o   |
| Attributes                                     | o   |
| Booleans                                       | o   |
| Default user, role, type, range rules          | o   |
| Type / Type Alias                              | m   |
| Roles                                          | m   |
| Policy Rules (allow, dontaudit etc.)           | m   |
| Users                                          | m   |
| Constraints                                    | o   |
| Default SID labeling                           | m   |
| fs_use_xattr Statements                        | o   |
| fs_use_task and fs_use_trans Statements        | o   |
| genfscon Statements                            | o   |
| portcon, netifcon and nodecon Statements       | o   |

| Module Entries    | M/O |
| :---------------- | :-: |
| module Statement  | m   |
| require Statement | o   |
| Attributes        | o   |
| Booleans          | o   |
| Type / Type Alias | o   |
| Roles             | o   |
| Policy Rules      | o   |
| Users             | o   |

**Table 1: Base and Module Policy Statements** - *There must be at least one
of each of the mandatory statements, plus at least one allow rule in a policy
to successfully build.*

The language grammar defines what statements and rules can be used
within the different types of source file. To highlight these rules, the
following table is included in each statement and rule section to show
what circumstances each one is valid within a policy source file.

**Policy Type**:

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes/No                  | Yes/No                  | Yes/No                  |

**Where:**

*Monolithic Policy*

- Whether the statement is allowed within a monolithic policy source file or not.

*Base Policy*

- Whether the statement is allowed within a base (for loadable module support)
  policy source file or not.

*Module Policy*

- Whether the statement is allowed within the optional loadable module policy
  source file or not.

## Conditional, Optional and Require Statement Rules

The language grammar specifies what statements and rules can be included
within:

1. [**Conditional Policy**](conditional_statements.md#conditional-policy-statements)
   rules that are part of the kernel policy language.
2. *optional* and *require* rules that are NOT part of the kernel policy
   language, but **Reference Policy** ***m4**(1)* macros used to control
   policy builds (see the
   [**Modular Policy Support Statements**](modular_policy_statements.md#modular-policy-support-statements)
   section.

To highlight these rules the following table is included in each
statement and rule section to show what circumstances each one is valid
within a policy source file:

**Conditional Policy Statements:**

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| Yes/No                  | Yes/No                  | Yes/No                  |

**Where:**

*if Statement*

- Whether the statement is allowed within a conditional statement
  (*if/else* construct). Conditional statements can be in all types
  of policy source file.

*optional Statement*

- Whether the statement is allowed within the *optional { rule_list }* construct.

*require Statement*

- Whether the statement is allowed within the *require { rule_list }* construct.

## MLS Statements and Optional MLS Components

The [**MLS Statements**](mls_statements.md#mls-statements) section defines
statements specifically for MLS support. However when MLS is enabled,
there are other statements that require the MLS component of a security
context as an argument, (for example the
[**Network Labeling Statements**](network_statements.md#network-labeling-statements)),
therefore these statements show an example taken from the
MLS **Reference Policy** build.

## General Statement Information

1. Identifiers can generally be any length but should be restricted to
   the following characters: a-z, A-Z, 0-9 and \_ (underscore).
2. A '\#' indicates the start of a comment in policy source files.
3. All statements available to policy version 29 have been included.
4. When multiple source and target entries are shown in a single
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

1. Some statements can be added to a policy via the policy store using
   the **semanage**(8) command. Examples of these are shown where
   applicable, however the **semanage** man page should be consulted
   for all the possible command line options.
2. **Table 2** lists words reserved for the SELinux  policy language.

|                 |                |                    |                  |
| :-------------- | :------------- | :----------------- | :--------------- |
| alias           | allow          | allowxperm         | and              |
| attribute       | attribute_role | auditallow         | auditallowxperm  |
| auditdeny       | bool           | category           | cfalse           |
| class           | clone          | common             | constrain        |
| ctrue           | default_range  | default_role       | default_type     |
| default_user    | dom            | domby              | dominance        |
| dontaudit       | else           | equals             | expandattribute  |
| false           | filename       | filesystem         | fscon            |
| fs_use_task     | fs_use_trans   | fs_use_xattr       | genfscon         |
| h1              | h2             | high               | ibendportcon     |
| ibpkeycon       | identifier     | if                 | incomp           |
| inherits        | iomemcon       | ioportcon          | ipv4_addr        |
| ipv6_addr       | l1             | l2                 | level            |
| low             | low_high       | mlsconstrain       | mlsvalidatetrans |
| module          | netifcon       | neverallow         | neverallowxperm  |
| neverallowxperm | nodecon        | not                | notequal         |
| number          | object_r       | optional           | or               |
| path            | pcidevicecon   | permissive         | pirqcon          |
| policycap       | portcon        | r1                 | r2               |
| r3              | range          | range_transition   | require          |
| role            | roleattribute  | roles              | role_transition  |
| sameuser        | sensitivity    | sid                | source           |
| t1              | t2             | t3                 | target           |
| true            | type           | typealias          | typeattribute    |
| typebounds      | type_change    | type_member        | types            |
| type_transition | u1             | u2                 | u3               |
| user            | validatetrans  | version_identifier | xor              |

**Table 2: Policy language reserved words**

**Table 3** shows what policy language statements and rules are allowed
within each type of policy source file, and whether the statement is valid
within an *if/else* construct, *optional {rule_list}*, or
*require {rule_list}* statement.

| Statement / Rule | Monolithic Policy | Base Policy | Module Policy | Conditional Statements | optional Statement | require Statement |
| :--------------- | :---------------: | :---------: | :-----------: | :--------------------: | :----------------: | :---------------: |
| *allow*          |        Yes        |      Yes    |      Yes      |          Yes           |         Yes        |        No         |
| *allow* - Role   |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *allowxperm*     |        Yes        |      Yes    |      Yes      |          No            |         No         |        No         |
| *attribute*      |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        Yes        |
| *attribute_role* |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        Yes        |
| *auditallow*     |        Yes        |      Yes    |      Yes      |          Yes           |         Yes        |        No         |
| *auditallowxperm*|        Yes        |      Yes    |      Yes      |          No            |         No         |        No         |
| *auditdeny* (Deprecated)| Yes        |      Yes    |      Yes      |          Yes           |         Yes        |        No         |
| *bool*           |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        Yes        |
| *category*       |        Yes        |      Yes    |      No       |          No            |         No         |        Yes        |
| *class*          |        Yes        |      Yes    |      No       |          No            |         No         |        Yes        |
| *common*         |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *constrain*      |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *default_user*   |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *default_role*   |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *default_type*   |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *default_range*  |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *dominance* - MLS|        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *dominance* - Role (Deprecated)| Yes |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *dontaudit*      |        Yes        |      Yes    |      Yes      |          Yes           |         Yes        |        No         |
| *dontauditxperm* |        Yes        |      Yes    |      Yes      |          No            |         No         |        No         |
| *expandattribute*|        Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *fs_use_task*    |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *fs_use_trans*   |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *fs_use_xattr*   |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *genfscon*       |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *ibpkeycon*      |        Yes        |      Yes    |      Yes      |          No            |         No         |        No         |
| *ibendportcon*   |        Yes        |      Yes    |      Yes      |          No            |         No         |        No         |
| *if*             |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *level*          |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *mlsconstrain*   |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *mlsvalidatetrans*|       Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *module*         |        No         |      No     |      Yes      |          No            |         No         |        No         |
| *netifcon*       |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *neverallow*     |        Yes        |      Yes    |Yes [^fn_kpl_3]|          No            |         Yes        |        No         |
| *neverallowxperm*|        Yes        |      Yes    |      Yes      |          No            |         No         |        No         |
| *nodecon*        |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *optional*       |        No         |      Yes    |      Yes      |          Yes           |         Yes        |        Yes        |
| *permissive*     |        Yes        |      Yes    |      Yes      |          Yes           |         Yes        |        No         |
| *policycap*      |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *portcon*        |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *range_transition*|       Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *require*        |        No         |Yes [^fn_kpl_4]|    Yes      |     Yes [^fn_kpl_5]    |         Yes        |        No         |
| *role*           |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        Yes        |
| *roleattribute*  |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *role_transition*|        Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *sensitivity*    |        Yes        |      Yes    |      No       |          No            |         No         |        Yes        |
| *sid*            |        Yes        |      Yes    |      No       |          No            |         No         |        No         |
| *type*           |        Yes        |      Yes    |      Yes      |          No            |         No         |        Yes        |
| *type_change*    |        Yes        |      Yes    |      Yes      |          Yes           |         Yes        |        No         |
| *type_member*    |        Yes        |      Yes    |      Yes      |          Yes           |         Yes        |        No         |
| *type_transition*|        Yes        |      Yes    |      Yes      |     Yes [^fn_kpl_6]    |         Yes        |        No         |
| *typealias*      |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *typeattribute*  |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *typebounds*     |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        No         |
| *user*           |        Yes        |      Yes    |      Yes      |          No            |         Yes        |        Yes        |
| *validatetrans*  |        Yes        |      Yes    |      No       |          No            |         No         |        No         |

**Table 3: The policy language statements and rules that are allowed within
each type of policy source file** - *The left hand side of the table shows
what Policy Language Statements and Rules are allowed within each type of
policy source file. The right hand side of the table shows whether the
statement is valid within the if/else construct, optional {rule_list},
or require {rule_list} statement.*

## Policy Language Index

The policy language statement and rule sections are as follows:

- [Policy Configuration Statements](policy_config_statements.md#policy-configuration-statements)
- [Default Rules](default_rules.md#default-object-rules)
- [User Statements](user_statements.md#user-statements)
- [Role Statements](role_statements.md#role-statements)
- [Type Statements](type_statements.md#type-statements)
- [Bounds Rules](bounds_rules.md#bounds-rules)
- [Access Vector Rules](avc_rules.md#access-vector-rules)
- [Extended Access Vector Rules](xperm_rules.md#extended-access-vector-rules)
- [Object Class and Permission Statements](class_permission_statements.md#object-class-and-permission-statements)
- [Conditional Policy Statements](conditional_statements.md#conditional-policy-statements)
- [Constraint Statements](constraint_statements.md#constraint-statements)
- [MLS Statements](mls_statements.md#mls-statements)
- [Security ID (SID) Statement](sid_statement.md#security-id-sid-statement)
- [File System Labeling Statements](file-labeling-statements.md#file-system-labeling-statements)
- [Network Labeling Statements](network_statements.md#network-labeling-statements)
- [InfiniBand Labeling Statements](infiniband_statements.md#infiniband-labeling-statements)
- [XEN Statements](xen_statements.md#xen-statements)

Note these are not kernel policy statements, but used by the Reference Policy
to assist policy build:

- [Modular Policy Support Statements](modular_policy_statements.md#modular-policy-support-statements)

[^fn_kpl_1]: It is important to note that the Reference Policy builds policy
using makefiles and m4 support macros within its own source file structure.
However, the end result of the make process is that there can be three possible
types of source file built (depending on the *MONOLITHIC=Y/N* build option).
These files contain the policy language statements and rules that are finally
complied into a binary policy.

[^fn_kpl_2]: This does not include the *file_contexts* file as it does not
contain policy statements, only default security contexts (labels) that will be
used to label files and directories.

[^fn_kpl_3]: *neverallow* statements are allowed in modules, however to detect
these the *semanage.conf* file must have the *expand-check=1* entry present.

[^fn_kpl_4]: Only if preceded by the *optional* statement.

[^fn_kpl_5]: Only if preceded by the *optional* statement.

[^fn_kpl_6]: 'Name transition rules' are not allowed inside *conditional*
statements.

<!-- %CUTHERE% -->

---
**[[ PREV ]](cil_overview.md)** **[[ TOP ]](#)** **[[ NEXT ]](policy_config_statements.md)**
