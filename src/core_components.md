# Core SELinux Components

**Figure 1** shows a high level diagram of the SELinux core components that
manage enforcement of the policy and comprise of the following:

1. A [**Subject**](subjects.md#subjects) that must be present to cause an action
   to be taken by an [**Object**](objects.md#objects) (such as read a file as
   information only flows when a subject is involved).
2. An Object Manager that knows the actions required of the particular
   resource (such as a file) and can enforce those actions (i.e. allow
   it to write to a file if permitted by the policy).
3. A Security Server that makes decisions regarding the subjects rights
   to perform the requested action on the object, based on the security
   policy rules.
4. A Security Policy that describes the rules using the SELinux
   [**Kernel Policy Language**](kernel_policy_language.md#kernel-policy-language)).
5. An Access Vector Cache (AVC) that improves system performance by
   caching security server decisions.

![](./images/1-core.png)

**Figure 1: High Level Core SELinux Components** - *Decisions by the
Security Server are cached in the AVC to enhance performance of future
requests. Note that it is the kernel and userspace Object Managers that
enforce the policy.*

![](./images/2-high-level-arch.png)

**Figure 2: High Level SELinux Architecture** - *Showing the major supporting services*

**Figure 2** shows a more complex diagram of kernel and userspace with a number of
supporting services that are used to manage the SELinux environment.
This diagram will be referenced a number of times to explain areas of
SELinux, therefore starting from the bottom:

1. In the current implementation of SELinux the security server is
   embedded in the kernel with the policy being loaded from userspace via a
   series of functions contained in the **libselinux** library (see
   [**SELinux Userspace Libraries**](userspace_libraries.md#selinux-userspace-libraries)
   for details). The object managers (OM) and access vector cache (AVC) can
   reside in:
   - **kernel space** - These object manages are for the kernel services such
     as files, directory, socket, IPC etc. and are provided by hooks into the
     SELinux sub-system via the Linux Security Module (LSM) framework (shown
     as LSM Hooks in ) that is discussed in the
     [**Linux Security Module and SELinux**](lsm_selinux.md#linux-security-module-and-selinux)
     section. The SELinux kernel AVC service is used to cache the security
     servers response to the kernel based object managers thus speeding up
     access decisions should the same request be asked in future.
   - **userspace** - These object managers are provided with the application
     or service that requires support for MAC and are known as
     'SELinux-aware' applications or services. Examples of these are:
     X-Windows, D-bus messaging (used by the Gnome desktop), PostgreSQL
     database, Name Service Cache Daemon (*nscd*), and the GNU / Linux passwd
     command. Generally, these OMs use the AVC services built into the
     SELinux library (libselinux), however they could, if required supply
     their own AVC or not use an AVC at all (see
     [**Implementing SELinux-aware Applications**](implementing_seaware_apps.md#implementing-selinux-aware-applications)
     for details).
2. The SELinux security policy (right hand side of **Figure 2**) and its
   supporting configuration files are contained in the /etc/selinux directory.
   This directory contains the main SELinux configuration file *config* that has
   the name of the policy to be loaded (via the *SELINUXTYPE* entry) and the
   initial enforcement mode[^fn_cc_1] of the policy at load time (via the
   *SELINUX* entry). The */etc/selinux/\<SELINUXTYPE\>* directories contain
   policies that can be activated along with their configuration files (e.g.
   '*SELINUXTYPE=targeted*' will have its policy and associated configuration
   files located at */etc/selinux/targeted*). All known configuration files are
   shown in the
   [**SELinux Configuration Files**](configuration_files.md#selinux-configuration-files)
   sections.
3. SELinux supports a 'modular policy', this means that a policy does not
   have to be one large source policy but can be built from modules. A
   modular policy consists of a base policy that contains the mandatory
   information (such as object classes, permissions etc.), and zero or more
   policy modules where generally each supports a particular application or
   service. These modules are compiled, linked, and held in a 'policy
   store' where they can be built into a binary format that is then loaded
   into the security server (in the diagram the binary policy is located at
   */etc/selinux/targeted/policy/policy.30*). The types of policy and their
   construction are covered in the
   [**Types of SELinux Policy**](types_of_policy.md#types-of-selinux-policy)
   section.
4. To be able to build the policy in the first place, policy source is
   required (top left hand side of **Figure 2**). This can be supplied in three
   basic ways:
   1. as source code written using the
      [**Kernel Policy Language**](kernel_policy_language.md#kernel-policy-language),
      however it is not recommended for large policy developments.
   2. using the **Reference Policy** that has high
      level macros to define policy rules. This is the standard way
      policies are now built for SELinux distributions such as Red Hat
      and Debian and is discussed in the
      [**The Reference Policy**](reference_policy.md#the-reference-policy)
      section. Note that SE for Android also uses high level macros to define
      policy rules.
   3. using CIL (Common Intermediate Language). An overview can be found
      in the [**CIL Policy Language**](cil_overview.md#cil-overview)
      section. The <https://github.com/DefenSec/dssp> is a good example.
5. To be able to compile and link the policy source then load it into the
   security server requires a number of tools (top of **Figure 2**).
6. To enable system administrators to manage policy, the SELinux
   environment and label file systems, tools and modified GNU / Linux
   commands are used. These are mentioned throughout the Notebook as needed
   and summarised in
   [**SELinux Commands**](selinux_cmds.md#appendix-c---selinux-commands).
   Note that there are many other applications to manage policy, however this
   Notebook only concentrates on the core services.
7. To ensure security events are logged, GNU / Linux has an audit service
   that captures policy violations. The
   [**Auditing Events**](auditing.md#auditing-selinux-events)
   section describes the format of these security events.
8. SELinux supports network services that are described in the
   [**SELinux Networking Support**](network_support.md#selinux-networking-support)
   section.

The [**Linux Security Module and SELinux**](lsm_selinux.md#linux-security-module-and-selinux)
section goes into greater detail of the LSM / SELinux modules with a walk
through of a ***fork**(2)* and ***exec**(2)* process.

[^fn_cc_1]: When SELinux is enabled, the policy can be running in
'permissive mode' (*SELINUX=permissive*), where all accesses are allowed.
The policy can also be run in 'enforcing mode' (*SELINUX=enforcing*), where any
access that is not defined in the policy is denied and an entry placed
in the audit log. SELinux can also be disabled (at boot time only) by
setting *SELINUX=disabled*. There is also support for the
[***permissive***](type_statements.md#permissive) statement that allows a
domain to run in permissive mode while the others are still confined
(instead of all or nothing set by *SELINUX=*). Note setting *SELINUX=disabled*
will be deprecated at some stage, in favor of the existing kernel command line
switch *selinux=0*, which allows users to disable SELinux at system boot. See
<https://github.com/SELinuxProject/selinux-kernel/wiki/DEPRECATE-runtime-disable>
that explains how to achieve this on various Linux distributions.

<!-- %CUTHERE% -->

---
**[[ PREV ]](selinux_overview.md)** **[[ TOP ]](#)** **[[ NEXT ]](mac.md)**
