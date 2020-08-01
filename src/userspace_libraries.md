# SELinux Userspace Libraries

The versions of kernel and SELinux tools and libraries influence the
features available, therefore it is important to establish what level of
functionality is required for the application. The
[**Policy Versions**](types_of_policy.md#policy-versions)
section shows the policy versions and the additional features they support.

Details of the libraries, core SELinux utilities and commands with
source code are available at:

<https://github.com/SELinuxProject/selinux/wiki>

## libselinux Library

*libselinux* contains all the SELinux functions necessary to build
userspace SELinux-aware applications and object managers using 'C',
Python, Ruby and PHP languages.

The library hides the low level functionality of (but not limited to):

-   The SELinux filesystem that interfaces to the SELinux kernel
    security server.
-   The proc filesystem that maintains process state information and
    security contexts - see ***proc**(5)*.
-   Extended attribute services that manage the extended attributes
    associated to files, sockets etc. - see ***attr**(5)*.
-   The SELinux policy and its associated configuration files.

The general category of functions available in *libselinux* are shown below,
with [**Appendix B - `libselinux` API Summary**](libselinux_functions.md#appendix-b---libselinux-api-summary)
giving a complete list of functions.

**Access Vector Cache Services**

Allow access decisions to be cached and audited.

**Boolean Services**

Manage booleans.

**Class and Permission Management**

Class / permission string conversion and mapping.

**Compute Access Decisions**

Determine if access is allowed or denied.

**Compute Labeling**

Compute labels to be applied to new instances of on object.

**Default File Labeling**

Obtain default contexts for file operations.

**File Creation Labeling**

Get and set file creation contexts.

**File Labeling**

Get and set file and file descriptor extended attributes.

**General Context Management**

Check contexts are valid, get and set context components.

**Key Creation Labeling**

Get and set kernel key creation contexts.

**Label Translation Management**

Translate to/from, raw/readable contexts.

**Netlink Services**

Used to detect policy reloads and enforcement changes.

**Process Labeling**

Get and set process contexts.

**SELinux Management Services**

Load policy, set enforcement mode, obtain SELinux configuration information.

**SELinux-aware Application Labeling**

Retrieve default contexts for applications such as database and X-Windows.

**Socket Creation Labeling**

Get and set socket creation contexts.

**User Session Management**

Retrieve default contexts for user sessions.

The *libselinux* functions make use of a number of files within the
SELinux sub-system:

1.  The SELinux configuration file *config* that is described in the
    [*/etc/selinux/config*](global_config_files.md#etcselinuxconfig) section.
2.  The SELinux filesystem interface between userspace and kernel that
    is generally mounted as */selinux* or */sys/fs/selinux* and
    described in the
    [**SELinux Filesystem**](lsm_selinux.md#selinux-filesystem)
    section.
3.  The *proc* filesystem that maintains process state information and
    security contexts - see ***proc**(5)*.
4.  The extended attribute services that manage the extended attributes
    associated to files, sockets etc. - see ***attr**(5)*.
5.  The SELinux kernel binary policy that describes the enforcement
    policy.
6.  A number of *libselinux* functions have their own configuration
    files that in conjunction with the policy, allow additional levels
    of configuration. These are described in the
    [**Policy Configuration Files**](policy_config_files.md#policy-configuration-files)
    section.

There is a static version of the library that is not installed by default:

```
dnf install libselinux-static
```

## libsepol Library

*libsepol* - To build and manipulate the contents of SELinux kernel
binary policy files.

There is a static version of the library that is not installed by default:

```
dnf install libsepol-static
```

This is used by commands such as ***audit2allow**(8)* and ***checkpolicy**(8)*
as they require access to functions that are not available in the dynamic
library (such as sepol_compute_av(), sepol_compute_av_reason() and
sepol_context_to_sid().

## libsemanage Library
*libsemanage* - To manage the policy infrastructure.

<!-- %CUTHERE% -->

---
**[[ PREV ]](lsm_selinux.md)** **[[ TOP ]](#)** **[[ NEXT ]](network_support.md)**
