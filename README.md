# The SELinux Notebook

![](./images/logo.png)


## Introduction

This Notebook should help with explaining:

1.  SELinux and its purpose in life.
2.  The LSM / SELinux architecture, its supporting services and how they
    are implemented within GNU / Linux.
3.  SELinux Networking, Virtual Machine, X-Windows, PostgreSQL and
    Apache/SELinux-Plus SELinux-aware capabilities.
4.  The core SELinux kernel policy language and how basic policy modules
    can be constructed for instructional purposes.
5.  An introduction to the new Common Intermediate Language (CIL)
    implementation.
6.  The core SELinux policy management tools with examples of usage.
7.  The Reference Policy architecture, its supporting services and how
    it is implemented.
8.  The integration of SELinux within Android.

### Notebook Overview

This volume has the following major sections:

**SELinux Overview** - Gives a description of SELinux and its major
components to provide Mandatory Access Control services for GNU / Linux.
Hopefully it will show how all the SELinux components link together and
how SELinux-aware applications / object manager have been implemented
(such as Networking, X-Windows, PostgreSQL and virtual machines).

**SELinux Configuration Files** - Describes all known SELinux
configuration files with samples. Also lists any specific SELinux
commands or libselinux APIs used by them.

**SELinux Policy Language** - Gives a brief description of each policy
language statement, with supporting examples taken from the Reference
Policy source. Also an introduction to the new CIL language (Common
Intermediate Language).

**The Reference Policy** - Describes the Reference Policy and its
supporting macros.

**Android** - An overview of the SELinux services used to support
Android.

**Object Classes and Permissions** - Describes the SELinux object
classes and permissions.

## Table of Contents

-   [Abbreviations and Terminology](terminology.md#abbreviations-and-terminology)
-   [SELinux Overview](selinux_overview.md#selinux-overview)
-   [Core Components](core_components.md#core-selinux-components)
-   [Mandatory Access Control (MAC)](mac.md#mandatory-access-control)
-   [SELinux Users](users.md#selinux-users)
-   [Role-Based Access Control (RBAC)](rbac.md#role-based-access-control)
-   [Type Enforcement (TE)](type_enforcement.md#type-enforcement)
-   [Security Context](security_context.md#security-context)
-   [Subjects](subjects.md#subjects)
-   [Objects](objects.md#objects)
-   [Computing Security Contexts](computing_security_contexts.md#computing-security-contexts)
-   [Computing Access Decisions](computing_access_decisions.md#computing-access-decisions)
-   [Domain and Object Transitions](domain_object_transitions.md#domain-and-object-transitions)
-   [Multi-Level and Multi-Category Security](mls_mcs.md#multi-level-and-multi-category-security)
-   [Types of SELinux Policy](types_of_policy.md#types-of-selinux-policy)
-   [Permissive and Enforcing Modes](modes.md#selinux-permissive-and-enforcing-modes)
-   [Auditing Events](auditing.md#auditing-selinux-events)
-   [Polyinstantiation Support](polyinstantiation.md#polyinstantiation-support)
-   [PAM Login Process](pam_login.md#pam-login-process)
-   [Linux Security Module and SELinux](lsm_selinux.md#linux-security-module-and-selinux)
-   [Userspace Libraries](userspace_libraries.md#selinux-userspace-libraries)
-   [Networking Support](network_support.md#selinux-networking-support)
-   [Virtual Machine Support](vm_support.md#selinux-virtual-machine-support)
-   [X-Windows Support](x_windows.md#x-windows-selinux-support)
-   [SE-PostgreSQL Support](postgresql.md#postgresql-selinux-support)
-   [Apache-Plus Support](apache_support.md#apache-selinux-support)
-   [SELinux Configuration Files](configuration_files.md#selinux-configuration-files)
    -   [Global Configuration Files](global_config_files.md#global-configuration-files)
    -   [Policy Store Configuration Files](policy_store_config_files.md#policy-store-configuration-files)
    -   [Policy Configuration Files](policy_config_files.md#policy-configuration-files)
-   [SELinux Policy Languages](policy_languages.md#the-selinux-policy-languages)
    -   [CIL Policy Language](cil_overview.md#cil-overview)
        -   [CIL Reference Guide](notebook-examples/selinux-policy/cil/CIL_Reference_Guide.pdf)
    -   [Kernel Policy Language](kernel_policy_language.md#kernel-policy-language)
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
        -   [File System Labeling Statements](file_labeling_statements.md#file-system-labeling-statements)
        -   [Network Labeling Statements](network_statements.md#network-labeling-statements)
        -   [InfiniBand Labeling Statements](infiniband_statements.md#infiniband-labeling-statements)
        -   [XEN Statements](xen_statements.md#xen-statements)
        -   [Modular Policy Support Statements](modular_policy_statements.md#modular-policy-support-statements)
-   [The Reference Policy](reference_policy.md#the-reference-policy)
-   [Implementing SELinux-aware Applications](implementing_seaware_apps.md#implementing-selinux-aware-applications)
-   [SE for Android](seandroid.md#security-enhancements-for-android)
-   [Appendix A - Object Classes and Permissions](object_classes_permissions.md#appendix-a---object-classes-and-permissions)
-   [Appendix B - `libselinux` API Summary](libselinux_functions.md#appendix-b---libselinux-api-summary)
-   [Appendix C - SELinux Commands](selinux_cmds.md#appendix-c---selinux-commands)
-   [Appendix D - Debugging Policy - Hints and Tips](debug_policy_hints.md#appendix-d---debugging-policy---hints-and-tips)
-   [Appendix E - Policy Validation Example](policy_validation_example.md#appendix-e---policy-validation-example)

## Copyright Information

Copyright © 2020 [*Richard Haines*](mailto:richard_c_haines@btinternet.com).

Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3 or
any later version published by the Free Software Foundation.

See: **<http://www.gnu.org/licenses/fdl-1.3.html>**

## Acknowledgements

Logo designed by [*Máirín Duffy*](http://pookstar.deviantart.com/)

## Building HTML/PDF Versions

The [**BUILD.md**](BUILD.md) file describes how to build these, however
the best way to view is using a browser with a
[**Markdown Viewer**](BUILD.md) addon.

<br>

<!-- Cut Here -->


<table>
<tbody>
<td><center>
<p><a href="terminology.md#abbreviations-and-terminology" title="Abbreviations and Terminology"> <strong>Next</strong></a></p>
</center></td>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>
