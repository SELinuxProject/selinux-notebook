# Abbreviations and Terminology

-   [Abbreviations](#abbreviations)
-   [Terminology](#terminology)

## Abbreviations

**AV**

Access Vector

**AVC**

Access Vector Cache

**BLP**

Bell-LaPadula

**CC**

[Common Criteria](http://www.commoncriteriaportal.org/)

**CIL**

Common Intermediate Language

**CMW**

Compartmented Mode Workstation

**DAC**

Discretionary Access Control

**FLASK**

Flux Advanced Security Kernel

**Fluke**

Flux kernel Environment

**Flux**

The Flux Research Group

**ID**

Identification

**LSM**

Linux Security Module

**LAPP**

Linux, Apache, PostgreSQL, PHP / Perl / Python

**LSPP**

Labeled Security Protection Profile

**MAC**

Mandatory Access Control

**MCS**

Multi-Category Security

**MLS**

Multi-Level Security

**MMAC**

Middleware Mandatory Access Control

**NSA**

National Security Agency

**OM**

Object Manager

**OTA**

over the air

**PAM**

Pluggable Authentication Module

**RBAC**

Role-based Access Control

**RBACSEP**

Role-based Access Control Separation

**rpm**

Red Hat Package Manager

**SELinux**

Security Enhanced Linux

**SID**

Security Identifier

**SMACK**

[Simplified Mandatory Access Control Kernel](http://www.schaufler-ca.com/)

**SUID**

Super-user Identifier

**TE**

Type Enforcement

**UID**

User Identifier

**XACE**

X (windows) Access Control Extension

## Terminology

These give a brief introduction to the major components that form the
core SELinux infrastructure.

**Access Vector (AV)**

A bit map representing a set of permissions (such as open, read, write).

**Access Vector Cache (AVC)**

A component that stores access decisions made by the SELinux **Security Server**
for subsequent use by **Object Managers**. This allows previous decisions to
be retrieved without the overhead of re-computation. Within the core SELinux
services there are two **Access Vector Caches**:

1. A kernel AVC that caches decisions by the **Security Server** on behalf of
   kernel based object managers.
2. A userspace AVC built into libselinux that caches decisions when
   SELinux-aware applications use ***avc_open**(3)* with ***avc_has_perm**(3)*
   or ***avc_has_perm_noaudit**(3)* function calls. This will save calls to the
   kernel after the first decision has been made. Note that the preferred
   option is to use the ***selinux_check_access**(3)* function as this will
   utilise the userspace AVC as explained in the
   [**Computing Access Decisions**](computing_access_decisions.md#computing-access-decisions)
   section.

**Domain**

For SELinux this consists of one or more processes associated to the type
component of a **Security Context**. **Type Enforcement** rules declared in
policy describe how the domain will interact with objects (see **Object Class**).

**Linux Security Module (LSM)**

A framework that provides hooks into kernel components (such as disk and
network services) that can be utilised by security modules (e.g. **SELinux** and
SMACK) to perform access control checks. Work is in progress to stack multiple
modules

**Mandatory Access Control**

An access control mechanism enforced by the system. This can be achieved
by 'hard-wiring' the operating system and applications or via a policy that
conforms to a **Policy**. Examples of policy based MAC are **SELinux** and SMACK.

**Multi-Level Security (MLS)**

Based on the Bell & LaPadula model (BLP) for confidentiality in that
(for example) a process running at a 'Confidential' level can read / write at
their current level but only read down levels or write up levels. While still
used in this way, it is more commonly used for application separation
utilising the Multi-Category Security (MCS) variant.

**Object Class**

Describes a resource such as files, sockets or services. Each 'class' has
relevant permissions associated to it such as read, write or export.
This allows access to be enforced on the instantiated object by their
**Object Manager**.

**Object Manager**

Userspace and kernel components that are responsible for the labeling,
management (e.g. creation, access, destruction) and enforcement of the objects
under their control. **Object Managers** call the **Security Server** for an
access decision based on a source and target **Security Context**
(or **SID**), an **Object Class** and a set of permissions (or **AV**s).
The **Security Server** will base its decision on whether the currently loaded
**Policy** will allow or deny access. An **Object Manager** may also call the
**Security Server** to compute a new **Security Context** or **SID**
for an object.

**Policy**

A set of rules determining access rights. In SELinux these rules are generally
written in a kernel policy language using either ***m4**(1)* macro support
(e.g. Reference Policy) or the CIL language. The **Policy** is then compiled
into a binary format for loading into the **Security Server**.

**Role Based Access Control**

SELinux users are associated to one or more roles, each role may then be
associated to one or more **Domain** types.

**Role Based Access Control-Separation**

Role-based separation of user home directories. An optional policy tunable is
required: *tunableif enable_rbacsep*

**Security Server**

A sub-system in the Linux kernel that makes access decisions and computes
security contexts based on **Policy** on behalf of SELinux-aware applications
and Object Managers. The **Security Server** does not enforce a decision, it
merely states whether the operation is allowed or not according to the
**Policy**. It is the SELinux-aware application or **Object Manager**
responsibility to enforce the decision.

**Security Context**

An SELinux **Security Context** is a variable length string that consists of
the following mandatory components *user:role:type* and an optional *[:range]*
component. Generally abbreviated to 'context', and sometimes called a 'label'.

**Security Identifier (SID)**

SIDs are unique opaque integer values mapped by the kernel **Security Server**
and userspace AVC that represent a **Security Context**. The SIDs generated
by the kernel **Security Server** are `u32` values that are passed via the
**Linux Security Module** hooks to/from the kernel **Object Managers**.

**Type Enforcement**

SELinux makes use of a specific style of type enforcement (TE) to enforce
**Mandatory Access Control**. This is where all subjects and objects have a
type identifier associated to them that can then be used to enforce rules
laid down by **Policy**.

<!-- %CUTHERE% -->

---
**[[ PREV ]](toc.md)** **[[ TOP ]](#)** **[[ NEXT ]](selinux_overview.md)**
