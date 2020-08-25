# Global Configuration Files

- [*/etc/selinux/config*](#etcselinuxconfig)
- [*/etc/selinux/semanage.conf*](#etcselinuxsemanage.conf)
- [*/etc/selinux/restorecond.conf*](#etcselinuxrestorecond.conf)
- [*restorecond-user.conf*](#restorecond-user.conf)
- [*/etc/selinux/newrole_pam.conf*](#etcselinuxnewrole_pam.conf)
- [*/etc/sestatus.conf*](#etcsestatus.conf)
- [*/etc/security/sepermit.conf*](#etcsecuritysepermit.conf)

Listed in the sections that follow are the common configuration files
used by SELinux and are therefore not policy specific. The two most
important files are:

- */etc/selinux/config* - This defines the policy to be activated and
  its enforcing mode.
- */etc/selinux/semanage.conf* - This is used by the SELinux policy
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

*SELINUX*

This entry can contain one of three values:

- *enforcing* - SELinux security policy is enforced.
- *permissive* - SELinux logs warnings (see the
  [**Auditing SELinux Events**](auditing.md#auditing-selinux-events) section)
  instead of enforcing the policy (i.e. the action is allowed to proceed).
- *disabled* - No SELinux policy is loaded. Note that this configures
  the global SELinux enforcement mode. It is still possible to have domains
  running in permissive mode and/or object managers running as disabled,
  permissive or enforcing, when the global mode is enforcing or permissive.

*SELINUXTYPE*

The *policy_name* is used as the directory name where the active policy
and its configuration files will be located. The system will then use this
information to locate and load the policy contained within this directory
structure. The policy directory must be located at: */etc/selinux*

*SETLOCALDEFS*

**Deprecated** - This optional field should be set to 0 (or the entry removed)
as the policy store management infrastructure (***semanage**(8)* /
***semodule**(8)*) is now used. If set to 1, then ***init**(8)* and
***load_policy**(8)* will read the local customisation for booleans and users.

*REQUIRESEUSERS*

**Deprecated** - This optional field can be used to fail a login if there is
no matching or default entry in the *seusers* file or if the file is missing.
It is checked by the *libselinux* function ***getseuserbyname**(3)* that is
used by SELinux-aware login applications such as ***PAM**(8)*.
If it is set to 0 or the entry missing:

- ***getseuserbyname**(3)* will return the GNU / Linux user name as the
  SELinux user.

If it is set to 1:

- ***getseuserbyname**(3)* will fail.

*AUTORELABEL*

This is an optional field. If set to \'*0*\' and there is a file called
*.autorelabel* in the root directory, then on a reboot, the loader will drop
to a shell where a root logon is required. An administrator can then manually
relabel the file system.
If set to '1' or the parameter name is not used (the default) there is no
login for manual relabeling, however should the */.autorelabel* file exist,
then the file system will be automatically relabeled using *fixfiles -F restore*.
In both cases the */.autorelabe*l file will be removed so relabeling is not
done again.

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

*module-store*

The method can be one of four options:

1. *directlibsemanage* will write directly to a module store.
   This is the default value.
2. *sourcelibsemanage* manipulates a source SELinux policy.
3. */foo/bar* - Write via a policy management server, whose named socket is
   at /foo/bar. The path must begin with a '/'.
4. *foo.com:4242* -  Establish a TCP connection to a remote policy management
   server at *foo.com*. If there is a colon then the remainder is interpreted
   as a port number; otherwise default to port 4242.

*policy-version*

This optional entry can contain a policy version number, however it is normally
commented out as it then defaults to that supported by the system.

*expand-check*

This optional entry controls whether hierarchy checking on module expansion
is enabled (1) or disabled (0). The default is 0. It is also required to detect
the presence of policy rules that are to be excluded with *neverallow* rules.

*file-mode*

This optional entry allows the file permissions to be set on runtime policy
files. The format is the same as the mode parameter of the ***chmod**(1)*
command and defaults to 0644 if not present.

*save-previous*

This optional entry controls whether the previous module directory is saved
(TRUE) after a successful commit to the policy store. The default is to delete
the previous version (FALSE).

*save-linked*

This optional entry controls whether the previously linked module is saved
(TRUE) after a successful commit to the policy store. Note that this option
will create a *base.linked* file in the module policy store.
The default is to delete the previous module (FALSE).

*disable-genhomedircon*

This optional entry controls whether the embedded *genhomedircon* function is
run when using the ***semanage**(8)* command. The default is FALSE.

*handle-unknown*

This optional entry controls the kernel behaviour for handling permissions
defined in the kernel but missing from the policy.
The options are: *allow* the permission, *reject* by not loading the policy
or *deny* the permission. The default is *deny*.
Note: to activate any change, the base policy needs to be rebuilt with the
*semodule -B* command.

*bzip-blocksize*

This optional entry determines whether the modules are compressed or not
with *bzip*. If the entry is *0*, then no compression will be used (this is
required with tools such as ***apol**(1)*. This can also be set to a value
between *1* and *9* that will set the block size used for compression
(*bzip* will multiply this by 100,000, so '*9*' is faster but uses more memory).

*bzip-small*

When this optional entry is set to *TRUE* the memory usage is reduced for
compression and decompression (the *bzip* *-s* or *\-\-small* option). If *FALSE*
or no entry present, then does not try to reduce memory requirements.

*usepasswd*

When this optional entry is set to *TRUE* *semanage* will scan all password
records for home directories and set up their labels correctly.
If set to *FALSE* (the default if no entry present), then only the
*/home* directory will be automatically re-labeled.

*ignoredirs*

With a list of directories to ignore (separated by '*;*') when setting up users
home directories. This is used by some distributions to stop labeling */root*
as a home directory.

*store-root*

Specify an alternative policy store path. The default is */var/lib/selinux*.

*compiler-directory*

Specify an alternate directory that will hold the High Level Language (HLL)
to CIL compilers. The default is */usr/libexec/selinux/hll*.

*remove-hll*

When set *TRUE*, HLL files will be removed after compilation into CIL
(Read ***semanage.conf**(5)* for the consequences of removing these files).
Default is *FALSE*.

*ignore-module-cache*

Whether or not to ignore the cache of CIL modules compiled from HLL.
The default is *false*.

*target-platform*

Target platform for generated policy. Default is *selinux*, the alternate
is *xen*.

*\[verify kernel\] .. \[end\]*

Start an additional set of entries that can be used to validate the kernel
policy with an external application during the build process. There may be
multiple *\[verify kernel\]* entries.
The validation process takes place before the policy is allowed to be inserted
into the store with a worked example shown in
[**Policy Validation Example**](policy_validation_example.md#appendix-e---policy-validation-example)


*\[verify module\] .. \[end\]*

Start an additional set of entries that can be used to validate each module
by an external application during the build process. There may be multiple
*\[verify module\]* entries.

*\[verify linked\] .. \[end\]*

Start an additional set of entries that can be used to validate module linking
by an external application during the build process. There may be multiple
*\[verify linked\]* entries.

*\[load_policy\] .. \[end\]*

Replace the default load policy application with this new policy loader.
Defaults are either: */sbin/load_policy* or */usr/sbin/load_policy*.

*\[setfiles\] .. \[end\]*

Replace the default ***setfiles**(8)* application with this new *setfiles*.
Defaults are either: */sbin/setfiles* or */usr/sbin/setfiles*.

*\[sefcontexts_compile\] .. \[end\]*

Replace the default file context build application with this new builder.
Defaults are either: */sbin/sefcontexts_compile* or
*/usr/sbin/sefcontexts_compile*

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
*/etc/selinux/\<SELINUXTYPE\>/contexts/files* directory).

Each line of the file contains the full path of a file or directory.
Entries that start with a tilde \'\~\' will be expanded to watch for files
in users home directories (e.g. *\~/public_html* would cause the daemon to
listen for changes to *public_html* in all logged on users home
directories).

1. It is possible to run *restorecond* in a user session using
   the *-u* option (see ***restorecond**(8)*). This requires a
   *restorecond-user.conf* file to be installed as shown in the examples below.
2. The files names and location can be changed if *restorecond* is run
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
