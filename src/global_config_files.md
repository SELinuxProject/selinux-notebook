# Global Configuration Files

Listed in the sections that follow are the common configuration files
used by SELinux and are therefore not policy specific. The two most
important files are:

-   */etc/selinux/config* - This defines the policy to be activated and
    its enforcing mode.
-   */etc/selinux/semanage.conf* - This is used by the SELinux policy
    configuration subsystem for modular or CIL policies.

## */etc/selinux/config*

If this file is missing or corrupt no SELinux policy will be loaded
(i.e. SELinux is disabled). The man page is ***selinux_config**(5)*,
this is because 'config' has already been taken. The config file
controls the state of SELinux using the following parameters:

```
SELINUX=enforcing|permissive|disabled
SELINUXTYPE=policy_name
SETLOCALDEFS=0|1
REQUIREUSERS=0|1
AUTORELABEL=0|1
```

**Where:**

<table>
<tbody>
<tr>
<td>SELINUX</td>
<td><p>This entry can contain one of three values:</p>
<p><strong>enforcing</strong> - SELinux security policy is enforced.</p>
<p><strong>permissive</strong> - SELinux logs warnings (see the <a href="auditing.md#auditing-selinux-events"><em><em>Auditing SELinux Events</em></em></a> section) instead of enforcing the policy (i.e. the action is allowed to proceed).</p>
<p><strong>disabled</strong> - No SELinux policy is loaded.</p>
<p>Note that this configures the global SELinux enforcement mode. It is still possible to have domains running in permissive mode and/or object managers running as disabled, permissive or enforcing, when the global mode is enforcing or permissive.</p></td>
</tr>
<tr>
<td>SELINUXTYPE</td>
<td><p>The <strong>policy_name</strong> is used as the directory name where the active policy and its configuration files will be located. The system will then use this information to locate and load the policy contained within this directory structure. </p>
<p>The policy directory must be located at: </p>
<p>/etc/selinux</p></td>
</tr>
<tr>
<td>SETLOCALDEFS</td>
<td><p><strong>Deprecated</strong> This optional field should be set to 0 (or the entry removed) as the policy store management infrastructure (<strong>semanage</strong>(8) / <strong>semodule</strong>(8)) is now used.</p>
<p>If set to 1, then <strong>init</strong>(8) and <strong>load_policy</strong>(8) will read the local customisation for booleans and users.</p></td>
</tr>
<tr>
<td>REQUIRESEUSERS</td>
<td><p><strong>Deprecated</strong> This optional field can be used to fail a login if there is no matching or default entry in the <em><em><strong>seusers</strong></em></em> file or if the file is missing.</p>
<p>It is checked by the <em>libselinux</em> function <strong>getseuserbyname</strong>(3) that is used by SELinux-aware login applications such as <em><strong>PAM</strong>(8)</em>.</p>
<p>If it is set to 0 or the entry missing:</p>
<p><strong>getseuserbyname</strong>(3) will return the GNU / Linux user name as the SELinux user. </p>
<p>If it is set to 1:</p>
<p><strong>getseuserbyname</strong>(3) will fail.</p></td>
</tr>
<tr>
<td>AUTORELABEL</td>
<td><p>This is an optional field. If set to '<em>0</em>' and there is a file called <em>.autorelabel</em> in the root directory, then on a reboot, the loader will drop to a shell where a root logon is required. An administrator can then manually relabel the file system.</p>
<p>If set to '1' or the parameter name is not used (the default) there is no login for manual relabeling, however should the <em>/.autorelabel</em> file exist, then the file system will be automatically relabeled using <em>fixfiles -F restore</em>. </p>
<p>In both cases the <em>/.autorelabe</em>l file will be removed so relabeling is not done again.</p></td>
</tr>
</tbody>
</table>

**Example */etc/selinux/config* file contents are:**

```
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
# enforcing - SELinux security policy is enforced.
# permissive - SELinux prints warnings instead of enforcing.
# disabled - No SELinux policy is loaded.
SELINUX=permissive
#
# SELINUXTYPE= can take one of these two values:
# targeted - Targeted processes are protected,
# mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

## */etc/selinux/semanage.conf*

The ***semanage.config**(5)* file controls the configuration and actions
of the ***semanage**(8)* and ***semodule**(8)* set of commands using the
following parameters:

```
module-store = method
policy-version = policy_version
expand-check = 0|1
file-mode = mode
save-previous = true|false
save-linked = true|false
disable-genhomedircon = true|false
handle-unknown = allow|deny|reject
bzip-blocksize = 0|1..9
bzip-small true|false
usepasswd = true|false
ignoredirs dir [;dir] …
store-root = <path>
compiler-directory = <path>
remove-hll = true|false
ignore-module-cache = true|false
target-platform = selinux | xen

[verify kernel]
path = <application_to_run>
args = <arguments>
[end]

[verify module]
path = <application_to_run>
args = <arguments>
[end]

[verify linked]
path = <application_to_run>
args = <arguments>
[end]

[setfiles]
path = <application_to_run>
args = <arguments>
[end]

[sefcontext_compile]
path = <application_to_run>
args = <arguments>
[end]

[load_policy]
path = <application_to_run>
args = <arguments>
[end]
```

**Where:**

<table>
<tbody>
<tr>
<td>module-store</td>
<td><p>The method can be one of four options:</p>
<p>directlibsemanage will write directly to a module store. This is the default value.</p>
<p>sourcelibsemanage manipulates a source SELinux policy.</p>
<p>/foo/bar Write via a policy management server, whose named socket is at /foo/bar. The path must begin with a '/'.</p>
<p>foo.com:4242 Establish a TCP connection to a remote policy management server at foo.com. If there is a colon then the remainder is interpreted as a port number; otherwise default to port 4242.</p></td>
</tr>
<tr>
<td>policy-version</td>
<td>This optional entry can contain a policy version number, however it is normally commented out as it then defaults to that supported by the system. </td>
</tr>
<tr>
<td>expand-check</td>
<td><p>This optional entry controls whether hierarchy checking on module expansion is enabled (1) or disabled (0). The default is 0.</p>
<p>It is also required to detect the presence of policy rules that are to be excluded with <em>neverallow</em> rules.</p></td>
</tr>
<tr>
<td>file-mode</td>
<td>This optional entry allows the file permissions to be set on runtime policy files. The format is the same as the mode parameter of the chmod command and defaults to 0644 if not present.</td>
</tr>
<tr>
<td>save-previous</td>
<td>This optional entry controls whether the previous module directory is saved (TRUE) after a successful commit to the policy store. The default is to delete the previous version (FALSE).</td>
</tr>
<tr>
<td>save-linked</td>
<td><p>This optional entry controls whether the previously linked module is saved (TRUE) after a successful commit to the policy store. Note that this option will create a <em>base.linked</em> file in the module policy store.</p>
<p>The default is to delete the previous module (FALSE). </p></td>
</tr>
<tr>
<td>disable-genhomedircon</td>
<td>This optional entry controls whether the embedded genhomedircon function is run when using the <strong>semanage</strong>(8) command. The default is FALSE.</td>
</tr>
<tr>
<td>handle-unknown</td>
<td><p>This optional entry controls the kernel behaviour for handling permissions defined in the kernel but missing from the policy. </p>
<p>The options are: allow the permission, reject by not loading the policy or deny the permission. The default is deny.</p>
<p>Note: to activate any change, the base policy needs to be rebuilt with the <code>semodule -B</code> command.</p></td>
</tr>
<tr>
<td>bzip-blocksize</td>
<td>This optional entry determines whether the modules are compressed or not with bzip. If the entry is <em>0</em>, then no compression will be used (this is required with tools such as <em>sechecker</em> and <em>apol</em>). This can also be set to a value between <em>1</em> and <em>9</em> that will set the block size used for compression (<em>bzip</em> will multiply this by 100,000, so '<em>9</em>' is faster but uses more memory).</td>
</tr>
<tr>
<td>bzip-small</td>
<td>When this optional entry is set to <em>TRUE</em> the memory usage is reduced for compression and decompression (the <em>bzip</em> <em>-s</em> or <em>--small</em> option). If <em>FALSE</em> or no entry present, then does not try to reduce memory requirements.</td>
</tr>
<tr>
<td>usepasswd</td>
<td><p>When this optional entry is set to <em>TRUE</em> <em>semanage</em> will scan all password records for home directories and set up their labels correctly.</p>
<p>If set to <em>FALSE</em> (the default if no entry present), then only the <em>/home</em> directory will be automatically re-labeled. </p></td>
</tr>
<tr>
<td>ignoredirs</td>
<td>With a list of directories to ignore (separated by '<em>;</em>') when setting up users home directories. This is used by some distributions to stop labeling <em>/root</em> as a home directory.</td>
</tr>
<tr>
<td>store-root</td>
<td>Specify an alternative policy store path . The default is "<em>/var/lib/selinux</em>".</td>
</tr>
<tr>
<td>compiler-directory</td>
<td>Specify an alternate directory that will hold the High Level Language (HLL) to CIL compilers. The default is "<em>/usr/libexec/selinux/hll</em>".</td>
</tr>
<tr>
<td>remove-hll</td>
<td>When set <em>TRUE</em>, HLL files will be removed after compilation into CIL (Read <em><strong>semanage.conf</strong>(5)</em> for the consequences of removing these files). Default is <em>FALSE</em>. </td>
</tr>
<tr>
<td>ignore-module-cache</td>
<td>Whether or not to ignore the cache of CIL modules compiled from HLL. The default is <em>false</em>.</td>
</tr>
<tr>
<td>target-platform</td>
<td>Target platform for generated policy. Default is "<em>selinux</em>", the alternate is "<em>xen</em>".</td>
</tr>
<tr>
<td><p>[verify kernel]</p>
<p>..</p>
<p>[end]</p></td>
<td><p>Start an additional set of entries that can be used to validate the kernel policy with an external application during the build process. There may be multiple <em>[verify kernel]</em> entries.</p>
<p>The validation process takes place before the policy is allowed to be inserted into the store with a worked example shown in <a href="policy_validation_example.md#appendix-e---policy-validation-example">Policy Validation Example</a></p></td>
</tr>
<tr>
<td><p>[verify module]</p>
<p>..</p>
<p>[end]</p></td>
<td>Start an additional set of entries that can be used to validate each module by an external application during the build process. There may be multiple <em>[verify module]</em> entries.</td>
</tr>
<tr>
<td><p>[verify linked]</p>
<p>..</p>
<p>[end]</p></td>
<td>Start an additional set of entries that can be used to validate module linking by an external application during the build process. There may be multiple <em>[verify linked]</em> entries.</td>
</tr>
<tr>
<td><p>[load_policy]</p>
<p>..</p>
<p>[end]</p></td>
<td>Replace the default load policy application with this new policy loader. Defaults are either: <em>/sbin/load_policy</em> or <em>/usr/sbin/load_policy</em>.</td>
</tr>
<tr>
<td><p>[setfiles]</p>
<p>..</p>
<p>[end]</p></td>
<td>Replace the default <em><strong>setfiles</strong>(8)</em> application with this new <em>setfiles</em>. Defaults are either: <em>/sbin/setfiles</em> or <em>/usr/sbin/setfiles</em>.</td>
</tr>
<tr>
<td><p>[sefcontexts_compile]</p>
<p>..</p>
<p>[end]</p></td>
<td>Replace the default file context build application with this new builder. Defaults are either: <em>/sbin/</em>sefcontexts_compile or <em>/usr/sbin/</em>sefcontexts_compile.</td>
</tr>
</tbody>
</table>

**Example *semanage.config* file contents are:**

```
# /etc/selinux/semanage.conf
module-store = direct
expand-check = 0

[verify kernel]
path = /usr/local/bin/validate
args = $@
[end]
```

## */etc/selinux/restorecond.conf*
## *restorecond-user.conf*

The *restorecond.conf* file contains a list of files that may be created
by applications with an incorrect security context. The
***restorecond**(8)* daemon will then watch for their creation and
automatically correct their security context to that specified by the
active policy file context configuration files (located in the
*/etc/selinux/&lt;SELINUXTYPE&gt;/contexts/files* directory).

Each line of the file contains the full path of a file or directory.
Entries that start with a tilde (~) will be expanded to watch for files
in users home directories (e.g. *~/public\_html* would cause the daemon to
listen for changes to *public\_html* in all logged on users home
directories).

1.  It is possible to run *restorecond* in a user session using
    the *-u* option (see ***restorecond**(8)*). This requires a
    *restorecond-user.conf* file to be installed as shown in the examples below.
2.  The files names and location can be changed if *restorecond* is run
    with the *-f* option.

**Example *restorecond.conf* file contents are:**

```
/etc/services
/etc/resolv.conf
/etc/samba/secrets.tdb
/etc/mtab
/var/run/utmp
/var/log/wtmp
```

**Example *restorecond-user.conf* file contents are:**

```
# This entry expands to listen for all files created for all
# logged in users within their home directories:
~/*
~/public_html/*
```

## */etc/selinux/newrole_pam.conf*

The optional *newrole\_pam.conf* file is used by ***newrole**(1)* and
maps commands to ***PAM**(8)* service names.

## */etc/sestatus.conf*

The ***sestatus.conf**(5)* file is used by the ***sestatus**(8)* command to
list files and processes whose security context should be displayed when
the -v flag is used (sestatus -v).

**The file has the following parameters:**

```
[files]
List of files to display context

[process]
List of processes to display context
```

**Example *sestatus.conf* file contents are:**

```
[files]
/etc/passwd
/etc/shadow
/bin/bash
/bin/login
/bin/sh
/sbin/agetty
/sbin/init
/sbin/mingetty
/usr/sbin/sshd
/lib/libc.so.6
/lib/ld-linux.so.2
/lib/ld.so.1

[process]
/sbin/mingetty
/sbin/agetty
/usr/sbin/sshd
```

## */etc/security/sepermit.conf*

The ***sepermit.conf**(5)* file is used by the *pam_sepermit.so* module
to allow or deny a user login depending on whether SELinux is enforcing
the policy or not. An example use of this facility is the Red Hat kiosk
policy where a terminal can be set up with a guest user that does not
require a password, but can only log in if SELinux is in enforcing mode.

The entry is added to the appropriate */etc/pam.d* configuration file,
with the example shown being the */etc/pam.d/gdm-password* file (the
[**PAM Login Process**](pam_login.md#pam-login-process) section describes
PAM in more detail):

```
auth     [success=done ignore=ignore default=bad] pam_selinux_permit.so
auth        substack      password-auth
....
session     optional      pam_gnome_keyring.so auto_start
session     include       postlogin
```

The usage is described in ***pam_sepermit**(5)*, with the following
example that describes the configuration:

```
# /etc/security/sepermit.conf
#
# Each line contains either:
#        - a user name
#        - a group name, with @group syntax
#        - a SELinux user name, with %seuser syntax
# Each line can contain optional arguments separated by :
# The possible arguments are:
#        - exclusive - only single login session will
#          be allowed for the user and the user's processes
#          will be killed on logout
#
#        - ignore - The module will never return PAM_SUCCESS status
#          for the user.
#
# An example entry for 'kiosk mode':
xguest:exclusive
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](configuration_files.md)** **[[ TOP ]](#)** **[[ NEXT ]](policy_store_config_files.md)**
