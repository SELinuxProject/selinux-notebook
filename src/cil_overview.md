# CIL Overview

The CIL language statements are not included in the SELinux Notebook as they
have been documented within the CIL compiler source, available at:

<https://github.com/SELinuxProject/selinux/tree/master/secilc/docs>

A PDF version is included in this documentation:
[**CIL Reference Guide**](notebook-examples/selinux-policy/cil/CIL_Reference_Guide.pdf)

The CIL compiler source can be found at:
<https://github.com/SELinuxProject/selinux.git> within the *secilc* and
*libsepol* sections and can be cloned via:
-    *git clone https://github.com/SELinuxProject/selinux.git*

While the CIL design web pages give the main objectives of CIL, from a
language perspective it will:

1.  Apply name and usage consistency to the current kernel language
    statements. For example the kernel language uses *attribute* and
    *attribute_role* to declare identifiers, whereas CIL uses
    *typeattribute* and *roleattribute*. Also statements to associate
    types or roles have been made consistent and enhanced to allow
    expressions to be defined.

-   Examples:

|    Kernel        |      CIL           |
| ---------------- | ------------------ |
| *attribute*      | *typeattribute*    |
| *typeattribute*  | *typeattributeset* |
| *attribute_role* | *roleattribute*    |
| *roleattribute*  | *roleattributeset* |
| *allow*          | *allow*            |
| *allow* (role)   | *roleallow*        |
| *dominance*      | *sensitivityorder* |


2.  Additional CIL statements have been defined to enhance
    functionality:

-   *classpermission* - Declare a *classpermissionset* identifier.

-   *classpermissionset* - Associate class / permissions also supporting
expressions.

-   *classmap* / *classmapping* - Statements to support declaration and
association of multiple *classpermissionset*'s. Useful when defining an
*allow* rule with multiple class/permissions.

-   *context* - Statement to declare security context.

3.  Allow named and anonymous definitions to be supported.
4.  Support namespace features allowing policy modules to be defined
    within blocks with inheritance and template features.
5.  Remove the order dependency in that policy statements can be
    anywhere within the source (i.e. remove dependency of class, sid
    etc. being within a base module).
6.  Able to define macros and calls that will remove any dependency on
    M4 macro support.
7.  Directly generate the binary policy file and other configuration
    files - currently the *file_contexts* file.
8.  Support transformation services such as delete, transform and
    inherit with exceptions.

An simple CIL policy is as follows:

```
; These CIL statements declare a user, role, type and range of:
;    unconfined.user:unconfined.role:unconfined.process:s0-s0
;
; A CIL policy requires at least one 'allow' rule and sid to be declared
; before a policy will build.
;
(handleunknown allow)
(mls true)
(policycap open_perms)
(category c0)
(categoryorder (c0))
(sensitivity s0)
(sensitivityorder (s0))
(sensitivitycategory s0 (c0))
(level systemLow (s0))
(levelrange low_low (systemLow systemLow))
(sid kernel)
(sidorder (kernel))
(sidcontext kernel unconfined.sid_context)
(classorder (file))
(class file (read write open getattr))

; Define object_r role. This must be assigned in CIL.
(role object_r)

; The unconfined namespace:
(block unconfined
	(user user)
	(userrange user (systemLow systemLow))
	(userlevel user systemLow)
	(userrole user role)
	(role role)
	(type process)
	(roletype object_r process)
	(roletype role process)

	; Define a SID context:
	(context sid_context (user role process low_low))

	(type object)
	(roletype object_r object)

	; An allow rule:
	(allow process object (file (read)))
)
```

For more complex CIL policy try these: <https://github.com/DefenSec>

There is a CIL policy in the Notebook examples with a utility
that will produce a base policy in either the kernel policy language or
CIL (*notebook-tools/build-sepolicy*). The only requirement is that the
*initial_sids*, *security_classes* and *access_vectors* files from
the Reference policy are required, although the Fedora 31 versions are
supplied in the *notebook-examples/selinux-policy/flask-files* directory.

An example output:
[**CIL policy**](./notebook-examples/selinux-policy/cil/cil-nb-policy.txt)

```
Usage: build-sepolicy [-k] [-M] [-c|-p|-s] -d flask_directory -o output_file
-k    Output kernel classes only.
-M    Output an MLS policy.
-c    Output a policy in CIL language (else generate kernel policy language policy).
-p    Output a file containing class and classpermissionsets + their order for use by CIL policies.
-s    Output a file containing initial SIDs + their order for use by CIL policies.
-d    Directory containing the initial_sids, security_classes and access_vectors Flask files.
-o    The output file that will contain the policy source or header file.
```
There is another CIL policy in the notebook examples called
"cil-policy" that takes a slightly different approach where the goal
is to keep the policy as simple as possible. It requires *semodule*,
Linux 5.7, SELinux 3.1 and can be installed by executing
*make install*. It leverages some modern SELinux features, most
notably where the requirement for ordered security classes is lifted.
With this you are no longer expected to be aware of all the access
vectors managed by Linux in order to align your security class
declarations with the order in which they are declared in the kernel.
A module store is created by *semodule* to give easy access to the
source and that allows for full control over the policy.


<!-- %CUTHERE% -->

---
**[[ PREV ]](policy_languages.md)** **[[ TOP ]](#)** **[[ NEXT ]](kernel_policy_language.md)**
