# PAM Login Process

Applications used to provide login services (such as ***ssh**(1)*) in
Fedora use the PAM (Pluggable Authentication Modules) infrastructure to
provide the following services:

-   **Account Management** - This manages services such as password expiry,
service entitlement (i.e. what services the login process is allowed to
access).

-   **Authentication Management** - Authenticate the user or subject and set
up the credentials. PAM can handle a variety of devices including
smart-cards and biometric devices.

-   **Password Management** - Manages password updates as needed by the
specific authentication mechanism being used and the password policy.

-   **Session Management** - Manages any services that must be invoked
before the login process completes and / or when the login process
terminates. For SELinux this is where hooks are used to manage the
domains the subject may enter.

The ***pam**(8)* and ***pam.conf**(5)* *man* pages describe the services and
configuration in detail and only a summary is provided here covering the
SELinux services.

The PAM configuration for Fedora is managed by a number of files located
in the */etc/pam.d* directory which has configuration files for login
services such as: *gdm*, *gdm-autologin*, *login*, *remote* and *sshd*.

There are also a number of PAM related configuration files in
*/etc/security*, although only one is directly related to SELinux that
is described in the
[*/etc/security/sepermit.conf*](global_config_files.md#etcsecuritysepermit.conf)
section and also the ***sepermit.conf**(5)*.

The main login service related PAM configuration files (e.g. *gdm*)
consist of multiple lines of information that are formatted as follows:

`service type control module-path arguments`

**Where:**

<table>
<tbody>
<tr>
<td>service</td>
<td>The service name such as <em>gdm</em> and <em>login</em> reflecting the login application. If there is a <em>/etc/pam.d</em> directory, then this is the name of a configuration file name under this directory. Alternatively, a configuration file called <em>/etc/pam.conf</em> can be used. Fedora uses the <em>/etc/pam.d</em> configuration.</td>
</tr>
<tr>
<td>type</td>
<td>These are the management groups used by PAM with valid entries being: <em>account</em>, <em>auth</em>, <em>password</em> and <em>session</em> that correspond to the descriptions given above. Where there are multiple entries of the same '<em>type</em>', the order they appear could be significant.</td>
</tr>
<tr>
<td>control</td>
<td><p>This entry states how the module should behave when the requested task fails. There can be two formats: a single keyword such as <em>required</em>, <em>optional</em>, and <em>include</em>; or multiple space separated entries enclosed in square brackets consisting of :</p>
<p>  [value1=action1 value2=action2 ..]</p>
<p>Both formats are shown in the example file below, however see the <em><strong>pam.conf</strong>(5)</em> man pages for the gory details. </p></td>
</tr>
<tr>
<td>module-path</td>
<td>Either the full path name of the module or its location relative to <em>/lib/security</em> (but does depend on the system architecture).</td>
</tr>
<tr>
<td>arguments</td>
<td>A space separated list of the arguments that are defined for the module.</td>
</tr>
</tbody>
</table>

The */etc/pam.d/sshd* PAM configuration file for the OpenSSH
service is as follows:

```
#%PAM-1.0

auth       substack     password-auth
auth       include      postlogin
account    required     pam_sepermit.so
account    required     pam_nologin.so
account    include      password-auth
password   include      password-auth
session    required     pam_selinux.so close
session    required     pam_loginuid.so
session    required     pam_selinux.so open
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    optional     pam_motd.so
session    include      password-auth
session    include      postlogin
```

The core services are provided by PAM, however other library modules can
be written to manage specific services such as support for SELinux. The
***pam_sepermit**(8)* and ***pam_selinux**(8)* SELinux PAM modules use
the *libselinux* API to obtain its configuration information and the
three SELinux PAM entries highlighted in the above configuration file
perform the following functions:

-   ***pam_sepermit.so*** - Allows pre-defined users the ability to
    logon provided that SELinux is in enforcing mode (see the
    [*/etc/security/sepermit.conf*](global_config_files.md#etcsecuritysepermit.conf)
    section).
-   ***pam_selinux.so open*** - Allows a security context to be set up for
    the user at initial logon (as all programs exec'ed from here will use
    this context). How the context is retrieved is described in the
    [***Policy Configuration Files** - seusers*](policy_config_files.md#seusers)
    section.
-   ***pam_selinux.so close*** - This will reset the login programs context
    to the context defined in the policy.



<!-- %CUTHERE% -->

---
**[[ PREV ]](polyinstantiation.md)** **[[ TOP ]](#)** **[[ NEXT ]](lsm_selinux.md)**
