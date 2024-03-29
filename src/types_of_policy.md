# Types of SELinux Policy

- [Reference Policy](#reference-policy)
- [Policy Functionality Based on Name or Type](#policy-functionality-based-on-name-or-type)
- [Custom Policy](#custom-policy)
- [Monolithic Policy](#monolithic-policy)
- [Loadable Module Policy](#loadable-module-policy)
  - [Optional Policy](#optional-policy)
- [Conditional Policy](#conditional-policy)
- [Binary Policy](#binary-policy)
- [Policy Versions](#policy-versions)

This section describes the different type of policy descriptions and
versions that can be found within SELinux.

The type of SELinux policy can described in a number of ways:

1. Source code - These can be described as:
   [**Reference Policy**](types_of_policy.md#reference-policy) or
   [**Custom**](types_of_policy.md#custom-policy).
   They are generally written using
   [**Kernel Policy Language**](kernel_policy_language.md#kernel-policy-language),
   [**Reference Policy Support Macros**](reference_policy.md#reference-policy-support-macros),
   or using [**CIL**](cil_overview.md#cil-overview)
2. They can also be classified as: [**Monolithic**](types_of_policy.md#monolithic-policy),
   [**Base Module or Loadable Module**](types_of_policy.md#reference-policy).
3. Policies can also be described by the
   [**type of policy functionality**](types_of_policy.md#policy-functionality-based-on-name-or-type) they
   provide such as: targeted, mls, mcs, standard, strict or minimum.
4. Classified using language statements - These can be described as
   [**Modular, Optional**](types_of_policy.md#reference-policy) or
   [**Conditional**](types_of_policy.md#conditional-policy).
5. Binary or Kernel policy. These are the compiled policy used by the kernel.
6. Classification can also be on the '[**policy version**](types_of_policy.md#policy-versions)'
   used (examples are version 22, 23 and 24).
7. Policy can also be generated depending on the target platform of
   either 'selinux' (the default) or 'xen' (see the SELinux policy
   generation tools ***checkpolicy**(8)*, ***secilc**(8)* and ***semanage**(8)*
   *target_platform* options).

As can be seen the description of a policy can vary depending on the
context.

## Reference Policy

Note that this section only gives an introduction to the Reference
Policy, the installation, configuration and building of a policy using
this is contained in
[**The Reference Policy**](reference_policy.md#the-reference-policy) section.

The Reference Policy is now the standard policy source used to build
Linux based SELinux policies, and its main aim is to provide a single
source tree with supporting documentation that can be used to build
policies for different purposes such as confining important daemons,
supporting MLS / MCS and locking down systems so that all processes are
under SELinux control.

The Reference Policy is now used by all major distributions of Linux,
however each distribution makes its own specific changes to support
their 'version of the Reference Policy'. For example, the Fedora
distribution is based on a specific build of the standard Reference
Policy that is then modified and distributed by Red Hat and distributed as a
number of RPMs.

The Reference Policy can be built as a Monolithic policy or as a Modular policy
that has a 'base module' with zero or more optional 'loadable modules'.

## Policy Functionality Based on Name or Type

Generally a policy is installed with a given name such as *targeted*,
*mls*, *refpolicy* or *minimum* that attempts to describes its
functionality. This name then becomes the entry in:

1. The directory pointing to the policy location (e.g. if the name is
   *targeted*, then the policy will be installed in
   */etc/selinux/targeted*).
2. The *SELINUXTYPE* entry in the */etc/selinux/config* file when it is
   the active policy (e.g. if the name is *targeted*, then a
   *SELINUXTYPE=targeted* entry would be in the */etc/selinux/config*
   file).

This is how the reference policies distributed with Fedora are named,
where:

- minimum - supports a minimal set of confined daemons within their own
  domains. The remainder run in the unconfined_t space. Red Hat
  pre-configure MCS support within this policy.
- targeted - supports a greater number of confined daemons and can also
  confine other areas and users. Red Hat pre-configure MCS support within
  this policy.
- mls - supports server based MLS systems.

The Reference Policy also has a *TYPE* description that describes the
type of policy being built by the build process, these are:

- standard - supports confined daemons and can also confine other areas
  and users.
- mcs - As standard but supports MCS labels.
- mls - supports server based MLS systems.

The *NAME* and *TYPE* entries are defined in the reference policy
*build.conf* file that is described in the Reference Policy
[**Source Configuration Files**](reference_policy.md#source-configuration-files)
section.

## Custom Policy

This generally refers to a policy source that is either:

1. A customised version of the Reference Policy (i.e. not the standard
   distribution version e.g. Red Hat policies).
2. A policy that has been built using policy language statements
   (CIL or Kernel) to build a specific policy such as the basic policy built
   in the Notebook *notebook-examples/selinux-policy* there are following
   policies:
   - [**Kernel Policy Language**](./notebook-examples/selinux-policy/kernel/kern-nb-policy.txt)
   - [**CIL Policy Language**](./notebook-examples/selinux-policy/cil/cil-nb-policy.txt)

These examples were built using the Notebook 'build-sepolicy' command that is
described in
[***build-sepolicy***](./notebook-examples/selinux-policy/tools/build-sepolicy.md),
this uses the Reference Policy *policy/flask* files (*security_classes*,
*access_vectors* and *initial_sids*) to build the object classes/permissions.
The kernel source has a similar policy build command in *scripts/selinux/mdp*,
however it uses the selinux kernel source files to build the object
classes/permissions (see kernel *Documentation/admin-guide/LSM/SELinux.rst*
for build instructions, also the
[**Notebook Sample Policy - README**](./notebook-examples/selinux-policy/README.md)).

## Monolithic Policy

A Monolithic policy is an SELinux policy that is compiled from one
source file called (by convention) *policy.conf* (i.e. it does not use
the Loadable Module Policy infrastructure which therefore makes it
suitable for embedded systems as there is no policy store overhead.

Monolithic policies are generally compiled using the ***checkpolicy**(8)*
SELinux command.

The Reference Policy supports building of monolithic policies.

In some cases the kernel policy binary file is also called a monolithic policy.

## Loadable Module Policy

The loadable module infrastructure allows policy to be managed on a
modular basis, in that there is a base policy module that contains all
the core components of the policy (i.e. the policy that should always be
present), and zero or more modules that can be loaded/unloaded as
required (for example if there is a module to enforce policy for ftp,
but ftp is not used, then that module could be unloaded).

There are number of components that form the infrastructure:

1. Policy source code that is constructed for a modular policy with a
   base module and optional loadable modules.
2. Utilities to compile and link modules and place them into a 'policy
   store'.
3. Utilities to manage the modules and associated configuration files
   within the 'policy store'.

[**Figure 2: High Level SELinux Architecture**](core_components.md#core-selinux-components)
shows these components along the top of the diagram. The files contained in
the policy store are detailed in the
[**Policy Store Configuration Files**](policy_store_config_files.md#policy-store-configuration-files)
section.

The policy language was extended to handle loadable modules as detailed
in the
[**Modular Policy Support Statements**](modular_policy_statements.md#modular-policy-support-statements)
section. For a detailed overview whiteon how the modular policy is built
into the final [**binary policy**](#policy-versions) for loading into
the kernel, see
"[**SELinux Policy Module Primer**](http://securityblog.org/brindle/2006/07/05/selinux-policy-module-primer/)".

### Optional Policy

The loadable module policy infrastructure supports an
[***optional***](modular_policy_statements.md#optional) policy statement that
allows policy rules to be defined but only enabled in the binary policy once
the conditions have been satisfied.

## Conditional Policy

Conditional policies can be implemented in monolithic or loadable module
policies and allow parts of the policy to be enabled or not depending on the
state of a boolean flag at run time.
This is often used to enable or disable features within the policy (i.e.
change the policy enforcement rules).

The boolean flag status is held in kernel and can be changed using the
***setsebool**(8)* command either persistently across system re-boots or
temporarily (i.e. only valid until a re-boot). The following example
shows a persistent conditional policy change:

```
setsebool -P ext_gateway_audit false
```

The conditional policy language statements are the *bool* Statement
that defines the boolean flag identifier and its initial status, and the
*if* Statement that allows certain rules to be executed depending on
the state of the boolean value or values. See the
[**Conditional Policy Statements**](conditional_statements.md#conditional-policy-statements)
section.

## Binary Policy

This is also know as the kernel policy and is the policy file that is
loaded into the kernel and is located at
/etc/selinux/\<SELINUXTYPE\>/policy/policy.\<version\>. Where
*\<SELINUXTYPE\>* is the policy name specified in the SELinux
configuration file /etc/selinux/config and \<version\> is the
SELinux [**policy version**](#policy-versions).

The binary policy can be built from source files supplied by the
Reference Policy or custom built source files.

An example */etc/selinux/config* file is shown below where the
*SELINUXTYPE=targeted* entry identifies the policy name that will be used
to locate and load the active policy:

```
SELINUX=permissive
SELINUXTYPE=targeted
```

From the above example, the actual binary policy file would be located
at */etc/selinux/targeted/policy* and be called *policy.32* (as version 32
is supported by Fedora):

*/etc/selinux/targeted/policy/policy.32*

## Policy Versions

SELinux has a policy database (defined in the libsepol library) that
describes the format of data held within a
[**binary policy**](#binary-policy), however, if any new features are added to
SELinux (generally language extensions) this can result in a change to
the policy database. Whenever the policy database is updated, the policy
version is incremented.

The ***sestatus**(8)* command will show the maximum policy version
supported by the kernel in its output as follows:

```
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      32

```

The following table describes the features added for each policy version and
its corresponding modular policy version. When these features are implemented
there may also be functionality added to the kernel, libselinux and/or libsepol.
If known, these version requirements are also listed.

**Policy: 15 Module: 4**

The base version when SELinux was merged into the kernel.

**Policy: 16**

Added [**Conditional Policy**](#conditional-policy) support (the bool feature).

**Policy: 17**

Added support for IPv6.

**Policy: 18**

Added Netlink support.

**Policy: 19 Module: 5**

Added MLS support, plus the *validatetrans* Statement.

**Policy: 20**

Reduced the size of the access vector table.

**Policy: 21 Module: 6**

Added support for the MLS *range_transition* Statement.

**Policy: 22 Module: 7**

Added *policycap* Statement that allows various kernel options to be
enabled as described in the
[**Policy Configuration Statements**](policy_config_statements.md#policy-configuration-statements)
section.

**Policy: 23 Module: 8**

Added support for the *permissive* statement. This allows a domain to run
in permissive mode while the others are still confined (instead of the all
or nothing set by the *SELINUX* entry in the */etc/selinux/config* file).

**Policy: 24 Module: 9 / 10**

Add support for the *typebounds* statement. This was added to support a
hierarchical relationship between two domains in multi-threaded web servers
as described in
[**A secure web application platform powered by SELinux**](http://sepgsql.googlecode.com/files/LCA20090120-lapp-selinux.pdf).

**Policy: 25 Module: 11**

Add support for file name transition in the *type_transition* rule.
Requires kernel 2.6.39 minimum.

**Policy: 26 Module: 12 / 13**

Add support for a class parameter in the *role_transition* rule and
support for the *attribute_role* and *roleattribute* statements.
These require kernel 2.6.39 minimum.

**Module: 14**

Separate tunables.

**Policy: 27 Module: 15**

Support setting object defaults for the user, role and range components
when computing a new context. Requires kernel 3.5 minimum.

**Policy: 28 Module: 16**

Support setting object defaults for the type component when computing a
new context. Requires kernel 3.5 minimum.

**Policy: 29 Module: 17**

Support attribute names within constraints. This allows attributes as well
as the types to be retrieved from a kernel policy to assist
***audit2allow**(8)* etc. to determine what attribute needs to be updated.
Note that the attribute does not determine the constraint outcome, it is
still the list of types associated to the constraint.
Requires kernel 3.14 minimum.

**Policy: 30 Module: 18**

For the *selinux* target platform adds new *xperm* rules as explained in the
[**Extended Access Vector Rules**](xperm_rules.md#extended-access-vector-rules)
section. This is to support ioctl allowlists as explained in the
[***ioctl* Operation Rules**](xperm_rules.md#ioctl-operation-rules) section.
Requires kernel 4.3 minimum.
For modular policy support requires libsepol 2.7 minimum.

**Policy: 30**

For the '*xen*' target platform support the *devicetreecon* statement and
also expand the existing I/O memory range to 64 bits as explained in the
[**Xen Statements**](xen_statements.md#xen-statements) section.

**Policy: 31 Module: 19**

Add InfiniBand (IB) partition key (Pkey) and IB end port object labeling
as explained in the
[**InfiniBand Labeling Statements**](infiniband_statements.md#infiniband-labeling-statements)
section. Requires kernel 4.13 minimum.

**Policy: 32 Module: 20**

Specify *glblub* as a *default_range* default and the computed transition
will be the intersection of the MLS range of the two contexts.
See the [**default_range**](default_rules.md#default_range) for details.
Requires kernel 5.5 minimum.

**Policy: 33**

Implement a more space-efficient form of storing filename transition rules in
the binary policy (also decreases policy load time). Requires kernel 5.8
minimum with libsepol version 3.2 minimum.

<!-- %CUTHERE% -->

---
**[[ PREV ]](mls_mcs.md)** **[[ TOP ]](#)** **[[ NEXT ]](modes.md)**
