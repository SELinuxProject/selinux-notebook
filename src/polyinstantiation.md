# Polyinstantiation Support

GNU / Linux supports the polyinstantiation of directories that can be
utilised by SELinux via the Pluggable Authentication Module (PAM) as explained
in the next section. The
[**Polyinstantiation of directories in an SELinux system**](http://www.coker.com.au/selinux/talks/sage-2006/PolyInstantiatedDirectories.html)
also gives a more detailed overview of the subject.

Polyinstantiation of objects is also supported for X-windows selections
and properties that are discussed in the X-windows section. Note that
sockets are not yet supported.

To clarify polyinstantiation support:

1.  SELinux has *libselinux* functions and a policy rule to support
    polyinstantiation.
2.  The polyinstantiation of directories is a function of GNU / Linux
    not SELinux (as more correctly, the GNU / Linux services such as PAM
    have been modified to support polyinstantiation of directories and
    have also been made SELinux-aware. Therefore their services can be
    controlled via policy).
3.  The polyinstantiation of X-windows selections and properties is a
    function of the XSELinux Object Manager and the supporting XACE
    service.

<br>

## Polyinstantiated Objects

Determining a polyinstantiated context for an object is supported by
SELinux using the policy language `type_member` statement and the
***avc_compute_member**(3)* and ***security_compute_member**(3)*
libselinux API functions. These are not limited to specific object
classes, however only `dir`, `x_selection` and `x_property` objects are
currently supported.

<br>

## Polyinstantiation support in PAM

PAM supports polyinstantiation (namespaces) of directories at login time
using the Shared Subtree / Namespace services available within GNU /
Linux (the ***namespace.conf**(5)* man page is a good reference). Note
that PAM and Namespace services are SELinux-aware.

The default installation of Fedora does not enable polyinstantiated
directories, therefore this section will show the configuration required
to enable the feature and some [**examples**](#example-configurations).

To implement polyinstantiated directories PAM requires the following
files to be configured:

1.  A **pam_namespace** module entry added to the appropriate */etc/pam.d/*
    login configuration file (e.g. login, sshd, gdm etc.). Fedora
    already has these entries configured, with an example
    */etc/pam.d/gdm-password* file being:

```
auth     [success=done ignore=ignore default=bad] pam_selinux_permit.so
auth        substack      password-auth
auth        optional      pam_gnome_keyring.so
auth        include       postlogin

account     required      pam_nologin.so
account     include       password-auth

password    substack       password-auth
-password   optional       pam_gnome_keyring.so use_authtok

session     required      pam_selinux.so close
session     required      pam_loginuid.so
session     optional      pam_console.so
session     required      pam_selinux.so open
session     optional      pam_keyinit.so force revoke
session     required      pam_namespace.so
session     include       password-auth
session     optional      pam_gnome_keyring.so auto_start
session     include       postlogin
```

2.  Entries added to the */etc/security/namespace.conf* file that defines
    the directories to be polyinstantiated by PAM (and other services
    that may need to use the namespace service). The entries are
    explained in the
    [*namespace.conf*](#namespace.conf-configuration-file) section,
    with the default entries in Fedora being (note that the entries are
    commented out in the distribution):
```
# polydir  instance-prefix     method  list_of_uids
/tmp       /tmp-inst/          level   root,adm
/var/tmp   /var/tmp/tmp-inst/  level   root,adm
$HOME      $HOME/$USER.inst/   level
```

Once these files have been configured and a user logs in (although not
root or adm in the above example), the PAM **pam_namespace** module would
unshare the current namespace from the parent and mount namespaces
according to the rules defined in the namespace.conf file. The Fedora
configuration also includes an */etc/security/namespace.init* script that
is used to initialise the namespace every time a new directory instance
is set up. This script receives four parameters: the polyinstantiated
directory path, the instance directory path, a flag to indicate if a new
instance, and the user name. If a new instance is being set up, the
directory permissions are set and the ***restorecon**(8)* command is run
to set the correct file contexts.

<br>

#### *namespace.conf* Configuration File

Each line in the namespace.conf file is formatted as follows:

`polydir instance_prefix method list_of_uids`

Where:

<table>
<tbody>
<tr>
<td>polydir</td>
<td>The absolute path name of the directory to polyinstantiate. The optional strings $USER and $HOME will be replaced by the user name and home directory respectively.</td>
</tr>
<tr>
<td>instance_prefix</td>
<td>A string prefix used to build the pathname for the polyinstantiated directory. The optional strings $USER and $HOME will be replaced by the user name and home directory respectively.</td>
</tr>
<tr>
<td>method</td>
<td><p>This is used to determine the method of polyinstantiation with valid entries being:</p>
<p>user - Polyinstantiation is based on user name.</p>
<p>level - Polyinstantiation is based on the user name and MLS level.</p>
<p>context - Polyinstantiation is based on the user name and security context.</p>
<p>Note that level and context are only valid for SELinux enabled systems.</p></td>
</tr>
<tr>
<td>list_of_uids</td>
<td><p>A comma separated list of user names that will not have polyinstantiated directories. If blank, then all users are polyinstantiated. If the list is preceded with an '~' character, then only the users in the list will have polyinstantiated directories.</p>
<p>There are a number of optional flags available that are described in the <strong>namespace.conf</strong>(5) man page.</p></td>
</tr>
</tbody>
</table>

<br>

### Example Configurations

This section shows two sample *namespace.conf* configurations, the first
uses the `method=user` and the second `method=context`. It should be notedPAM
that while polyinstantiation is enabled, the full path names will not be
visible, it is only when polyinstantiation is disabled that the
directories become visible.

**Example 1 - `method=user`:**

Set the */etc/security/namespace.conf* entries as follows:

```
# polydir  instance-prefix     method  list_of_uids
/tmp       /tmp-inst/          user    root,adm
/var/tmp   /var/tmp/tmp-inst/  user    root,adm
$HOME      $HOME/$USER.inst/   user
```

Login as a normal user and the PAM / Namespace process will build the
following polyinstantiated directories:

```
# The directories will contain the user name as a part of
# the polyinstantiated directory name as follows:

# /tmp
/tmp/tmp-inst/rch

# /var/tmp:
/var/tmp/tmp-inst/rch

# $HOME
/home/rch/rch.inst/rch
```

**Example 2 - `method=context`:**

Set the */etc/security/namespace.conf* entries as follows:

```
# polydir  instance-prefix     method   list_of_uids
/tmp       /tmp-inst/          context  root,adm
/var/tmp   /var/tmp/tmp-inst/  context  root,adm
$HOME      $HOME/$USER.inst/   context
```

Login as a normal user and the PAM / Namespace process will build the
following polyinstantiated directories:

```
# The directories will contain the security context and
# user name as a part of the polyinstantiated directory
# name as follows:

# /tmp
/tmp/tmp-inst/unconfined_u:unconfined_r:unconfined_t_rch

# /var/tmp:
/var/tmp/tmp-inst/unconfined_u:unconfined_r:unconfined_t_rch

# $HOME
/home/rch/rch.inst/unconfined_u:unconfined_r:unconfined_t_rch
```

<br>

## Polyinstantiation support in X-Windows

The X-Windows SELinux object manager and XACE (X Access Control
Extension) supports *x_selection* and *x_property* polyinstantiated
objects as discussed in the
[**SELinux X-Windows Support**](x_windows.md#x-windows-selinux-support)
section.

<br>

## Polyinstantiation support in the Reference Policy

The reference policy *files.te* and *files.if* modules (in the kernel
layer) support polyinstantiated directories. There is also a global
tunable (a boolean called `polyinstantiation_enabled`) that can be used
to set this functionality on or off during login. By default this
boolean is set *false* (off).

The polyinstantiation of X-Windows objects (*x_selection* and
*x_property*) are not currently supported by the reference policy.


<br>

<!-- %CUTHERE% -->

---
**[[ PREV ]](auditing.md)** **[[ TOP ]](#)** **[[ NEXT ]](pam_login.md)**
