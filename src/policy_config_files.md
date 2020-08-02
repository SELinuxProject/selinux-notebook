# Policy Configuration Files

Each file discussed in this section is relative to the policy name as
follows:

```
/etc/selinux/<SELINUXTYPE>
```

All files under this area form the 'running policy' once the
[*/etc/selinux/config*](global_config_files.md#etcselinuxconfig) files
**SELINUXTYPE=policy_name** entry is set to load the policy.

The majority of files located here are installed by the ***semodule**(8)*
and/or ***semanage**(8)* commands. However it is possible to build a
custom monolithic policy that only use the files installed in this
area (i.e. do not use ***semanage**(8)* or ***semodule**(8)*).
For example the simple
[**policy**](./notebook-examples/selinux-policy/kernel/kern-nb-policy.txt)
described in the Notebook examples could run at init 3 (i.e. no X-Windows)
and only require the following configuration files:

-   *./seusers* - For login programs.
-   *./policy/policy.&lt;ver&gt;* - The binary policy loaded into the kernel.
-   *./context/files/file_contexts* - To allow the filesystem to be relabeled.

If the simple policy is to run at init 5, (i.e. with X-Windows) then an
additional two files are required:

-   *./context/dbus_contexts* - To allow the dbus messaging service to run under
    SELinux.
-   *./context/x_contexts* - To allow the X-Windows service to run under SELinux.

## *seusers*

The ***seusers**(5)* file is used by login programs (normally via the
*libselinux* library) and maps GNU / Linux users (as defined in the
*user* / *passwd* files) to SELinux users (defined in the policy). A
typical login sequence would be:

-   Using the GNU / Linux *user_id*, lookup the *seuser_id* from this
    file. If an entry cannot be found, then use the *__default__*
    entry.
-   To determine the remaining context to be used as the security
    context, read the
    [*./contexts/users/[seuser_id]*](#contextsusersseuser_id)
    file. If this file is not present, then:
-   Check for a default context in the
    [*./contexts/default_contexts*](#contextsdefault_contexts)
    file. If no default context is found, then:
-   Read the
    [*./contexts/failsafe_context*](#contextsfailsafe_context) file
    to allow a fail safe context to be set.

Note: The *system_u* user is defined in this file, however there must be
**no** *system_u* Linux user configured on the system.

The format of the *seusers* file is the same as the files described in the
[*active/seusers*](policy_store_config_files.md#activeseusers)
section, where an example ***semanage**(8)* user command is also shown.

**Example *seusers* file contents:**

```
# seusers file for an MLS system. Note that the system_u user
# has access to all security levels and therefore should not be
# configured as a valid Linux user.

root:root:s0-s15:c0.c1023
__default__:user_u:s0-s0
```

**Supporting libselinux API functions are:**

-   ***getseuser**(3)*
-   ***getseuserbyname**(3)*

## *booleans*
## *booleans.local*

**NOTE: These were removed in libselinux 3.0**

Generally these ***booleans**(5)* files are not present unless using older
Reference policies. ***semanage**(8)* is now used to manage booleans via the
Policy Store as described in the
[*active/booleans.local*](policy_store_config_files.md#activebooleans.local)
file section.

For systems that do use these files:

-   ***security_set_boolean_list**(3)* - Writes a *boolean.local* file if
flag *permanent* = '*1*'.
-   ***security_load_booleans**(3)* - Will look for a *booleans* or
*booleans.local* file here unless a specific path is specified.

Both files have the same format and contain one or more boolean names.

**The format is:**

```
boolean_name value
```

**Where:**

<table>
<tbody>
<tr>
<td>boolean_name</td>
<td>The name of the boolean.</td>
</tr>
<tr>
<td>value</td>
<td><p>The default setting for the boolean that can be one of the following:</p>
<p>true | false | 1 | 0</p></td>
</tr>
</tbody>
</table>

Note that if *SETLOCALDEFS* is set in the SELinux
[*/etc/selinux/config*](global_config_files.md#etcselinuxconfig) file, then
***selinux_mkload_policy**(3)* will check for a *booleans.local* file
in the ***selinux_booleans_path**(3)*, and also a *local.users* file
in the ***selinux_users_path**(3)*.

## *booleans.subs_dist*

The *booleans.subs_dist* file (if present) will allow new boolean names
to be allocated to those in the active policy. This file was added
because many older booleans began with 'allow' that made it difficult to
determine what they did. For example the boolean *allow_console_login*
becomes more descriptive as *login_console_enabled*. If the
*booleans.subs_dist* file is present, then either name may be used.
***selinux_booleans_subs_path**(3)* will return the active policy
path to this file and ***selinux_boolean_sub**(3)* will will return
the translated name.

Each line within the substitution file *booleans.subs_dist* is:

```
policy_bool_name new_name
```

**Where:**

-   *policy_bool_name* - The policy boolean name.
-   *new_name* - The new boolean name.

**Example:**

```
# ./booleans.subs_dist
allow_auditadm_exec_content auditadm_exec_content
allow_console_login         login_console_enabled
allow_cvs_read_shadow       cvs_read_shadow
allow_daemons_dump_core     daemons_dump_core
```

When ***security_get_boolean_names**(3)* or ***security_set_boolean**(3)*
is called with a boolean name and the *booleans.subs_dist* file is present,
the name will be looked up and if using the *new_name*, then the
*policy_bool_name* will be used (as that is what is defined in the active policy).

Supporting libselinux API functions are:

-   ***selinux_booleans_subs_path**(3)*
-   ***selinux_booleans_sub**(3)*
-   ***security_get_boolean_names**(3)*
-   ***security_set_boolean**(3)*

## setrans.conf

The ***setrans.conf**(8)* file is used by the ***mcstransd**(8)* daemon
(available in the mcstrans rpm). The daemon enables SELinux-aware
applications to translate the MCS / MLS internal policy levels into user
friendly labels.

There are a number of sample configuration files within the *mcstrans*
package that describe the configuration options in detail that are
located at */usr/share/mcstrans/examples*.

The daemon will not load unless a valid MCS or MLS policy is active.

The translations can be disabled by adding the following line to the file:

```
disable = 1
```

This file will also support the display of information in colour. The
configuration file that controls this is called *secolor.conf* and is
described in the [*secolor.conf*](#secolor.conf) section.

The file format is fully described in ***setrans.conf**(8)*.

**Example file contents:**

```
# UNCLASSIFIED
Domain=NATOEXAMPLE

s0=SystemLow
s15:c0.c1023=SystemHigh
s0-s15:c0.c1023=SystemLow-SystemHigh

Base=Sensitivity Levels
s1=UNCLASSIFIED
s3:c0,c2,c11,c200.c511=RESTRICTED
s4:c0,c2,c11,c200.c511=CONFIDENTIAL
s5:c0,c2,c11,c200.c511=SECRET

s1:c1=NATO UNCLASSIFIED
s3:c1,c200.c511=NATO RESTRICTED
s4:c1,c200.c511=NATO CONFIDENTIAL
s5:c1,c200.c511=NATO SECRET

Include=/etc/selinux/mls/setrans.d/rel.conf
Include=/etc/selinux/mls/setrans.d/eyes-only.conf
Include=/etc/selinux/mls/setrans.d/constraints.conf

# UNCLASSIFIED
```

Supporting libselinux API functions are:
-   ***selinux_translations_path**(3)*
-   ***selinux_raw_to_trans_context**(3)*
-   ***selinux_trans_to_raw_context**(3)*

## *secolor.conf*

The **secolor.conf**(5) file controls the colour to be associated to the
components of a context when information is displayed by an SELinux
colour-aware application (currently none, although there are two
examples in the Notebook source tarball under the *libselinux/examples*
directory).

**The file format is as follows:**

```
color color_name = #color_mask

context_component string fg_color_name bg_color_name
```

**Where:**

<table>
<tbody>
<tr>
<td>color</td>
<td>The color keyword.</td>
</tr>
<tr>
<td>color_name</td>
<td>A descriptive name for the colour (e.g. <em>red</em>).</td>
</tr>
<tr>
<td>color_mask</td>
<td>A colour mask starting with a hash (<em>#</em>) that describes the RGB colours with black being <em>#000000</em> and white being <em>#ffffff</em>.</td>
</tr>
<tr>
<td>context_component</td>
<td>The colour translation supports different colours on the context string components (<em>user</em>, <em>role</em>, <em>type</em> and <em>range</em>). Each component is on a separate line.</td>
</tr>
<tr>
<td>string</td>
<td><p>This is the context_component string that will be matched with the <em>raw</em> context component passed by <em><strong>selinux_raw_context_to_color</strong>(3)</em></p>
<p>A wildcard '<em><strong>*</strong></em>' may be used to match any undefined <em>string</em> for the <em>user</em>, <em>role</em> and <em>type context_component</em> entries only</p>
<p>A wildcard '<em><strong>*</strong></em>' may be used to match any undefined <em>string</em> for the <em>user</em>, <em>role</em> and <em>type context_component</em> entries only.</p></td>
</tr>
<tr>
<td>fg_color_name</td>
<td><p>The <em>color_name</em> string that will be used as the foreground colour.</p>
<p>A <em>color_mask</em> may also be used.</p></td>
</tr>
<tr>
<td>bg_color_name</td>
<td><p>The <em>color_name</em> string that will be used as the background colour.</p>
<p>A <em>color_mask</em> may also be used.</p></td>
</tr>
</tbody>
</table>

**Example file contents:**

```
color black = #000000
color green = #008000
color yellow = #ffff00
color blue = #0000ff
color white = #ffffff
color red = #ff0000
color orange = #ffa500
color tan = #D2B48C
user * = black white
role * = white black
type * = tan orange
range s0-s0:c0.c1023 = black green
range s1-s1:c0.c1023 = white green
range s3-s3:c0.c1023 = black tan
range s5-s5:c0.c1023 = white blue
range s7-s7:c0.c1023 = black red
range s9-s9:c0.c1023 = black orange
range s15:c0.c1023 = black yellow
```

**Supporting libselinux API functions are:**

-   ***selinux_colors_path**(3)*
-   ***selinux_raw_context_to_color**(3)* - this call returns the foreground
    and background colours of the context string as the specified RGB 'colour'
    hex digits as follows:

```
user : role : type : range
#000000 #ffffff #ffffff #000000 #d2b48c #ffa500 #000000 #008000
black white white black tan orange black green
```

## *policy/policy.&lt;ver&gt;*

This is the binary policy file that is loaded into the kernel to enforce
policy and is built by either ***checkpolicy**(8)* or ***semodule**(8)*. Life
is too short to describe the format but the libsepol source could be used as a
reference or for an overview the
"[**SELinux Policy Module Primer**](http://securityblog.org/brindle/2006/07/05/selinux-policy-module-primer/)" notes.

By convention the file name extension is the policy database version
used to build the policy, however is is not mandatory as the true
version is built into the policy file. The different policy versions are
discussed in the
[**Types of SELinux Policy - Policy Versions**](types_of_policy.md#policy-versions)
section.

## *contexts/customizable_types*

The ***customizable_types**(5)* file contains a list of types that will
not be relabeled by the ***setfiles**(8)* or **restorecon**(8) commands.
The commands check this file before relabeling and excludes those in the
list unless the -F flag is used (see the man pages).

**The file format is as follows:**

```
type
```

**Where:**

<table>
<tbody>
<tr>
<td>type</td>
<td>The type defined in the policy that needs to excluded from relabeling. An example is when a file has been purposely relabeled with a different type to allow an application to work.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
mount_loopback_t
public_content_rw_t
public_content_t
swapfile_t
sysadm_untrusted_content_t
sysadm_untrusted_content_tmp_t
```

**Supporting libselinux API functions are:**

-   ***is_context_customizable**(3)*
-   ***selinux_customizable_types_path**(3)*
-   ***selinux_context_path**(3)*

## *contexts/default_contexts*

The ***default_contexts**(5)* file is used by SELinux-aware applications
that need to set a security context for user processes (generally the
login applications) where:

1.  The GNU / Linux user identity should be known by the application.
2.  If a login application, then the SELinux user (seuser), would have
    been determined as described in the [*seusers*](#seusers) file
    section.
3.  The login applications will check the
    [*./contexts/users/[seuser_id]*](#contextsusersseuser_id) file
    first and if no valid entry, will then look in the [seuser_id]
    file for a default context to use.

**The file format is as follows:**

```
role:type[:range] role:type[:range] ...
```

**Where:**

<table>
<tbody>
<tr>
<td>role:type[:range]</td>
<td><p>The file contains one or more lines that consist of role:type[:range] pairs (including the MLS / MCS level or range if applicable).</p>
<p>The entry at the start of a new line corresponds to the partial role:type[:range] context of (generally) the login application.</p>
<p>The other role:type[:range] entries on that line represent an ordered list of valid contexts that may be used to set the users context. </p></td>
</tr>
</tbody>
</table>

**Example file contents:**

```
system_r:crond_t:s0 system_r:system_crond_t:s0
system_r:local_login_t:s0 user_r:user_t:s0
system_r:remote_login_t:s0 user_r:user_t:s0
system_r:sshd_t:s0 user_r:user_t:s0
system_r:sulogin_t:s0 sysadm_r:sysadm_t:s0
system_r:xdm_t:s0 user_r:user_t:s0
```

**Supporting libselinux API functions are:**

Note that the *./contexts/users/[seuser_id]* file is also read by some of
these functions.

-   ***selinux_contexts_path**(3)*
-   ***selinux_default_context_path**(3)*
-   ***get_default_context**(3)*
-   ***get_ordered_context_list**(3)*
-   ***get_ordered_context_list_with_level**(3)*
-   ***get_default_context_with_level**(3)*
-   ***get_default_context_with_role**(3)*
-   ***get_default_context_with_rolelevel**(3)*
-   ***query_user_context**(3)*
-   ***manual_user_enter_context**(3)*

An example use in this Notebook (to get over a small feature) is that
when the initial **basic policy** was built, no default_contexts file
entries were required as only one *role:type* of *unconfined_r:unconfined_t*
had been defined, therefore the login process did not need to decide
anything (as the only user context was *unconfined_u:unconfined_r:unconfined_t*).

However when adding the **loadable module** that used another type
(*ext_gateway_t*) but with the same role and user (e.g.
*unconfined_u:unconfined_r:ext_gateway_t*), then it was found that the
login process would always set the logged in user context to
*unconfined_u:unconfined_r:ext_gateway_t* (i.e. the login application
now had a choice and chose the wrong one, probably because the types
are sorted and 'e' comes before 'u').

The end result was that as soon as enforcing mode was set, the system
got bitter and twisted. To resolve this the *default_contexts* file
entries were set to:

```
unconfined_r:unconfined_t unconfined_r:unconfined_t
```

The login process could now set the context correctly to
*unconfined_r:unconfined_t*. Note that adding the same entry to the
*contexts/users/unconfined_u* configuration file instead could also have
achieved this.

## *contexts/dbus_contexts*

This file is for the dbus messaging service daemon (a form of IPC) that
is used by a number of GNU / Linux applications such as GNOME and KDE
desktops. If SELinux is enabled, then this file needs to exist in order
for these applications to work. The ***dbus-daemon**(1)* man page
details the contents and the Free Desktop web site has detailed
information at:

[**http://dbus.freedesktop.org**](http://dbus.freedesktop.org/)

**Example file contents:**

```
<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
  <selinux>
  </selinux>
</busconfig>
```

**Supporting libselinux API function is:**

-   ***selinux_context_path**(3)*

## *contexts/default_type*

The **default_type**(5) file allows SELinux-aware applications such as
**newrole**(1) to select a default type for a role if one is not supplied.

**The file format is as follows:**

```
role:type
```

**Where:**

<table>
<tbody>
<tr>
<td>role:type</td>
<td>The file contains one or more lines that consist of role:type entries. There should be one line for each role defined within the policy.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
auditadm_r:auditadm_t
secadm_r:secadm_t
sysadm_r:sysadm_t
staff_r:staff_t
unconfined_r:unconfined_t
user_r:user_t
```

**Supporting libselinux API functions are:**

-   ***selinux_default_type_path**(3)*
-   ***get_default_type**(3)*

## *contexts/failsafe_context*

The **failsafe_context**(5) is used when a login process cannot
determine a default context to use. The file contents will then be used
to allow an administrator access to the system.

**The file format is as follows:**

```
role:type[:range]
```

**Where:**

<table>
<tbody>
<tr>
<td>role:type[:range]</td>
<td>A single line that has a valid context to allow an administrator access to the system, including the MLS / MCS level or range if applicable.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
# Taken from the MLS policy.

sysadm_r:sysadm_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*
-   ***selinux_failsafe_context_path**(3)*
-   ***get_default_context**(3)*
-   ***get_default_context_with_role**(3)*
-   ***get_default_context_with_level**(3)*
-   ***get_default_context_with_rolelevel**(3)*
-   ***get_ordered_context_list**(3)*
-   ***get_ordered_context_list_with_level**(3)*

## *contexts/initrc_context*

This is used by the ***run_init**(8)* command to allow system services to
be started in the same security context as init. This file could also be
used by other SELinux-aware applications for the same purpose.

**The file format is as follows:**

```
user:role:type[:range]
```

**Where:**

<table>
<tbody>
<tr>
<td>user:role:type[:range]</td>
<td>The file contains one line that consists of a security context, including the MLS / MCS level or range if applicable.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
# Taken from the MLS policy
# Note that the init process has full access via the range s0-s15:c0.c255.

system_u:system_r:initrc_t:s0-s15:c0.c255
```

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*

## *contexts/lxc_contexts*

This file supports labeling lxc containers within the *libvirt* library
(see libvirt source *src/security/security_selinux.c*).

**The file format is as follows:**

```
process = "security_context"
file = "security_context"
content = "security_context"
```

**Where:**

<table>
<tbody>
<tr>
<td>process</td>
<td>A single <em>process</em> entry that contains the lxc domain security context, including the MLS / MCS level or range if applicable.</td>
</tr>
<tr>
<td>file</td>
<td>A single <em>file</em> entry that contains the lxc file security context, including the MLS / MCS level or range if applicable.</td>
</tr>
<tr>
<td>content</td>
<td>A single <em>content</em> entry that contains the lxc content security context, including the MLS / MCS level or range if applicable.</td>
</tr>
<tr>
<td><p>sandbox_kvm_process</p>
<p>sandbox_lxc_process</p></td>
<td>These entries may be present and contain the security context.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
process = "system_u:system_r:container_t:s0"
content = "system_u:object_r:virt_var_lib_t:s0"
file = "system_u:object_r:container_file_t:s0"
ro_file="system_u:object_r:container_ro_file_t:s0"
sandbox_kvm_process = "system_u:system_r:svirt_qemu_net_t:s0"
sandbox_kvm_process = "system_u:system_r:svirt_qemu_net_t:s0"
sandbox_lxc_process = "system_u:system_r:container_t:s0"
```

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*
-   ***selinux_lxc_context_path**(3)*

## *contexts/netfilter_contexts* - Obsolete

This file was to support the Secmark labeling for Netfilter / iptable rule
matching of network packets - Never been used.

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*
-   ***selinux_netfilter_context_path**(3)*

## *contexts/openrc_contexts*

**To be determined**

**The file format is as follows:**

**Example file contents:**

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*
-   ***selinux_openrc_contexts_path**(3)*

## *contexts/openssh_contexts*

**To be determined**

**The file format is as follows:**

**Example file contents:**

```
privsep_preauth=sshd_net_t
```

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*
-   ***selinux_openssh_contexts_path**(3)*

## *contexts/removable_context*

The **removable_context**(5) file contains a single default label that
should be used for removable devices that are not defined in the
[*contexts/files/media*](#contextsfilesmedia) file.

**The file format is as follows:**

```
user:role:type[:range]
```

**Where:**

<table>
<tbody>
<tr>
<td>user:role:type[:range]</td>
<td>The file contains one line that consists of a security context, including the MLS / MCS level or range if applicable.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
system_u:object_r:removable_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_removable_context_path**(3)*

## *contexts/sepgsql_contexts*

This file contains the default security contexts for SE-PostgreSQL
database objects and is descibed in ***selabel_db**(5)*.

**The file format is as follows:**

```
object_type object_name context
```

**Where:**

<table>
<tbody>
<tr>
<td><em><em>object_type</em></em></td>
<td><em><em>This is the string representation of the object type.</em></em></td>
</tr>
<tr>
<td><em><em>object_name</em></em></td>
<td><p><em><em>These are the object names of the specific database objects. </em></em></p>
<p><em><em>The entry can contain '</em><em>*</em><em>' for wildcard matching or '</em><em>?</em><em>' for substitution. Note that if the '</em><em>*</em><em>' is used, then be aware that the order of entries in the file is important. The '</em><em>*</em><em>' on its own is used to ensure a default fallback context is assigned and should be the last entry in the </em><em>object_type</em><em> block.</em></em></p></td>
</tr>
<tr>
<td><em><em>context</em></em></td>
<td><em><em>The security </em><em>context</em><em> that will be applied to the object. </em></em></td>
</tr>
</tbody>
</table>

**Example file contents:**

```
# object_type  object_name  context
db_database    my_database  system_u:object_r:my_sepgsql_db_t:s0
db_database        *        system_u:object_r:sepgsql_db_t:s0
db_schema         *.*       system_u:object_r:sepgsql_schema_t:s0
```

## *contexts/snapperd_contexts*

**To be determined**

**The file format is as follows:**

**Example file contents:**

```
snapperd_data = system_u:object_r:snapperd_data_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*
-   ***selinux_snapperd_contexts_path**(3)*

## *contexts/securetty_types*

The ***securetty_types**(5)* file is used by the ***newrole**(1)* command
to find the type to use with tty devices when changing roles or levels.

**The file format is as follows:**

```
type
```

**Where:**

<table>
<tbody>
<tr>
<td>type</td>
<td>Zero or more type entries that are defined in the policy for tty devices.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
sysadm_tty_device_t
user_tty_device_t
staff_tty_device_t
```

**Supporting libselinux API functions are:**

-   ***selinux_securetty_types_path**(3)*

## *contexts/systemd_contexts*

This file contains security contexts to be used by tasks run via ***systemd**(8)*.

**The file format is as follows:**

```
service_class = security_context
```

**Where:**

<table>
<tbody>
<tr>
<td>service_class</td>
<td>One or more entries that relate to the <em>systemd</em> service (e.g. runtime, transient).</td>
</tr>
<tr>
<td>security_context</td>
<td>The security context, including the MLS / MCS level or range if applicable of the service to be run.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
runtime=system_u:object_r:systemd_runtime_unit_file_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*
-   ***selinux_systemd_contexts_path**(3)*

## *contexts/userhelper_context*

This file contains the default security context used by the
system-config-* applications when running from root.

**The file format is as follows:**

```
security_context
```

**Where:**

<table>
<tbody>
<tr>
<td>security_context</td>
<td>The file contains one line that consists of a full security context, including the MLS / MCS level or range if applicable.</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
system_u:sysadm_r:sysadm_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_context_path**(3)*

## *contexts/virtual_domain_context*

The ***virtual_domain_context**(5)* file is used by the virtulization
API (*libvirt*) and provides the qemu domain contexts available in the
policy (see libvirt source *src/security/security_selinux.c*). There
may be two entries in this file, with the second entry being an
alternative domain context.

**Example file contents:**

```
system_u:system_r:svirt_t:s0
system_u:system_r:svirt_tcg_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_virtual_domain_context_path**(3)*

## *contexts/virtual_image_context*

The ***virtual_image_context**(5)* file is used by the virtulization API
(*libvirt*) and provides the image contexts that are available in the
policy (see libvirt source *src/security/security_selinux.c*). The
first entry is the image file context and the second entry is the image
content context.

**Example file contents:**

```
system_u:object_r:svirt_image_t:s0
system_u:object_r:virt_content_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_virtual_image_context_path**(3)*

## *contexts/x_contexts*

The ***x_contexts**(5)* file provides the default security contexts for
the X-Windows SELinux security extension. The usage is discussed in the
[SELinux X-Windows Support](x_windows.md#x-windows-selinux-support)section.
The MCS / MLS version of the file has the appropriate level or
range information added.

**A typical entry is as follows:**

```
# object_type object_name  context
selection      PRIMARY	   system_u:object_r:clipboard_xselection_t:s0
```

**Where:**

<table>
<tbody>
<tr>
<td><em><em>object_type</em></em></td>
<td><em><em>These are types of object supported and valid entries</em><em> are: </em><em>client</em><em>, </em><em>property</em><em>, </em><em>poly_property</em><em>, </em><em>extension</em><em>, </em><em>selection</em><em>, </em><em>poly_selection</em><em> and </em><em>events</em><em>.</em></em></td>
</tr>
<tr>
<td><em><em>object_name</em></em></td>
<td><p><em><em>These are the object names of the specific X-server resource such as </em><em>PRIMARY</em><em>, </em><em>CUT_BUFFER0</em><em> etc. They are generally defined in the X-server source code (</em><em>protocol.txt</em><em> and </em><em>BuiltInAtoms </em><em>in the </em><em>dix</em><em> directory of the </em><em>xorg-server</em><em> source package). </em></em></p>
<p><em><em>This can contain '</em><em>*</em><em>' for 'any' or '</em><em>?</em><em>' for 'substitute' (see the </em><em>CUT_BUFFER?</em><em> entry where the '</em><em>?</em><em>' would be substituted for a number between 0 and 7 that represents the number of these buffers).</em></em></p></td>
</tr>
<tr>
<td><em><em>context</em></em></td>
<td><em><em>This is the security context that will be applied to the object. For MLS/MCS systems there would be the additional MLS label.</em></em></td>
</tr>
</tbody>
</table>

**Supporting libselinux API functions are:**

-   ***selinux_x_context_path**(3)*
-   ***selabel_open**(3)*
-   ***selabel_close**(3)*
-   ***selabel_lookup**(3)*
-   ***selabel_stats**(3)*

## *contexts/files/file_contexts*

The ***file_contexts**(5)* file is managed by the ***semodule**(8)* and
***semanage**(8)* commands<a href="#fnp1" class="footnote-ref" id="fnpcf1"><strong><sup>1</sup></strong></a>
as the policy is updated (adding or removing modules or updating the base),
and therefore should not be edited.

The file is used by a number of SELinux-aware commands (***setfiles**(8)*,
***fixfiles**(8)*, ***restorecon**(8)*) to relabel either part or all of the
file system.

Note that users home directory file contexts are not present in this
file as they are managed by the
[*file_contexts.homedirs*](#contextsfilesfile_contexts.homedirs)
file as explained below.

The format of the *file_contexts* file is the same as the files described in the
[*active/file_contexts*](policy_store_config_files.md#activefile_contexts) file
section.

There may also be a *file_contexts.bin* present that is built and used
by ***semanage**(8)*. The format of this file conforms to the Perl
compatible regular expression (PCRE) internal format.

**Supporting libselinux API functions are:**

-   ***selinux_file_context_path**(3)*
-   ***selabel_open**(3)*
-   ***selabel_close**(3)*
-   ***selabel_lookup**(3)*
-   ***selabel_stats**(3)*

## *contexts/files/file_contexts.local*

This file is added by the ***semanage fcontext*** command as described in the
[*active/file_contexts.local*](policy_store_config_files.md#activefile_contexts.local)
file section to allow locally defined files to be labeled correctly. The
***file_contexts**(5)* man page also decribes this file.

**Supporting libselinux API functions are:**

-   ***selinux_file_context_local_path**(3)*

## *contexts/files/file_contexts.homedirs*

This file is managed by the ***semodule**(8)* and ***semanage**(8)* commands
as the policy is updated (adding or removing users and modules or
updating the base), and therefore should not be edited.

It is generated by the ***genhomedircon**(8)* command (in fact by
***semodule -Bn*** that rebuilds the policy) and used to set the correct
contexts on the users home directory and files.

It is fully described in the
[*active/file_contexts.homedirs*](policy_store_config_files.md#activefile_contexts.homedirs)
file section. The ***file_contexts**(5)* man page also decribes this
file.

There may also be a *file_contexts.homedirs.bin* present that is built
and used by ***semanage**(8)*. The format of this file conforms to the
Perl compatible regular expression (PCRE) internal format.

**Supporting libselinux API functions are:**

-   ***selinux_file_context_homedir_path**(3)*
-   ***selinux_homedir_context_path**(3)*

## contexts/files/file_contexts.subs
## contexts/files/file_contexts.subs_dist

These files allow substitution of file names (*.subs* for local use and
*.subs_dist* for GNU / Linux distributions use) for the *libselinux*
function ***selabel_lookup**(3)*. The ***file_contexts**(5)* man page also
decribes this file.

The subs files contain a list of space separated path names such as:

```
/myweb /var/www
/myspool /var/spool/mail
```

Then (for example), when ***selabel_lookup**(3)* is passed a path
*/myweb/index.html* the functions will substitute the */myweb* component
with */var/www*, with the final result being:

```
/var/www/index.html
```

**Supporting libselinux API functions are:**

-   ***selinux_file_context_subs_path**(3)*
-   ***selinux_file_context_subs_dist_path**(3)*
-   ***selabel_lookup**(3)*
-   ***matchpathcon**(3)* (deprecated)
-   ***matchpathcon_index**(3)* (deprecated)

## *contexts/files/media*

The **media**(5)* file is used to map media types to a file context. If
the media_id cannot be found in this file, then the default context in
the [*contexts/removable_context*](#contextsremovable_context)
is used instead.

**The file format is as follows:**

```
media_id file_context
```

**Where:**

<table>
<tbody>
<tr>
<td>media_id</td>
<td>The media identifier (those known are: cdrom, floppy, disk and usb).</td>
</tr>
<tr>
<td>file_context</td>
<td>The context to be used for the device. Note that it does not have the MLS / MCS level).</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
cdrom system_u:object_r:removable_device_t:s0
floppy system_u:object_r:removable_device_t:s0
disk system_u:object_r:fixed_disk_device_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_media_context_path**(3)*

## *contexts/users/[seuser_id]*

These optional files are named after the SELinux user they represent.
Each file has the same format as the
[*contexts/default_contexts*](#contextsdefault_contexts) file and
is used to assign the correct context to the SELinux user (generally
during login). The ***user_contexts**(5)* man page also decribes these
entries.

**Example file contents** - From the 'targeted` *unconfined_u* file:

```
system_r:crond_t:s0		unconfined_r:unconfined_t:s0 unconfined_r:unconfined_cronjob_t:s0
system_r:initrc_t:s0		unconfined_r:unconfined_t:s0
system_r:local_login_t:s0	unconfined_r:unconfined_t:s0
system_r:remote_login_t:s0	unconfined_r:unconfined_t:s0
system_r:rshd_t:s0		unconfined_r:unconfined_t:s0
system_r:sshd_t:s0		unconfined_r:unconfined_t:s0
system_r:cockpit_session_t:s0	unconfined_r:unconfined_t:s0
system_r:sysadm_su_t:s0		unconfined_r:unconfined_t:s0
system_r:unconfined_t:s0	unconfined_r:unconfined_t:s0
system_r:xdm_t:s0		unconfined_r:unconfined_t:s0
system_r:init_t:s0		unconfined_r:unconfined_t:s0
```

**Supporting libselinux API functions are:**

-   ***selinux_user_contexts_path**(3)*
-   ***selinux_users_path**(3)*
-   ***selinux_usersconf_path**(3)*
-   ***get_default_context**(3)*
-   ***get_default_context_with_role**(3)*
-   ***get_default_context_with_level**(3)*
-   ***get_default_context_with_rolelevel**(3)*
-   ***get_ordered_context_list**(3)*
-   ***get_ordered_context_list_with_level**(3)*

## *logins/&lt;linuxuser_id&gt;*

These optional files are used by SELinux-aware login applications such
as PAM (using the *pam_selinux* module) to obtain an SELinux user name
and level based on the GNU / Linux login id and service name. It has
been implemented for SELinux-aware applications such as FreeIPA
(Identity, Policy Audit - see
[http://freeipa.org/page/Main_Page](http://freeipa.org/page/Main_Page)
for details). The ***service_seusers**(5)* man page also decribes these
entries.

The file name is based on the GNU/Linux user that is used at log in time
(e.g. *ipa*).

If ***getseuser**(3)* fails to find an entry, then the *seusers* file is
used to retrieve default information.

**The file format is as follows:**

```
service_name:seuser_id:level
```

**Where:**

<table>
<tbody>
<tr>
<td>service_name</td>
<td>The name of the service.</td>
</tr>
<tr>
<td>seuser_id</td>
<td>The SELinux user name.</td>
</tr>
<tr>
<td>level</td>
<td>The run level</td>
</tr>
</tbody>
</table>

**Example file contents:**

```
# ./logins/ipa example entries
ipa_service:user_u:s0
another_service:unconfined_u:s0
```

**Supporting libselinux API functions are:**

-   ***getseuser**(3)*

## users/local.users

**NOTE: These were removed in libselinux 3.0**

Generally the ***local.users**(5)* file is not present if
***semanage**(8)* is being used to manage users, however if
***semanage*** is not being used then this file may be present (it could
also be present in older Reference or Example policies).

The file would contain local user definitions in the form of *user*
statements as defined in the
[*active/users.local*](policy_store_config_files.md#activeusers.local) section.

Note that if *SETLOCALDEFS* is set in the SELinux
[*/etc/selinux/config*](global_config_files.md#etcselinuxconfig) file, then
***selinux_mkload_policy**(3)* will check for a *booleans.local* file
in the ***selinux_booleans_path**(3)*, and also a *local.users* file
in the ***selinux_users_path**(3)*.

<section class="footnotes">
<ol>
<li id="fnp1"><p>As each module would have its own file_contexts component that is either added or removed from the policies overall /etc/selinux/&lt;SELINUXTYPE&gt;/contexts/ files/file_contexts file.<a href="#fnpcf1" class="footnote-back">↩</a></p></li>
</ol>
</section>

<!-- %CUTHERE% -->

---
**[[ PREV ]](policy_store_config_files.md)** **[[ TOP ]](#)** **[[ NEXT ]](policy_languages.md)**
