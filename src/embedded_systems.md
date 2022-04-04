# Embedded Systems

- [References](#references)
- [General Requirements](#general-requirements)
  - [Project Repositories](#project-repositories)
  - [Project Requirements](#project-requirements)
  - [SELinux Libraries and Utilities ](#selinux-libraries-and-utilities)
  - [Labeling Files](#labeling-files)
  - [Loading Policy](#loading-policy)
- [The OpenWrt Project](#the-openwrt-project)
- [The Android Project](#the-android-project)
- [Building A Small Monolithic Reference Policy](#building-a-small-monolithic-reference-policy)
  - [Adding Additional Modules](#adding-additional-modules)
  - [The Clean-up](#the-clean-up)
- [Building A Sample Android Policy](#building-a-sample-android-policy)

This section lists some of the general decisions to be taken when implementing
SELinux on embedded systems, it is by no means complete.

Two embedded SELinux projects are used as examples (OpenWrt and Android) with
the main emphasis on policy development as this is considered the most difficult
area.
The major difference between OpenWrt and Android is that SELinux is not tightly
integrated in OpenWrt, therefore MAC is addressed in policy rather than also
adding additional SELinux-awareness to services as in Andriod[^fn_em_1].

An alternative MAC service to consider is [**Smack**](http://www.schaufler-ca.com/)
(Simplified Mandatory Access Control Kernel) as used in the Samsung
[**Tizen**](https://www.tizen.org/) and
[**Automotive Grade Linux**](https://www.automotivelinux.org/) projects. Smack
can have a smaller, less complex footprint than SELinux.

## References

These papers on embedded systems can be used as references, however they are
old (2007 - 2015):

- **Security Enhanced (SE) Android: Bringing Flexible MAC to Android** from
  <http://www.cs.columbia.edu/~lierranli/coms6998-7Spring2014/papers/SEAndroid-NDSS2013.pdf>
  describes the initial Android changes.
- **Reducing Resource Consumption of SELinux for Embedded Systems with Contributions to Open-Source Ecosystems**
  from <https://www.jstage.jst.go.jp/article/ipsjjip/23/5/23_664/_article>
  describes a scenario where *libselinux* was modified and *libsepol* removed
  for their embedded system (however no links to their final modified code,
  although there are many threads on the <https://lore.kernel.org/selinux/>
  list discussing these changes). It should be noted that these libraries have
  changed since the original article, therefore it should be used as a
  reference for ideas only. They also used a now obsolete policy editor
  [***seedit***](http://seedit.sourceforge.net/) to modify Reference Policies.
- **Using SELinux security enforcement in Linux-based embedded devices** from
  <https://eudl.eu/doi/10.4108/icst.mobilware2008.2927> describes enabling
  SELinux on a Nokia 770 Internet Tablet.
- **Filesystem considerations for embedded devices** from
  <https://events.static.linuxfound.org/sites/events/files/slides/fs-for-embedded-full_0.pdf>
  discusses various embedded filesystems performance and reliability.

## General Requirements

**Note 1** - This section discusses the Reference Policy 'Monolithic' and
'Modular' policy builds, however this can be confusing, so to clarify:

- The Reference Policy builds both 'Monolithic' and 'Modular' policy using
  policy modules defined in a *modules.conf* file.
- The 'Monolithic' build process builds the final policy using
  ***checkpolicy**(8)* and therefore does NOT make use of the
  ***semanage**(8)* services to modify policy during runtime.
- The 'Modular' build process builds the final policy using
  ***semodule**(8)* and therefore CAN make use of the
  ***semanage**(8)* services to modify policy during runtime. This requires
  additional resources as it makes use of the 'policy store[^fn_em_2]' as
  described in the [**SELinux Configuration Files - The Policy Store**](configuration_files.md#the-policy-store)
  and [**Policy Store Configuration Files**](policy_store_config_files.md#policy-store-configuration-files)
  sections.
  To be clear, it is possible to build a 'Modular' policy on the host system,
  then install the resulting
  [**Policy Configuration Files**](policy_config_files.md#policy-configuration-files)
  onto the target system (i.e. no 'policy store' on the target system).
- Also note that the Reference Policy 'Monolithic' and 'Modular' builds do not
  build the exact same list of policy configuration files.

**Note 2** - If the requirement is to build the policy in CIL, it is possible
to emulate the above by:

- Building policy using ***secilc**(8)* will build a 'Monolithic' policy.
- Building policy using ***semodule**(8)* will build a 'Modular' policy.
  This can then make use of the ***semanage**(8)* services to modify policy
  during runtime as it makes use of the 'policy store[^fn_em_3]'.
- A useful feature of CIL is that statements can be defined to generate the
  ***file_contexts**(5)* entries in a consistent manner.

**Note 3** - Is there a requirement to build/rebuild policy on the target, if
so does it also need to be managed during runtime:

- If build/rebuild policy on the target with NO semanage support, then only
  ***checkpolicy**(8)* or ***secilc**(8)* will be required on target.
- If building on the target with runtime changes then ***semodule**(8)* and
  ***semanage**(8)* are required.
- If no requirement to build policy on the target, then these are not needed.

**Note 4** - Do any of the target filesystems support extended attributes
(***xattr**(7)*), if so then ***restorecon**(8)* or ***setfiles**(8)*
may be required on the target to label files (see the
[**Labeling Files**](#labeling-files) section).

### Project Repositories

The current SELinux userspace source can be obtained from
<https://github.com/SELinuxProject/selinux> and the current stable releases
from <https://github.com/SELinuxProject/selinux/releases>.

The current Reference Policy source can be obtained from
<https://github.com/SELinuxProject/refpolicy> and the current stable releases
from <https://github.com/SELinuxProject/refpolicy/releases>.

The current SETools (***apol**(1)* etc.) source can be obtained from
<https://github.com/SELinuxProject/setools> and the current stable releases
from <https://github.com/SELinuxProject/setools/releases>.

### Project Requirements

The project requirements will determine the following:

- Kernel Version
  - The kernel version will determine the maximum policy version supported. The
    [**Policy Versions**](types_of_policy.md#policy-versions) section details
    the policy versions, their supported features and SELinux library
    requirements.
- Support ***xattr**(7)* Filesystems
  - If extended attribute filesystems are used then depending on how the target
    is built/loaded it will require ***restorecon**(8)* or ***setfiles**(8)* to
    label these file systems. The policy will also require a
    [*file_contexts*](policy_config_files.md#contextsfilesfile_contexts) that
    is used to provide the labels.
- Multi-User
  - Generally only one user and user role are required, this is the case for
    OpenWrt and Android. If multi-user then PAM services may be required.
- Support Tools
  - These would generally be either [**BusyBox**](https://www.busybox.net/)
    (OpenWrt) or [**Toybox**](http://landley.net/toybox/) (Android). Both of
    these can be built with SELinux enabled utilities.
- Embedded Filesystems
  - The <https://elinux.org/File_Systems#Embedded_Filesystems> and
    [**Filesystem considerations for embedded devices**](https://events.static.linuxfound.org/sites/events/files/slides/fs-for-embedded-full_0.pdf)
    discuss suitable embedded filesystems. If extended attribute
    (***xattr**(7)*) filesystems are required, then a policy will require a
    supporting ***file_contexts**(5)* file and the ***restorecon**(8)* utility
    to label the filesystem.
- SELinux Policy Support:
  - Use the Reference Policy, bespoke CIL policy or bespoke policy using
    ***m4**(1)* macros as used by Android (if starting with a bespoke policy
    then CIL is recommended). Also need to consider:
    - If using the Reference Policy on the target device use either:
      - Monolithic Policy - Use this for minimum resource usage. Also the policy
        is not so easy to update such items as network port and interface
        definitions (may need to push a new version to the device).
      - Modular Policy - Only use this if there is a requirement to modify the
        device policy during runtime.
    - Is MCS/MLS Support is required. The
      [**MLS or MCS Policy**](mls_mcs.md#mls-or-mcs-policy) section gives
      a brief introduction. The OpenWrt Project does not use MLS/MCS policy,
      however Android does use MCS for application sandboxing as shown in the
      [**SE Android - Computing Process Context Examples**](seandroid.md#computing-process-context-examples)
      section.
    - Is Conditional Policy (***booleans**(8)*) support required. This allows
      different policy rules to be enabled/disabled at runtime (Android and
      OpenWrt do not support Booleans).
    - SELinux 'user' and user 'roles' (the subject). Generally there would only
      be one of each of these, for example Android and the OpenWrt CIL policy
      both use user: *u* role: *r*. Note that the *object_r* role is used to
      label objects.

### SELinux Libraries and Utilities

The [**Project Repositories**](#project-repositories) section lists the code
that should be installed on the host build system, not all of these would be
required on the target system.

A possible minimum list of SELinux items required on the target system are:

- *libselinux* - Provides functions to load policy, label processes and files
   etc. A list of functions is in
   [**Appendix B - libselinux API Summary**](libselinux_functions.md#appendix-b---libselinux-api-summary)
- *libsepol* - Provides services to build/load policy.
- ***restorecon**(8)* - Label files.
- The policy plus supporting configuration files.

Whether ***setenforce**(8)* is deployed on the target to set enforcing or
permissive modes will depend on the overall system requirements.

If ***booleans**(8)* are supported on the target, then ***setsebool**(8)* will
be required unless ***semanage**(8)* services are installed.

If the target policy is to be:

- Built on the device, then either ***checkpolicy**(8)* or ***secilc**(8)* will
  be required.
- Managed on the device during runtime, then ***semanage**(8)*,
  ***semodule**(8)* and their supporting services will be required.

Depending on the target memory available it would be possible to modify the
SELinux libraries as there is legacy code that could be removed. Also
(for example) if the userspace avc (***avc_\***(3)*) services in the
*libselinux* library are not required these could be removed. It should be
noted that currently there are no build options to do this.

### Labeling Files

If there is a need to support ***xattr**(7)* filesystems on the target then
these need to be labeled via the ***file_contexts**(5)* file that would be
generated as part of the initial policy build.

For example RAM based filesystems will require labeling before use (as Andriod
does). To achieve this either ***setfiles**(8)* or ***restorecon**(8)* will
need to be run.

These are based on common source code
(<https://github.com/SELinuxProject/selinux/tree/master/policycoreutils/setfiles>)
with the majority of functionality built into *libselinux*, therefore it matters
little which is used, although ***restorecon**(8)* is probably the best choice
as it's smaller and does not support checking files against a different policy.

***setfiles**(8)* will label files recursively on directories and is generally
used by the initial SELinux installation process, whereas ***restorecon**(8)*
must have the *-r* flag set to label files recursively on directories and is
generally used to correct/update files on the running system.

### Loading Policy

When the standard *libselinux* and the ***load_policy**(8)* utility are used to
load policy, it will always be loaded from the
*/etc/selinux/\<SELINUXTYPE\>/policy* directory, where *\<SELINUXTYPE\>* is
the entry from the
[***/etc/selinux/config***](global_config_files.md#etcselinuxconfig) file:

```
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= The <NAME> of the directory where the active policy and its
#              configuration files are located.
SELINUXTYPE=targeted
```

Note setting *SELINUX=disabled* will be deprecated at some stage, in favor of
the existing kernel command line switch *selinux=0*, which allows users to
disable SELinux at system boot. See
<https://github.com/SELinuxProject/selinux-kernel/wiki/DEPRECATE-runtime-disable>
that explains how to achieve this on various Linux distributions.

The standard Linux SELinux policy load sequence is as follows:

- Obtain policy version supported by the kernel.
- Obtain minimum policy version supported by *libsepol*.
- Determine policy load path via */etc/selinux/config* *\<SELINUXTYPE\>* entry.
- Search for a suitable policy to load by comparing the kernel and *libsepol*
  versions using the  */etc/selinux/\<SELINUXTYPE\>/policy/policy.\<ver\>*
  file extension.
- Load and if necessary downgrade the policy. This happens if the policy being
  loaded has a greater version than the kernel supports. Note that if the
  policy was built with *--handle-unknown=deny* (*UNK_PERMS* in *build.conf*)
  and there are unknown classes or permissions, the policy will not be loaded.

The only known deviation from this is the Android project that has its own
specific method as described in the
[**SE for Android** - *external/selinux/libselinux*](seandroid.md#externalselinuxlibselinux)
section. To inspect the code, see the ***selinux_android_load_policy()***
function in
<https://android.googlesource.com/platform/external/selinux/+/refs/heads/master/libselinux/src/android/android_platform.c>.
Basically this maps the policy file to memory, then calls
***security_load_policy**(3)* to load the policy (as Android does not use the
version extension or load policy from the */etc/selinux/\<SELINUXTYPE\>/policy*
directory).

## The OpenWrt Project

The OpenWrt project is a Linux based system targeting embedded devices that can
be built with either the
[**Reference Policy**](https://github.com/SELinuxProject/refpolicy) or a
[**customised CIL policy**](https://git.defensec.nl/?p=selinux-policy.git;a=summary)

The policy to configure is selected from the *menuconfig* options once OpenWrt
is installed:

```
make menuconfig

# Select:
    Global build settings  --->
# Enable SELinux:
      [*] Enable SELinux
            default SELinux type (targeted)  --->
# Select either Reference Policy or customised CIL policy (dssp):
            ( ) targeted
            (X) dssp
```

To build and inspect the CIL policy:

```
git clone https://git.defensec.nl/selinux-policy.git
cd selinux-policy
make policy
```

There should be a binary *policy.\<ver\>* file that can be viewed using tools
such as ***apol**(1)*. The auto-generated ***file_contexts**(5)* file can be
viewed with a text editor.

Note that no *policy.conf* is generated when building CIL policy as
***secilc**(8)* is used. To build a *policy.conf* file for inspection via a
text editor run:

```
checkpolicy -bF -o policy.conf policy.31
```

This work in progress document
<https://github.com/doverride/openwrt-selinux-policy/blob/master/README.md>
contains instructions to assemble OpenWrt from modules applicable to a
particular system and how to build on top of it. Also explained is how to fork
the policy to form a new base for building a customised target policy.

## The Android Project

This is fully discussed in the
[**SE for Android**](seandroid.md#security-enhancements-for-android) section
with a section below that explains
[**Building A Sample Android Policy**](#building-a-sample-android-policy) to
examine its construction.

## Building A Small Monolithic Reference Policy

This section describes how a smaller monolithic Reference Policy can be built
as a starter policy. It supports the minimum of policy modules that can be
defined in a *modules.conf* file, this file is described in the
[**Reference Policy Build Options -** *policy/modules.conf*](#reference-policy-build-options---policymodules.conf)
section.

To start download the Reference Policy source:

```
git clone https://github.com/SELinuxProject/refpolicy.git
cd refpolicy
```

For the initial configuration, either replace the current *build.conf*
file with the sample
[***build.conf***](./notebook-examples/embedded-policy/reference-policy/build.conf)
or edit the current *build.conf* file to the requirements (e.g. MONOLITHIC = y)

Install the source policy in the build directory:

```
make install-src
cd /etc/selinux/<NAME>/src/policy
```

The following mandatory *make conf* step will build the initial
*policy/booleans.conf* and *policy/modules.conf* files.

This process will also build the *policy/modules/kernel/corenetwork.te* and
*corenetwork.if* files. These would be based on the contents of
*corenetwork.te.in* and *corenetwork.if.in* configuration files.

For this build only the *policy/modules.conf* will be replaced with the
sample version.

```
make conf
```

Replace the current *policy/modules.conf* with the sample
[***modules.conf***](./notebook-examples/embedded-policy/reference-policy/modules.conf)
and run:

```
make install
```

The binary policy will now be built in the */etc/selinux/\<NAME\>/policy*
directory. The */etc/selinux/\<NAME\>/src/policy/policy.conf* file contains
the policy language statements used to generate the binary policy.

The *policy.conf* file can be examined with a text editor and the binary
*policy.\<ver\>* file can be viewed using tools such as ***apol**(1)*.

### Adding Additional Modules

Note that if the *modules.conf* file is modified to add additional modules,
*make clean* MUST be run before *make install* or *make load*.

The ease of adding additional modules to the *policy/modules.conf* file depends
on the modules dependencies, for example to add the *ftp* module:

```
# Layer: services
# Module: ftp
#
# File transfer protocol service.
#
ftp = module
```

Now run:

```
make clean
make install
```

to build the policy, this will flag a dependency error:

```
policy/modules/services/ftp.te:488:ERROR 'type ssh_home_t is not within scope'
```

This shows that the *ftp* module relies on the *ssh* module, therefore need to
also add:

```
# Layer: services
# Module: ssh
#
# Secure shell client and server policy.
#
ssh = module
```

Now run:

```
make clean
make install
```

This should build a valid policy. Although note that adding some modules will
lead to a string of dependent modules.

If a suitable module cannot be found in the *policy/modules* directory, then
one can be generated and added to the store. To generate policy modules using
output from the audit log, see ***audit2allow**(1)* (however review any policy
generated). The
[**Reference Policy**](reference_policy.md#the-reference-policy) section
explains the format of these module files.

### The Clean-up

Once a policy is complete it could be cleaned up by removing components
that are not required for example:

- The *file_contexts* generated will have entries that could be deleted.
- Unused boleans could be removed.
- Review Policy Capabilities.
- Remove unused classes and permissions (*policy/flask/security_classes* and
  *policy/flask/access_vectors*).
- There are a number of policy configuration files that can be removed within
  *etc/selinux/refpolicy* (e.g. *etc/selinux/refpolicy/contexts/x_contexts*).

These will probably amount to small fry, but every little helps!!

## Building A Sample Android Policy

A purpose built embedded policy example is the Android policy that is
discussed in the
[**SE for Android**](seandroid.md#security-enhancements-for-android) section.
This policy has become more complex over time, however they did start with a
basic policy that can be explored as described below that does not require
obtaining the full AOSP source and build environment.

[**Android - The SELinux Policy**](seandroid.md#the-selinux-policy) section
descibes how an Android policy is constructed using ***m4**(1)* macros, *\*.te*
files etc., similar to the
[**Reference Policy**](reference_policy.md#the-reference-policy).

To build a sample policy for inspection:

- Obtain a copy of the Android policy built for 4.1, note that only the core
  policy is built here as Android adds device specific policy modules as per
  its build configuration (an example build with a device is shown later).

```
git clone https://android.googlesource.com/platform/external/sepolicy
cd sepolicy
git checkout android-4.1.1_r1
```

- Copy the text below into a
  [*Makefile*](./notebook-examples/embedded-policy/android-policy/android-4/Makefile)
  installed in the *sepolicy* directory.

```
build_policy:
	m4 -D mls_num_sens=1 \
		-D mls_num_cats=1024 \
		-s security_classes \
		initial_sids \
		access_vectors \
		global_macros \
		mls_macros \
		mls \
		policy_capabilities \
		te_macros \
		attributes \
		*.te \
		roles \
		users \
		ocontexts > policy.conf
	checkpolicy -U deny -M -o sepolicy policy.conf
```

- Run *make* to build the policy. There should be a *policy.conf* file that
  can be examined with a text editor and a binary *sepolicy* policy
  file that can be viewed using tools such as ***apol**(1)*.
  Note the order in which the *policy.conf* file is built as it conforms to
  the layout described in the
  [**Kernel Policy Language**](kernel_policy_language.md#policy-source-files)
  section.

Over time the Android policy locked down more and more processes and then
became more complex as policy version control was required when upgrading.
The **Brillo** release was their first IoT release and can be built using the
instructions in the
[*brillo/Makefile*](./notebook-examples/embedded-policy/android-policy/brillo/Makefile)
To build a policy containing a device, follow the instructions in the
[*brillo-device/Makefile*](./notebook-examples/embedded-policy/android-policy/brillo-device/Makefile)
as a device policy must be obtained from the Android repository.

Later Android split policy into private and public segments, they also used
CIL for some policy components as described in the
[**Android - The SELinux Policy**](seandroid.md#the-selinux-policy) section.
The **Android 10** release policy is an example where this split policy is used.
This can be built using the instructions in the
[*android-10/Makefile*](./notebook-examples/embedded-policy/android-policy/android-10/Makefile).

[^fn_em_1]: An example of this integration is setting a new process context as
shown in the Zygote code:
<https://android.googlesource.com/platform/frameworks/base/+/refs/heads/android10-dev/core/jni/com_android_internal_os_Zygote.cpp#1095>.
The [**SE for Android**](seandroid.md#security-enhancements-for-android) section
explains SELinux integration within Android AOSP services.

[^fn_em_2]: The 'policy store' holds policy modules in 'policy package' format
(*\*.pp* files).

[^fn_em_3]: The 'policy store' holds policy modules as compressed CIL text files.

<!-- %CUTHERE% -->

---
**[[ PREV ]](implementing_seaware_apps.md)** **[[ TOP ]](#)** **[[ NEXT ]](seandroid.md)**
