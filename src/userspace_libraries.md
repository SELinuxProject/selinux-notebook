# SELinux Userspace Libraries

The versions of kernel and SELinux tools and libraries influence the
features available, therefore it is important to establish what level of
functionality is required for the application. The
[**Policy Versions**](types_of_policy.md#policy-versions)
section shows the policy versions and the additional features they support.

Details of the libraries, core SELinux utilities and commands with
source code are available at:

<https://github.com/SELinuxProject/selinux/wiki>

<br>

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

The general category of functions available in *libselinux* are shown in
**Table 1: libselinux function types**, with
[**Appendix B - `libselinux` API Summary**](libselinux_functions.md#appendix-b---libselinux-api-summary)
giving a complete list of functions.

<table>
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Function Category</strong></td>
<td><strong>Description</strong></td>
</tr>
<tr>
<td>Access Vector Cache Services</td>
<td>Allow access decisions to be cached and audited. </td>
</tr>
<tr>
<td>Boolean Services</td>
<td>Manage booleans.</td>
</tr>
<tr>
<td>Class and Permission Management</td>
<td>Class / permission string conversion and mapping.</td>
</tr>
<tr>
<td>Compute Access Decisions</td>
<td>Determine if access is allowed or denied.</td>
</tr>
<tr>
<td>Compute Labeling</td>
<td>Compute labels to be applied to new instances of on object.</td>
</tr>
<tr>
<td>Default File Labeling</td>
<td>Obtain default contexts for file operations.</td>
</tr>
<tr>
<td>File Creation Labeling </td>
<td>Get and set file creation contexts.</td>
</tr>
<tr>
<td>File Labeling</td>
<td>Get and set file and file descriptor extended attributes.</td>
</tr>
<tr>
<td>General Context Management</td>
<td>Check contexts are valid, get and set context components.</td>
</tr>
<tr>
<td>Key Creation Labeling </td>
<td>Get and set kernel key creation contexts.</td>
</tr>
<tr>
<td>Label Translation Management </td>
<td>Translate to/from, raw/readable contexts.</td>
</tr>
<tr>
<td>Netlink Services</td>
<td>Used to detect policy reloads and enforcement changes.</td>
</tr>
<tr>
<td>Process Labeling </td>
<td>Get and set process contexts.</td>
</tr>
<tr>
<td>SELinux Management Services</td>
<td>Load policy, set enforcement mode, obtain SELinux configuration information.</td>
</tr>
<tr>
<td>SELinux-aware Application Labeling</td>
<td>Retrieve default contexts for applications such as database and X-Windows. </td>
</tr>
<tr>
<td>Socket Creation Labeling </td>
<td>Get and set socket creation contexts.</td>
</tr>
<tr>
<td>User Session Management</td>
<td>Retrieve default contexts for user sessions.</td>
</tr>
</tbody>
</table>

**Table 1: libselinux function types**

<br>

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

`dnf install libselinux-static`

<br>

## libsepol Library

*libsepol* - To build and manipulate the contents of SELinux kernel
binary policy files.

There is a static version of the library that is not installed by default:

`dnf install libsepol-static`

This is used by commands such as ***audit2allow**(8)* and ***checkpolicy**(8)*
as they require access to functions that are not available in the dynamic
library (such as sepol_compute_av(), sepol_compute_av_reason() and
sepol_context_to_sid().

<br>

## libsemanage Library
*libsemanage* - To manage the policy infrastructure.


<br>

<!-- %CUTHERE% -->

<table>
<tbody>
<tr>
<td><p><a href="lsm_selinux.md#linux-security-module-and-selinux" title="Linux Security Module and SELinux"> <strong>Previous</strong></a></p></td>
<td><center>
<p><a href="README.md#the-selinux-notebook" title="The SELinux Notebook"> <strong>Home</strong></a></p>
</center></td>
<td><center>
<p><a href="network_support.md#selinux-networking-support" title="SELinux Networking Support"> <strong>Next</strong></a></p>
</center></td>
</tr>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>
