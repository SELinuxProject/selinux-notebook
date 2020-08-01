# Security Enhancements for Android

## Introduction

This section gives an overview of the enhancements made to Android to
add SELinux services to Security Enhancements for Android™ (SE for
Android).

The main objective is to provide a reference for the tools, commands, policy
building tools and file formats for the SELinux components of Android based on
AOSP master as of May '20). The AOSP git repository can be found at
[**https://android.googlesource.com**](https://android.googlesource.com/)

**Note:** Check the AOSP tree for any changes as there has been many updates
to how SELinux is configured/built over the years.

### Useful Links

The following link describes how to validate SELinux in Android:
<https://source.android.com/security/selinux/>
and "**Security Enhanced (SE) Android: Bringing Flexible MAC to Android**"
available at
<http://www.cs.columbia.edu/~lierranli/coms6998-7Spring2014/papers/SEAndroid-NDSS2013.pdf>
being a recommended read.

The white paper
"[An Overview of Samsung KNOX](https://images.samsung.com/is/content/samsung/p5/global/business/mobile/SamsungKnoxSecuritySolution.pdf)"
also gives an overview of how SELinux / Android are being integrated with
other security services (such as secure boot and integrity measurement)
to help provide a more secure mobile platform.

### Document Sections

The sections that follow cover:

1.  Overview of Android package additions and updates to support MAC
2.  Android *libselinux* additional functions
3.  Additional kernel LSM / SELinux support
4.  Android Classes & Permissions
5.  SELinux commands and methods
7.  Policy construction and build
8.  Logging and auditing
9.  Configuration file formats


## SE for Android Project Updates

This gives a high level view of the new and updated projects to support
SE for Android services and covers AOSP with any additional SEAndroid
functions noted. These are not a complete set of updates, but give some
idea of the scope.

### ***external/selinux/libselinux***

Provides the SELinux userspace function library that is installed on the
device. It has additional functions to support Android as summarised in
*external/selinux/README.android*. It is build from a merged upstream version
(<https://github.com/SELinuxProject/selinux>) with Android specific additions
such as:

***selinux_android_setcontext()***
-   Sets the correct domain context when launching applications using
    ***setcon**(3)*. Information contained in the *seapp_contexts* file
    is used to compute the correct context.
-   It is called by *frameworks/base/core/jni/com_android_internal_os_Zygote.cpp*
    when forking a new process and the *system/core/run-as/run-as.cpp* utility
    for app debugging.

***selinux_android_restorecon()***
-   Sets the correct context on application directory / files using
    ***setfilecon**(3)*. Information contained in the *seapp_contexts*
    file is used to compute the correct context.
-   The function is used in many places, such as *system/core/init/selinux.cpp*
    and *system/core/init/ueventd.cpp* to label devices.
-   *frameworks/native/cmds/installd/installdNativeService.cpp* when installing
    a new app.
-   *frameworks/base/core/jni/android_os_SELinux.cpp* for the Java
    *native_restorecon* method.

***selinux_android_restorecon_pkgdir()***
-   Used by *frameworks/native/cmds/installd/InstalldNativeService.cpp* for the
    package installer.

***selinux_android_load_policy()***
***selinux_android_load_policy_from_fd()***
-   Used by *system/core/init/selinux.cpp* to initialise SELinux policy, the
    following note has been extracted:
```
// IMPLEMENTATION NOTE: Split policy consists of three CIL files:
// * platform -- policy needed due to logic contained in the system image,
// * non-platform -- policy needed due to logic contained in the vendor image,
// * mapping -- mapping policy which helps preserve forward-compatibility of
//   non-platform policy with newer versions of platform policy.
//
// secilc is invoked to compile the above three policy files into a single
// monolithic policy file. This file is then loaded into the kernel.
```

There is a labeling service for ***selabel_lookup**(3)* to query the Android
*property_contexts* and *service_contexts* files. See
*frameworks/native/cmds/servicemanager/Access.cpp* for an example.

Various Android services will also call (not a complete list):
-   ***selinux_status_updated**(3)*, ***is_selinux_enabled**(3)*, to
    check whether anything changed within the SELinux environment (e.g.
    updated configuration files).
-   ***selinux_check_access**(3)* to check if the source context has
    access permission for the class on the target context.
-   ***selinux_label_open**(3)*, ***selabel_lookup**(3)*,
    ***selinux_android_file_context_handle***, ***lgetfilecon**(3)*,
    ***selinux_android_prop_context_handle***, ***setfilecon**(3)*,
    ***setfscreatecon**(3)* to manage file labeling.
-   ***selabel_lookup_best_match*** called via *system/core/init/selabel.cpp*
    by *system/core/init/devices.cpp* when *ueventd* creates a device node as
    it may also create one or more symlinks (for block and PCI devices).
    Therefore a "best match" look-up for a device node is based on its
    real path, plus any links that may have been created.

### ***external/selinux/libsepol***

Provides the policy userspace library for building policy on the host
and is not available on the device. There are no specific updates to
support Android except an *Android.bp* file.

### ***external/selinux/checkpolicy***

Provides the policy build tool. Added support for MacOS X. Not available
on the device as policy rebuilds are done in the development environment.
There are no specific updates to support Android except an *Android.bp* file.


### ***bootable/recovery***

Changes to manage file labeling on recovery using functions such as
***selinux_android_file_context_handle()**, ***selabel_lookup**(3)* and
***setfscreatecon**(3)*.

### ***build***

Changes to build SE for Android and manage file labeling on images and
OTA (over the air) target files.

### ***frameworks/base***

JNI - Add SELinux support functions such as *isSELinuxEnabled* and
*setFSCreateCon*.

SELinux Java class and method definitions.

Checking Zygote connection contexts.

Managing file permissions for the package manager and wallpaper
services.

### ***system/core***

SELinux support services for toolbox/toybox (e.g. *load_policy*, *runcon*).

SELinux support for system initialisation (e.g. *init*, *init.rc*).

SELinux support for auditing avc's (*auditd*).

### ***system/sepolicy***

This area contains information required to build the SELinux kernel policy
and its supporting files. Android splits the policy into sections:
-   ***private*** - This is policy specifically for the core components of
    Android that looks much like the reference policy, that has the policy
    modules (*\*.te* files), class / permission files etc..
-   ***vendor*** - This is vendor specific policy.
-   ***public*** - This is public specific policy.

The policy is built and installed on the target device along
with its supporting configuration files.

The policy files are discussed in the
[**SELinux Policy Files**](#selinux-policy-files) section and support tools in
the [**Policy Build Tools**](#policy-build-tools) section.

The Android specific object classes are described in the
[**Android Classes & Permissions**](#android-classes-permissions)
section.

### ***kernel***

All Android kernels support the Linux Security Module (LSM) and SELinux
services, however they are based on various versions, therefore the latest
SELinux enhancements may not always be present. The
[**Kernel LSM / SELinux Support**](#kernel-lsm-selinux-support) section
describes the Andriod kernel changes and the
[**Linux Security Module and SELinux**](lsm_selinux.md#linux-security-module-and-selinux)
section describes the core SELinux services in the kernel.

### ***device***

Build information for each device that includes device specific policy as
discussed in the [**The SELinux Policy**](#the-selinux-policy) and
[**Managing Device Policy Files**](#managing-device-policy-files) sections.


## Kernel LSM / SELinux Support

The paper "Security Enhanced (SE) Android: Bringing Flexible MAC to
Android" available at
<http://www.internetsociety.org/sites/default/files/02_4.pdf> gives a
good review of what did and didn't change in the kernel to support
Android. The only major change was to support the Binder IPC service
that consists of the following:

1.  LSM hooks in the binder code (*drivers/android/binder.c*)
    and (*include/linux/security.h*)
2.  Hooks in the LSM security module (*security/security.c*).
3.  SELinux support for the binder object class and permissions
    (*security/selinux/include/classmap.h*) that are shown in the
    [**Android Classes & Permissions**](#android-classes-permissions)
    section. Support for these permission checks are added to
    *security/selinux/hooks.c*.

Kernel 5.0+ supports Dynamically Allocated Binder Devices, therefore
configuring specific devices (e.g. **CONFIG_ANDROID_BINDER_DEVICES="binder"**)
is no longer required (use ***CONFIG_ANDROID_BINDERFS=y*** instead).


## Android Classes & Permissions

Additional classes have been added to Android and are listed in the
following tables with descriptions of their permissions. The policy
files *system/sepolicy/private/security_classes* and
*system/sepolicy/private/access_vectors* contain the complete list with
descriptions available at:
[**Appendix A - Object Classes and Permissions**](object_classes_permissions.md#appendix-a---object-classes-and-permissions).
However, note that while the *security_classes* file contains many entries,
not all are required for Android.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Class</strong></td>
<td><em><strong>binder</strong></em> - Manage the Binder IPC service.</td>
</tr>
<tr style="background-color:#F2F2F2;">
<td><strong>Permission</strong></td>
<td><strong>Description</strong> (4 unique permissions)</td>
</tr>
<tr>
<td>call</td>
<td>Perform a binder IPC to a given target process (can A call B?).</td>
</tr>
<tr>
<td>impersonate</td>
<td>Perform a binder IPC on behalf of another process (can A impersonate B on an IPC).</td>
</tr>
<tr>
<td>set_context_mgr</td>
<td>Register self as the Binder Context Manager aka <em>servicemanager</em> (global name service). Can A set the context manager to B, where normally A == B.</td>
</tr>
<tr>
<td>transfer</td>
<td>Transfer a binder reference to another process (can A transfer a binder reference to B?).</td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Class</strong></td>
<td><em><strong>property_service</strong></em> - This is a userspace object to manage the Android Property Service in <em>system/core/init/property_service.cpp</em></td>
</tr>
<tr style="background-color:#F2F2F2;">
<td><strong>Permission</strong></td>
<td><strong>Description</strong> (1 unique permission)</td>
</tr>
<tr>
<td><code>set</code></td>
<td>Set a property.</td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Class</strong></td>
<td><em><strong>service_manager</strong></em> - This is a userspace object to manage the loading of Android services in <em>frameworks/native/cmds/servicemanager/service_manager/Access.cpp</em></td>
</tr>
<tr style="background-color:#F2F2F2;">
<td><strong>Permission</strong></td>
<td><strong>Description</strong> (3 unique permissions)</td>
</tr>
<tr>
<td>add</td>
<td>Add a service.</td>
</tr>
<tr>
<td>find</td>
<td>Find a service.</td>
</tr>
<tr>
<td>list</td>
<td>List services.</td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Class</strong></td>
<td><em><strong>hwservice_manager</strong></em> - This is a userspace object to manage the loading of Android services in <em>system/hwservicemanager/AccessControl.cpp</em></td>
</tr>
<tr style="background-color:#F2F2F2;">
<td><strong>Permission</strong></td>
<td><strong>Description</strong> (3 unique permissions)</td>
</tr>
<tr>
<td>add</td>
<td>Add a service.</td>
</tr>
<tr>
<td>find</td>
<td>Find a service.</td>
</tr>
<tr>
<td>list</td>
<td>List services.</td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Class</strong></td>
<td><em><strong>keystore_key</strong></em> - This is a userspace object to manage the Android keystores. See <em>system/security/keystore/key_store_service.cpp</em></td>
</tr>
<tr style="background-color:#F2F2F2;">
<td><strong>Permission</strong></td>
<td><strong>Description</strong> (19 unique permissions)</td>
</tr>
<tr>
<td>get_state</td>
<td>check if keystore okay.</td>
</tr>
<tr>
<td>get</td>
<td>Get key.</td>
</tr>
<tr>
<td>insert</td>
<td>Insert / update key.</td>
</tr>
<tr>
<td>delete</td>
<td>Delete key.</td>
</tr>
<tr>
<td>exist</td>
<td>Check if key exists.</td>
</tr>
<tr>
<td>list</td>
<td>Search for matching string.</td>
</tr>
<tr>
<td>reset</td>
<td>Reset keystore for primary user.</td>
</tr>
<tr>
<td>password</td>
<td>Generate new keystore password for primary user.</td>
</tr>
<tr>
<td>lock</td>
<td>Lock keystore.</td>
</tr>
<tr>
<td>unlock</td>
<td>Unlock keystore.</td>
</tr>
<tr>
<td>is_empty</td>
<td>Check if keystore empty.</td>
</tr>
<tr>
<td>sign</td>
<td>Sign data.</td>
</tr>
<tr>
<td>verify</td>
<td>Verify data.</td>
</tr>
<tr>
<td>grant</td>
<td>Add or remove access.</td>
</tr>
<tr>
<td>duplicate</td>
<td>Duplicate the key.</td>
</tr>
<tr>
<td>clear_uid</td>
<td>Clear keys for this <em>uid</em>.</td>
</tr>
<tr>
<td>add_auth</td>
<td>Add hardware authentication token.</td>
</tr>
<tr>
<td>user_changed</td>
<td>Add/Remove <em>uid</em>.</td>
</tr>
<tr>
<td>gen_unique_id</td>
<td>Generate new keystore password for this <em>uid</em>.</td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Class</strong></td>
<td><em><strong>drmservice</strong></em> - This is a userspace object to allow finer access control of the Digital Rights Management services. See <em>frameworks/av/drm/drmserver/DrmManagerService.cpp</em></td>
<td></td>
</tr>
<tr style="background-color:#F2F2F2;">
<td><strong>Permission</strong></td>
<td><strong>Description</strong> (8 unique permissions)</td>
</tr>
<tr>
<td>consumeRights</td>
<td>Consume rights for content.</td>
</tr>
<tr>
<td>setPlaybackStatus</td>
<td>Set the playback state.</td>
</tr>
<tr>
<td>openDecryptSession</td>
<td>Open the DRM session for the requested DRM plugin.</td>
</tr>
<tr>
<td>closeDecryptSession</td>
<td>Close DRM session.</td>
</tr>
<tr>
<td>initializeDecryptUnit</td>
<td>Initialise the decrypt resources.</td>
</tr>
<tr>
<td>decrypt</td>
<td>Decrypt data stream.</td>
</tr>
<tr>
<td>finalizeDecryptUnit</td>
<td>Release DRM resources.</td>
</tr>
<tr>
<td>pread</td>
<td>Read the data stream.</td>
</tr>
</tbody>
</table>


## SELinux Commands

A subset of the Linux SELinux commands have been implemented in Android
and are listed in . Some are available as Toolbox or Toybox commands (see
*system/core/shell_and_utilities/README.md*) and can be run via *adb shell*,
for example:

```
adb shell pm list permissions -g
```

### SELinux enabled commands

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td>Command</td>
<td>Comment</td>
</tr>
<tr>
<td>getenforce</td>
<td>Returns the current enforcing mode.</td>
</tr>
<tr>
<td>setenforce</td>
<td><p>Modify the SELinux enforcing mode:</p>
<p>setenforce [enforcing|permissive|1|0]</p></td>
</tr>
<tr>
<td>load_policy</td>
<td><p>Load new policy into kernel:</p>
<p>load_policy policy-file</p></td>
</tr>
<tr>
<td>ls</td>
<td>Supports <em>-Z</em> option to display security context.</td>
</tr>
<tr>
<td>ps</td>
<td>Supports <em>-Z</em> option to display security context.</td>
</tr>
<tr>
<td>restorecon</td>
<td><p>Restore file default security context as defined in the <em>file_contexts</em> or <em>seapp_contexts</em> files. The options are: <em>D</em> - data files, <em>F</em> - Force reset, <em>n</em> - do not change, <em>R</em>/<em>r</em> - Recursive change, v - Show changes.</p>
<p>restorecon [-DFnrRv] pathname</p></td>
</tr>
<tr>
<td>chcon</td>
<td><p>Change security context of file. The options are: <em>h</em> - Change symlinks, <em>R</em> - Recurse into subdirectories, v - Verbose output.</p>
<p>chcon [-hRv] context file...</p></td>
</tr>
<tr>
<td>runcon</td>
<td><p>Run command in specified security context:</p>
<p>runcon context program args...</p></td>
</tr>
<tr>
<td>id</td>
<td>If SELinux is enabled then the security context is automatically displayed.</td>
</tr>
</tbody>
</table>


## SELinux Public Methods

The public methods implemented are equivalent to *libselinux* functions
and shown in the **SELinux class public methods** table below. They have
been taken from *frameworks/base/core/java/android/os/SELinux.java*.

The SELinux class and its methods are not available in the Android SDK,
however if developing SELinux enabled apps within AOSP then Reflection
proguard flags would be used (for example in the
TV package *AboutFragment.java* calls **SELinux.isSELinuxEnabled()**.

<table>
<tbody>
<tr>
<td><p><strong><em>String fileSelabelLookup(String path)</strong></em></p>
<p>Get context associated with path by file_contexts. </p>
<p>Return a string representing the security context or null on failure.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean isSELinuxEnabled()</strong></em></p>
<p>Determine whether SELinux is enabled or disabled. </p>
<p>Return <em>true</em> if SELinux is enabled.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean isSELinuxEnforced()</strong></em></p>
<p>Determine whether SELinux is permissive or enforcing.</p>
<p>Returns <em>true</em> if SELinux is enforcing.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean setFSCreateContext(String context)</strong></em></p>
<p>Sets the security context for newly created file objects.</p>
<p><em>context</em> is the security context to set.</p>
<p>Returns <em>true</em> if the operation succeeded.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean setFileContext(String path, String context)</strong></em></p>
<p>Change the security context of an existing file object.</p>
<p><em>path</em> represents the path of file object to relabel.</p>
<p><em>context</em> is the new security context to set .</p>
<p>Returns <em>true</em> if the operation succeeded.</p></td>
</tr>
<tr>
<td><p><strong><em>String getFileContext(String path)</strong></em></p>
<p>Get the security context of a file object.</p>
<p><em>path</em> the pathname of the file object.</p>
<p>Returns the requested security context or null.</p></td>
</tr>
<tr>
<td><p><strong><em>String getPeerContext(FileDescriptor fd)</strong></em></p>
<p>Get the security context of a peer socket.</p>
<p><em>FileDescriptor</em> is the file descriptor class of the peer socket.</p>
<p>Returns the peer socket security context or null.</p></td>
</tr>
<tr>
<td><p><strong><em>String getContext()</strong></em></p>
<p>Gets the security context of the current process.</p>
<p> Returns the current process security context or null.</p></td>
</tr>
<tr>
<td><p><strong><em>String getPidContext(int pid)</strong></em></p>
<p>Gets the security context of a given process id.</p>
<p><em>pid</em> an <em>int</em> representing the process id to check.</p>
<p>Returns the security context of the given pid or null.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean checkSELinuxAccess(String scon, String tcon, String tclass, String perm)</strong></em></p>
<p>Check permissions between two security contexts.</p>
<p><em>scon</em> is the source or subject security context.</p>
<p><em>tcon</em> is the target or object security context.</p>
<p><em>tclass</em> is the object security class name.</p>
<p><em>perm</em> is the permission name.</p>
<p>Returns true if permission was granted.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean restorecon(String pathname)</strong></em></p>
<p>Restores a file to its default SELinux security context. If the system is not compiled with SELinux, then true is automatically returned. If SELinux is compiled in, but disabled, then true is returned.</p>
<p><em>pathname</em> is the pathname of the file to be relabeled.</p>
<p>Returns true if the relabeling succeeded.</p>
<p><em>exception NullPointerException</em> if the pathname is a null object.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean native_restorecon(String pathname, int flags)</strong></em></p>
<p>Restores a file to its default SELinux security context.</p>
<p>Returns <code>true</code> if the relabeling succeeded.</p>
<p><em>exception NullPointerException</em> if the pathname is a null object.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean restorecon(File file)</strong></em></p>
<p>Restores a file to its default SELinux security context. If the system is not compiled with SELinux, then true is automatically returned. If SELinux is compiled in, but disabled, then true is returned.</p>
<p><em>file</em> is the file object representing the path to be relabeled. </p>
<p>Returns true if the relabeling succeeded.</p>
<p><em>exception NullPointerException</em> if the file is a null object.</p></td>
</tr>
<tr>
<td><p><strong><em>boolean restoreconRecursive(File file)</strong></em></p>
<p>Recursively restores all files under the given path to their default SELinux security context. If the system is not compiled with SELinux, then true is automatically returned. If SELinux is compiled in, but disabled, then true is returned.</p>
<p><em>pathname</em> is the pathname of the file to be relabeled.</p>
<p>Returns a boolean indicating whether the relabeling succeeded.</p></td>
</tr>
</tbody>
</table>


## Android Init Language SELinux Extensions

The Android init process language has been expanded to support SELinux
as shown in the following table. The complete Android *init* language
description is available in the *system/core/init/readme.txt* file.

<table>
<tbody>
<tr>
<td><p>seclabel &lt;securitycontext&gt;</p>
<p><em>service option</em>: Change to security context before exec'ing this service. Primarily for use by services run from the rootfs, e.g. <em>ueventd</em>, <em>adbd</em>. Services on the system partition can instead use policy defined transitions based on their file security context. If not specified and no transition is defined in policy, defaults to the init context.</p></td>
</tr>
<tr>
<td><p>restorecon &lt;path&gt;</p>
<p><em>action command</em>: Restore the file named by <em>&lt;path&gt;</em> to the security context specified in the <em>file_contexts</em> configuration. Not required for directories created by the <em>init.rc</em> as these are automatically labeled correctly by <em>init</em>.</p></td>
</tr>
<tr>
<td><p>restorecon_recursive &lt;path&gt; [ &lt;path&gt; ]</p>
<p><em>action command</em>: Recursively restore the directory tree named by <em>&lt;path&gt;</em> to the security context specified in the <em>file_contexts</em> configuration. Do NOT use this with paths leading to shell-writable or app-writable directories, e.g. <em>/data/local/tmp</em>, <em>/data/data</em> or any prefix thereof.</p></td>
</tr>
<tr>
<td><p>setcon &lt;securitycontext&gt;</p>
<p><em>action command</em>: Set the current process security context to the specified string. This is typically only used from <em>early-init</em> to set the init context before any other process is started (see <em>init.rc</em> example above).</p></td>
</tr>
</tbody>
</table>

Examples of their usage are shown in the following *init.rc* file
segments:

***system/core/rootdir/init.rc***

```
## Daemon processes to be run by init.
##
service ueventd /system/bin/ueventd
    class core
    critical
    seclabel u:r:ueventd:s0
    shutdown critical

# Set SELinux security contexts on upgrade or policy update.
    restorecon --recursive --skip-ce /data
```


## The SELinux Policy

This section covers the SELinux policy, its supporting configuration files
and Android specific configuration files (e.g. seapps_context). These file
formats are detailed in the
[Policy File Formats](#policy-file-formats)
section.

These comments have been extracted from *system/sepolicy/Andoid.mk*, there
are many useful comments in this file regarding its build.

```
# sepolicy is now divided into multiple portions:
# public - policy exported on which non-platform policy developers may write
#   additional policy.  types and attributes are versioned and included in
#   delivered non-platform policy, which is to be combined with platform policy.
# private - platform-only policy required for platform functionality but which
#  is not exported to vendor policy developers and as such may not be assumed
#  to exist.
# vendor - vendor-only policy required for vendor functionality. This policy can
#  reference the public policy but cannot reference the private policy. This
#  policy is for components which are produced from the core/non-vendor tree and
#  placed into a vendor partition.
# mapping - This contains policy statements which map the attributes
#  exposed in the public policy of previous versions to the concrete types used
#  in this policy to ensure that policy targeting attributes from public
#  policy from an older platform version continues to work.

# build process for device:
# 1) convert policies to CIL:
#    - private + public platform policy to CIL
#    - mapping file to CIL (should already be in CIL form)
#    - non-platform public policy to CIL
#    - non-platform public + private policy to CIL
# 2) attributize policy
#    - run script which takes non-platform public and non-platform combined
#      private + public policy and produces attributized and versioned
#      non-platform policy
# 3) combine policy files
#    - combine mapping, platform and non-platform policy.
#    - compile output binary policy file
```

### SELinux Policy Files

The core policy files are contained in *system/sepolicy*, with device
specific policy in *device/&lt;vendor&gt;/&lt;device&gt;/sepolicy*
Once generated, the policy and its supporting configuration files will be
installed on the device as part of the build process.

The following files (along with any vendor and device specific policy) are
used to build the kernel binary policy file.

*private/mls_macro*, *public/global_macros*, *public/ioctl_macros*,
*public/neverallow_macros*, *public/te_marcos*
-   These contain the ***m4**(1)* macros that control and expand the policy files
to build a policy in the kernel policy language to be compiled by
***checkpolicy**(8)*. The
[**Kernel Policy Language**](kernel_policy_language.md#kernel-policy-language)
section defines the kernel policy language.

*private/access_vectors*, *private/security_classes*
-   These have been modified to support the new Android classes and
permissions.

*private/initial_sids*, *private/initial_sids_contexts*
-   Contains the system initialisation (before policy is loaded) and
failsafe (for objects that would not otherwise have a valid label).

*fs_use*,
*genfs_contexts*
*port_contexts*
-   Contains policy context for various devices, see the
    [**Kernel Policy Language**](kernel_policy_language.md#kernel-policy-language)
    section for details.

*private/users*, *private/roles*
-   These define the only user (*u*) and role (*r*) used by the policy.

*private/mls*
-   Contains the constraints to be applied to the defined classes and permissions.

*private/policy_capabilities*
-   Contains the policy capabilities enabled for the kernel policy (see
[**`policycap`**](policy_config_statements.md#policy-configuration-statements)
statement).

\*.te
-   The **.te* files are the policy module definition files. These are
the same format as the standard reference policy and are expanded by the
m4 macros. There is (generally) one *.te* file for each domain/service
defined containing the policy rules. The device/vendor may also produce these.

*file_contexts*
-   Contains default file contexts for setting the SELinux extended file
    attributes (***attr**(1)*). The format of this file is defined in the
    [*file_contexts *](#file_contexts) section. The device/vendor may also
    produce these.

### Android Policy Files

These Android specific files along with any device versions will be used to
determinn whether access is allowed or not based on the security contexts
contained within them.

*seapp_contexts*
-   Contains information to allow domain or data file contexts to be
    computed based on parameters as discussed in the
    [*seapp_contexts*](#seapp_contexts) section.

*property_contexts*
-   Contains default contexts for Android property services as discussed in
    the [*property_contexts*](#property_contexts) section.

*service_contexts*
*hwservice_contexts*
*vndservice_contexts*
-   Contains default contexts for Android services as discussed in the
    [*service_contexts*](#service_contexts) section. The hardware and
    vendor service files share the same format and use
    *selabel_open(SELABEL_CTX_ANDROID_SERVICE ..);*, ***selabel_lookup**(3)*
    for processing files.

*mac_permissions.xml*
-   The Middleware Mandatory Access Control (MMAC) file assigns an `seinfo` tag
    to apps based on their signature and optionally their package name.
    The `seinfo` tag can then be used as a key in the *seapp_contexts* file to
    assign a specific label to all apps with that `seinfo` tag. The configuration
    file is read by *system_server* during start-up. The main code for the
    service is *frameworks/base/services/java/com/android/server/pm/SELinuxMMAC.java*,
    however it does hook into other Android services such as *PackageManagerService.java*.
    Its format is discussed in the [*mac_permissions.xml*](#mac_permissions.xml)
    section.

### Device Specific Policy

Some of this section has been extracted from the
*system/sepolicy/README* that should be checked in case there have
been updates. It describes how files in *system/sepolicy* can be
manipulated during the build process to reflect requirements of
different device vendors whose policy files would be located in
the *device/&lt;vendor&gt;/&lt;board&gt;/sepolicy* directory.

Important Note: Android policy has a number of
[**`neverallow`**](avc_rules.md#neverallow) rules defined in
the core policy to ensure that
[**`allow`**](avc_rules.md#allow) rules are never added
to domains that would weaken security. However developers may need to
customise their device policies, and as a consequence they may fail one
or more of these rules.

#### Managing Device Policy Files

Additional, per device, policy files can be added into the
policy build. These files should have each line including the
final line terminated by a newline character (0x0A).  This
will allow files to be concatenated and processed whenever
the ***m4**(1)* macro processor is called by the build process.
Adding the newline will also make the intermediate text files
easier to read when debugging build failures.  The sets of file,
service and property contexts files will automatically have a
newline inserted between each file as these are common failure
points.

These device policy files can be configured through the use of
the BOARD_VENDOR_SEPOLICY_DIRS variable. This variable should be set
in the BoardConfig.mk file in the device or vendor directories.

BOARD_VENDOR_SEPOLICY_DIRS contains a list of directories to search
for additional policy files. Order matters in this list.
For example, if you have 2 instances of *widget.te* files in the
BOARD_VENDOR_SEPOLICY_DIRS search path, then the first one found (at the
first search dir containing the file) will be concatenated first.
Reviewing *out/target/product/&lt;device&gt;/obj/ETC/sepolicy_intermediates/policy.conf*
will help sort out ordering issues.

Example *BoardConfig.mk* usage from the Tuna device
*device/samsung/tuna/BoardConfig.mk*:

```
BOARD_VENDOR_SEPOLICY_DIRS += device/samsung/tuna/sepolicy
```

Additionally, OEMs can specify BOARD_SEPOLICY_M4DEFS to pass arbitrary m4
definitions during the build. A definition consists of a string in the form
of `macro-name=value`. Spaces must NOT be present. This is useful for building
modular policies, policy generation, conditional file paths, etc. It is
supported in the following file types:
 * All \*.te and SE Linux policy files as passed to checkpolicy
 * file_contexts
 * service_contexts
 * property_contexts
 * keys.conf

Example *BoardConfig.mk* Usage:

```
BOARD_SEPOLICY_M4DEFS += btmodule=foomatic \
                         btdevice=/dev/gps
```

### Policy Build Tools

The kernel policy is compiled using ***checkpolicy**(8)* via the
*system/sepolicy/Android.mk* file. There are also a number of Android
specific tools used to assist in policy build/configuration that are described
as follows (some text taken from *system/sepolicy/tools/README*):

**build_policies.sh** - A tool to build SELinux policy for multiple targets
in parallel. This is useful for quickly testing a new test or neverallow rule
on multiple targets.

Usage:
```
   ./build_policies.sh ~/android/master ~/tmp/build_policies
   ./build_policies.sh ~/android/master ~/tmp/build_policies sailfish-eng walleye-eng
```

**checkfc** - A utility for checking the validity of a file_contexts or a
property_contexts configuration file.  Used as part of the policy
build to validate both files.  Requires the sepolicy file as an
argument in order to check the validity of the security contexts
in the file_contexts or property_contexts file.

Usage1:

```
   checkfc sepolicy file_contexts
   checkfc -p sepolicy property_contexts
```

-   Also used to compare two file_contexts or file_contexts.bin files.
    Displays one of subset, equal, superset, or incomparable.

Usage2:

```
   checkfc -c file_contexts1 file_contexts2
```

Example:

```
   $ checkfc -c out/target/product/shamu/system/etc/general_file_contexts out/target/product/shamu/root/file_contexts.bin
subset
```

**checkseapp** - A utility for merging together the main seapp_contexts
configuration and the device-specific one, and simultaneously
checking the validity of the configurations. Used as part of the
policy build process to merge and validate the configuration.

Usage:

```
    checkseapp -p sepolicy input_seapp_contexts0 [input_seapp_contexts1...] -o seapp_contexts
```

**insertkeys.py** - A helper script for mapping tags in the signature stanzas
of *mac_permissions.xml* to public keys found in pem files (see the
[***mac_permissions.xml***](mac_permissions.xml) file section).
The resulting *mac_permissions.xml* file will also be stripped of
comments and whitespace.

Also uses information contained in various *keys.conf* files that are
described in the [**keys.conf**](#keys.conf) file section.

**post_process_mac_perms** -  A tool to help modify an existing
mac_permissions.xml with additional app certs not already found in that policy.
This becomes useful when a directory containing apps is searched and the certs
from those apps are added to the policy not already explicitly listed.

Usage:

```
    post_process_mac_perms [-h] -s SEINFO -d DIR -f POLICY

      -s SEINFO, --seinfo SEINFO  seinfo tag for each generated stanza
      -d DIR, --dir DIR           Directory to search for apks
      -f POLICY, --file POLICY    mac_permissions.xml policy file
```

**sepolicy-check** - A tool for auditing a sepolicy file for any allow rule
that grants a given permission.

Usage:

```
    sepolicy-check -s <domain> -t <type> -c <class> -p <permission> -P out/target/product/<board>/root/sepolicy
```

**sepolicy-analyze** - A tool for performing various kinds of analysis on a
sepolicy file. During policy build it is used to check for any `permissive`
domains (not allowed) and `neverallow` assertions

**version_policy** - Takes the given public platform policy, a private policy
and a version number to produced a combined "versioned" policy file.


## Logging and Auditing

Android supports auditing of SELinux events via the AOSP logger
service that can be viewed using *logcat*, for example:

```
adb logcat > logcat.log
```

Example SELinux audit events (avc denials) are:

```
/system/bin/init: type=1107 audit(0.0:7): uid=0 auid=4294967295 ses=4294967295 subj=u:r:init:s0 msg='avc: denied { set } for property=vendor.wlan.firmware.version pid=357 uid=1010 gid=1010 scontext=u:r:hal_wifi_default:s0 tcontext=u:object_r:vendor_default_prop:s0 tclass=property_service permissive=0' b/131598173

traced_probes: type=1400 audit(0.0:9): avc: denied { read } for name="format" dev="tracefs" ino=5283 scontext=u:r:traced_probes:s0 tcontext=u:object_r:debugfs_tracing_debug:s0 tclass=file permissive=0

dmesg   : type=1400 audit(0.0:198): avc: denied { syslog_read } for scontext=u:r:shell:s0 tcontext=u:r:kernel:s0 tclass=system permissive=0
```

Note that before the auditing daemon is loaded, messages will be logged
in the kernel buffers that can be read using ***dmesg**(1)*:

```
adb shell dmesg
```


## Policy File Formats

This section details the following Android policy files:

-   *file_contexts*
-   *seapp_contexts*
-   *service_contexts*
-   *property_contexts*
-   *mac_permissions.xml*
-   *keys.conf*

### ***file_contexts***

This file is used to associate default contexts to files for file
systems that support extended file attributes. It is used by the file
labeling commands such as *restorecon*.

The build process supports additional *file_contexts* files allowing
devices to specify their entries as described in the
[**Managing Device Policy Files**](#managing-device-policy-files) section.

Each line within the file consists of the following:

```
pathname_regexp [file_type] security_context
```

Where:

<table>
<tbody>
<tr>
<td>pathname_regexp</td>
<td>An entry that defines the pathname that may be in the form of a regular expression (see the example file_contexts files below).<p><strong>Note: <em>/dev/block</em></strong> devices may have additional keywords: <strong><em>by-name</em></strong> and <strong><em>by-uuid</em></strong><br>These are resolved by
<em>system/core/init/devices.cpp</em> as a block device name/uuid may change based on the detection order etc..</td>
</tr>
<tr>
<td>file_type</td>
<td><p>One of the following optional file_type entries (note if blank means "match all file types"):</p>
<p>'<em>-b</em>' - Block Device         '<em>-c</em>' - Character Device</p>
<p>'<em>-d</em>' - Directory               '<em>-p</em>' - Named Pipe (FIFO)</p>
<p>'<em>-l</em>' - Symbolic Link      '<em>-s</em>' - Socket File</p>
<p>'<em>--</em>' - Ordinary file</p>
<p>This entry equates to the file mode and also the file related object class (e.g. <em>S_IFSOCK</em> = <em>sock_file</em> class).</p></td>
</tr>
<tr>
<td>security_context</td>
<td>This entry can be either:<br>- The security context that will be assigned to the file.<br>- A value of <code>&lt;&lt;none&gt;&gt;</code> that states matching files should not be re-labeled.</td>
</tr>
</tbody>
</table>

Example entries:

```
###########################################
# Root
/                   u:object_r:rootfs:s0

# Data files
/adb_keys           u:object_r:adb_keys_file:s0
/build\.prop        u:object_r:rootfs:s0
/default\.prop      u:object_r:rootfs:s0
/fstab\..*          u:object_r:rootfs:s0
/init\..*           u:object_r:rootfs:s0
/res(/.*)?          u:object_r:rootfs:s0
/selinux_version    u:object_r:rootfs:s0
/ueventd\..*        u:object_r:rootfs:s0
/verity_key         u:object_r:rootfs:s0
...
##########################
# Devices
#
/dev(/.*)?		u:object_r:device:s0
/dev/adf[0-9]*		u:object_r:graphics_device:s0
/dev/adf-interface[0-9]*\.[0-9]*	u:object_r:graphics_device:s0
/dev/adf-overlay-engine[0-9]*\.[0-9]*	u:object_r:graphics_device:s0
/dev/ashmem		u:object_r:ashmem_device:s0
/dev/ashmem(.*)?	u:object_r:ashmem_libcutils_device:s0
...
#############################
# Vendor files from /(product|system/product)/vendor_overlay
#
# NOTE: For additional vendor file contexts for vendor overlay files,
# use device specific file_contexts.
#
/(product|system/product)/vendor_overlay/[0-9]+/.*   u:object_r:vendor_file:s0

```

These are example *device/google/coral-sepolicy/vendor/qcom/sm8150/file_contexts*
entries that has a '***by-name***' entry.

```
# Same process file
/vendor/lib(64)?/hw/gralloc\.msmnile\.so                 u:object_r:same_process_hal_file:s0
/vendor/lib(64)?/hw/vulkan\.msmnile\.so                  u:object_r:same_process_hal_file:s0
/vendor/lib(64)?/hw/gralloc\.sm8150\.so                  u:object_r:same_process_hal_file:s0

/(vendor|system/vendor)/bin/sscrpcd                      u:object_r:sensors_exec:s0

/dev/block/platform/soc/1d84000\.ufshc/by-name/abl_[ab]  u:object_r:custom_ab_block_device:s0
/dev/block/platform/soc/1d84000\.ufshc/by-name/aop_[ab]  u:object_r:custom_ab_block_device:s0
/dev/block/platform/soc/1d84000\.ufshc/by-name/apdp_[ab] u:object_r:dp_block_device:s0
```

The '***by-name***'entry can also exist in *fstab* files as shown in this
example taken from *device/generic/goldfish/fstab.ranchu*:

```
# Android fstab file.
...
/dev/block/pci/pci0000:00/0000:00:06.0/by-name/metadata /metadata ext4 .....
```


### ***seapp_contexts***

The build process supports additional *seapp_contexts* files allowing
devices to specify their entries as described in the
[Device Specific Policy](#device-specific-policy) section.

The following sections will show:

1.  The default *system/sepolicy/private/seapp_contexts* file entries.
2.  A description of the *seapp_contexts* entries and their usage.
3.  A brief description of how a context is computed using either the
    *selinux_android_setcontext* or *selinux_android_ setfilecon*
    function using the *seapp_contexts* file entries.
4.  Examples of computed domain and directory contexts for various apps.

#### Default Entries

The default Android *system/sepolicy/private/seapp_contexts* file contains
the following types of entry:

```
# only the system server can be in system_server domain
neverallow isSystemServer=false domain=system_server
neverallow isSystemServer="" domain=system_server
...
# Ephemeral Apps must run in the ephemeral_app domain
neverallow isEphemeralApp=true domain=((?!ephemeral_app).)*

isSystemServer=true domain=system_server_startup

user=_app seinfo=platform name=com.android.traceur domain=traceur_app type=app_data_file levelFrom=all
user=system seinfo=platform domain=system_app type=system_app_data_file
...
user=_app minTargetSdkVersion=28 fromRunAs=true domain=runas_app levelFrom=all
user=_app fromRunAs=true domain=runas_app levelFrom=user
```

#### Entry Definitions

The following has been extracted from the *system/sepolicy/private/seapp_contexts*
file:

```
# The entries in this file define how security contexts for apps are determined.
# Each entry lists input selectors, used to match the app, and outputs which are
# used to determine the security contexts for matching apps.
#
# Input selectors:
#       isSystemServer (boolean)
#       isEphemeralApp (boolean)
#       isOwner (boolean)
#       user (string)
#       seinfo (string)
#       name (string)
#       path (string)
#       isPrivApp (boolean)
#       minTargetSdkVersion (unsigned integer)
#       fromRunAs (boolean)
#
# All specified input selectors in an entry must match (i.e. logical AND).
# An unspecified string or boolean selector with no default will match any
# value.
# A user, name, or path string selector that ends in * will perform a prefix
# match.
# String matching is case-insensitive.
# See external/selinux/libselinux/src/android/android_platform.c,
# seapp_context_lookup().
#
# isSystemServer=true only matches the system server.
# An unspecified isSystemServer defaults to false.
# isEphemeralApp=true will match apps marked by PackageManager as Ephemeral
# isOwner=true will only match for the owner/primary user.
# user=_app will match any regular app process.
# user=_isolated will match any isolated service process.
# Other values of user are matched against the name associated with the process
# UID.
# seinfo= matches aginst the seinfo tag for the app, determined from
# mac_permissions.xml files.
# The ':' character is reserved and may not be used in seinfo.
# name= matches against the package name of the app.
# path= matches against the directory path when labeling app directories.
# isPrivApp=true will only match for applications preinstalled in
#       /system/priv-app.
# minTargetSdkVersion will match applications with a targetSdkVersion
#       greater than or equal to the specified value. If unspecified,
#       it has a default value of 0.
# fromRunAs=true means the process being labeled is started by run-as. Default
# is false.
#
# Precedence: entries are compared using the following rules, in the order shown
# (see external/selinux/libselinux/src/android/android_platform.c,
# seapp_context_cmp()).
#       (1) isSystemServer=true before isSystemServer=false.
#       (2) Specified isEphemeralApp= before unspecified isEphemeralApp=
#             boolean.
#       (3) Specified isOwner= before unspecified isOwner= boolean.
#       (4) Specified user= string before unspecified user= string;
#             more specific user= string before less specific user= string.
#       (5) Specified seinfo= string before unspecified seinfo= string.
#       (6) Specified name= string before unspecified name= string;
#             more specific name= string before less specific name= string.
#       (7) Specified path= string before unspecified path= string.
#             more specific name= string before less specific name= string.
#       (8) Specified isPrivApp= before unspecified isPrivApp= boolean.
#       (9) Higher value of minTargetSdkVersion= before lower value of
#              minTargetSdkVersion= integer. Note that minTargetSdkVersion=
#              defaults to 0 if unspecified.
#       (10) fromRunAs=true before fromRunAs=false.
# (A fixed selector is more specific than a prefix, i.e. ending in *, and a
# longer prefix is more specific than a shorter prefix.)
# Apps are checked against entries in precedence order until the first match,
# regardless of their order in this file.
#
# Duplicate entries, i.e. with identical input selectors, are not allowed.
#
# Outputs:
#       domain (string)
#       type (string)
#       levelFrom (string; one of none, all, app, or user)
#       level (string)
#
# domain= determines the label to be used for the app process; entries
# without domain= are ignored for this purpose.
# type= specifies the label to be used for the app data directory; entries
# without type= are ignored for this purpose.
# levelFrom and level are used to determine the level (sensitivity + categories)
# for MLS/MCS.
# levelFrom=none omits the level.
# levelFrom=app determines the level from the process UID.
# levelFrom=user determines the level from the user ID.
# levelFrom=all determines the level from both UID and user ID.
#
# levelFrom=user is only supported for _app or _isolated UIDs.
# levelFrom=app or levelFrom=all is only supported for _app UIDs.
# level may be used to specify a fixed level for any UID.
#
# For backwards compatibility levelFromUid=true is equivalent to levelFrom=app
# and levelFromUid=false is equivalent to levelFrom=none.
#
#
# Neverallow Assertions
# Additional compile time assertion checks for the rules in this file can be
# added as well. The assertion
# rules are lines beginning with the keyword neverallow. Full support for PCRE
# regular expressions exists on all input and output selectors. Neverallow
# rules are never output to the built seapp_contexts file. Like all keywords,
# neverallows are case-insensitive. A neverallow is asserted when all key value
# inputs are matched on a key value rule line.
#
```

#### Computing Process Context Examples

The following is an example taken as the system server is loaded:

```
selinux_android_setcontext() parameters:
    uid 1000
    isSystemServer true
    seinfo null
    pkgname null

seapp_contexts lookup parameters:
    uid 1000
    isSystemServer true
    seinfo null
    pkgname null
    path null

Matching seapp_contexts entry:
    isSystemServer=true domain=system_server

Outputs:
    domain system_server
    level s0

Computed context = u:r:system_server:s0
username computed from uid = system

Result using ps -Z command:

LABEL                 USER  PID PPID NAME
u:r:system_server:s0 system 630 329  system_server
```

This is the ’radio’ application that is part of the platform:

```
selinux_android_setcontext() parameters:
    uid 1001
    isSystemServer false
    seinfo platform
    pkgname com.android.phone

seapp_contexts lookup parameters:
    uid 1001 (computes user=radio entry)
    isSystemServer false
    seinfo platform
    pkgname com.android.phone
    path null

Matching seapp_contexts entry:
    user=radio domain=radio type=radio_data_file

Outputs:
    domain radio
    level s0

Computed context = u:r:radio:s0
username computed from uid = radio

Result using ps -Z command:

LABEL        USER  PID PPID NAME
u:r:radio:s0 radio 959 329  com.android.phone
```

This is a third party app *com.example.myapplication*:

```
selinux_android_setcontext() parameters:
    uid 10149
    isSystemServer false
    seinfo default
    pkgname com.example.myapplication

seapp_contexts lookup parameters:
    uid 10149 (computes user=_app entry)
    isSystemServer false
    seinfo default
    pkgname com.example.myapplication
    path null

Matching seapp_contexts entry:
    user=_app domain=untrusted_app type=app_data_file levelFrom=user

Outputs:
    domain untrusted_app
    level s0:c149,c256,c512,c768

Computed context = u:r:untrusted_app:s0:c149,c256,c512,c768
username computed from uid = u0_a149

Result using ps -Z command:
LABEL                                    USER    PID  PPID NAME
u:r:untrusted_app:s0:c149,c256,c512,c768 u0_a149 1138 64   com.example.myapplication
```


### ***property_contexts***

This file holds property service keys and their contexts that are
processes by *system/core/init/property_service.cpp*. This service will also
resolve the special keywords: `prefix string`, `exact bool` etc.

The build process supports additional *property_contexts* files
allowing vendors to specify their entries.

The file format is:

```
property_key security_context type value
```

type = prefix or exact
value = int, double, bool or string


Example entries:

```
##########################
# property service keys
#
#
net.rmnet               u:object_r:net_radio_prop:s0
net.gprs                u:object_r:net_radio_prop:s0
net.ppp                 u:object_r:net_radio_prop:s0
net.qmi                 u:object_r:net_radio_prop:s0
net.lte                 u:object_r:net_radio_prop:s0
...
cache_key.bluetooth.      u:object_r:binder_cache_bluetooth_server_prop:s0 prefix string
cache_key.system_server.  u:object_r:binder_cache_system_server_prop:s0 prefix string
cache_key.telephony.      u:object_r:binder_cache_telephony_server_prop:s0 prefix string
...
ro.com.android.dataroaming        u:object_r:telephony_config_prop:s0 exact bool
ro.com.android.prov_mobiledata    u:object_r:telephony_config_prop:s0 exact bool
ro.radio.noril                    u:object_r:telephony_config_prop:s0 exact string
ro.telephony.call_ring.multiple   u:object_r:telephony_config_prop:s0 exact bool
ro.telephony.default_cdma_sub     u:object_r:telephony_config_prop:s0 exact int
```


### ***service_contexts***

This file holds binder service keys and their contexts that are matched
against binder object names using ***selabel_lookup**(3)*. The returned
context will then be used as the target context as described in the
example below to determine whether the binder service is allowed or
denied (see *frameworks/native/cmds/servicemanager/Access.cpp*).

The build process supports additional *service_contexts* files allowing
devices to specify their entries.

The file format is:

```
service_key security_context
```

Example *service_contexts* Entries:

```
android.hardware.identity.IIdentityCredentialStore/default u:object_r:hal_identity_service:s0
android.hardware.light.ILights/default                     u:object_r:hal_light_service:s0
android.hardware.power.IPower/default                      u:object_r:hal_power_service:s0
android.hardware.rebootescrow.IRebootEscrow/default        u:object_r:hal_rebootescrow_service:s0
android.hardware.vibrator.IVibrator/default                u:object_r:hal_vibrator_service:s0

accessibility                             u:object_r:accessibility_service:s0
account                                   u:object_r:account_service:s0
activity                                  u:object_r:activity_service:s0
activity_task                             u:object_r:activity_task_service:s0
adb                                       u:object_r:adb_service:s0
```

Example *hwservice_contexts* Entries:

```
android.frameworks.automotive.display::IAutomotiveDisplayProxyService u:object_r:fwk_automotive_display_hwservice:s0
android.frameworks.bufferhub::IBufferHub                        u:object_r:fwk_bufferhub_hwservice:s0
android.frameworks.cameraservice.service::ICameraService        u:object_r:fwk_camera_hwservice:s0
android.frameworks.displayservice::IDisplayService              u:object_r:fwk_display_hwservice:s0
android.frameworks.schedulerservice::ISchedulingPolicyService   u:object_r:fwk_scheduler_hwservice:s0
```

Example *vndservice_contexts* Entries:

```
manager                 u:object_r:service_manager_vndservice:s0
*                       u:object_r:default_android_vndservice:s0
```


### ***mac_permissions.xml***

The *mac_permissions.xml* file is used to configure Run/Install-time MMAC
policy and provides x.509 certificate to `seinfo` string mapping so that
Zygote spawns an app in the correct domain. See the
[**Computing Process Context Examples**](#computing-process-context-examples)
section for how this is achieved using information also contained in the
*seapp_contexts* file.

An example *mac_permissions.xml* file:

```
<?xml version="1.0" encoding="utf-8"?>
<policy>
    <signer signature="@VRCORE" >
      <package name="com.google.vr.vrcore" >
        <seinfo value="vrcore" />
      </package>
    </signer>
    <signer signature="@VRCORE_DEV" >
      <package name="com.google.vr.vrcore" >
        <seinfo value="vrcore" />
      </package>
    </signer>
</policy>
```

The **&lt;signer signature=** entry may have the public base16 signing
key present in the string or it may have an entry starting with '@',
where the keyword (e.g. VRCORE_DEV) extracts the key from a *pem* file
as discussed in the [**keys.conf**](#keys.conf) section.
If a base16 key is required, it can be extracted from a package using the
*post_process_mac_perms* utility.

The build process also supports additional *mac_permissions.xml* files
allowing devices to specify their entries as described in the
[**Managing Device Policy Files**](#managing-device-policy-files) section.

#### Policy Rules

The following rules have been extracted from the AOSP *mac_permissions.xml*
file:

1.  A signature is a hex encoded X.509 certificate or a tag defined in
    *keys.conf* and is required for each signer tag. The signature can
    either appear as a set of attached cert child tags or as an attribute.
2.  A signer tag must contain a `seinfo` tag XOR multiple package stanzas.
3.  Each signer/package tag is allowed to contain one `seinfo` tag. This tag
    represents additional info that each app can use in setting a SELinux security
    context on the eventual process as well as the apps data directory.
4.  `seinfo` assignments are made according to the following rules:
-   Stanzas with package name refinements will be checked first.
-   Stanzas w/o package name refinements will be checked second.
-   The "default" `seinfo` label is automatically applied.
5.  valid stanzas can take one of the following forms:

```
     // single cert protecting seinfo
     <signer signature="@PLATFORM" >
       <seinfo value="platform" />
     </signer>

     // multiple certs protecting seinfo (all contained certs must match)
     <signer>
       <cert signature="@PLATFORM1"/>
       <cert signature="@PLATFORM2"/>
       <seinfo value="platform" />
     </signer>

     // single cert protecting explicitly named app
     <signer signature="@PLATFORM" >
       <package name="com.android.foo">
         <seinfo value="bar" />
       </package>
     </signer>

     // multiple certs protecting explicitly named app (all certs must match)
     <signer>
       <cert signature="@PLATFORM1"/>
       <cert signature="@PLATFORM2"/>
       <package name="com.android.foo">
         <seinfo value="bar" />
       </package>
     </signer>
```


### ***keys.conf***

The *keys.conf* file is used by **insertkeys.py** for mapping the
"*@...*" tags in *mac_permissions.xml*, *mmac_types.xml* and
*content_provider.xml* signature entries with public keys found in
*pem* files.

An example *keys.conf* file from *system/sepolicy/private* is as follows:

```
#
# Maps an arbitrary tag [TAGNAME] with the string contents found in
# TARGET_BUILD_VARIANT. Common convention is to start TAGNAME with an @ and
# name it after the base file name of the pem file.
#
# Each tag (section) then allows one to specify any string found in
# TARGET_BUILD_VARIANT. Typcially this is user, eng, and userdebug. Another
# option is to use ALL which will match ANY TARGET_BUILD_VARIANT string.
#

[@PLATFORM]
ALL : $DEFAULT_SYSTEM_DEV_CERTIFICATE/platform.x509.pem

[@MEDIA]
ALL : $DEFAULT_SYSTEM_DEV_CERTIFICATE/media.x509.pem

[@NETWORK_STACK]
ALL : $MAINLINE_SEPOLICY_DEV_CERTIFICATES/networkstack.x509.pem

[@SHARED]
ALL : $DEFAULT_SYSTEM_DEV_CERTIFICATE/shared.x509.pem

# Example of ALL TARGET_BUILD_VARIANTS
[@RELEASE]
ENG       : $DEFAULT_SYSTEM_DEV_CERTIFICATE/testkey.x509.pem
USER      : $DEFAULT_SYSTEM_DEV_CERTIFICATE/testkey.x509.pem
USERDEBUG : $DEFAULT_SYSTEM_DEV_CERTIFICATE/testkey.x509.pem
```



<!-- %CUTHERE% -->

---
**[[ PREV ]](implementing_seaware_apps.md)** **[[ TOP ]](#)** **[[ NEXT ]](object_classes_permissions.md)**
