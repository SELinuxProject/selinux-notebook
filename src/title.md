
## Copyright Information

Copyright (c) 2020 [*Richard Haines*](mailto:richard_c_haines@btinternet.com)

Copyright (c) 2020 [*Paul Moore*](mailto:paul@paul-moore.com)

Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3 or
any later version published by the Free Software Foundation.

See: **<http://www.gnu.org/licenses/fdl-1.3.html>**

## Acknowledgements

The Notebook was originally created by *Richard Haines* who graciously donated
the source material to the SELinux project.

The SELinux logo was designed by [*Máirín Duffy*](https://blog.linuxgrrl.com).

<!-- %PAGEBREAK% -->

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

#### Notebook Examples

The Notebook examples are not embedded into any of the document formats
described in
**<https://github.com/SELinuxProject/selinux-notebook/blob/main/BUILD.md>**,
however they will have links to them in their build directories.

### Updated Editions

The SELinux Notebook is being maintained as part of the SELinux project, more
recent editions may be available.

See: **<https://github.com/SELinuxProject/selinux-notebook>**

<!-- %CUTHERE% -->

---
 **[[ TOP ]](#)** **[[ NEXT ]](toc.md)**
