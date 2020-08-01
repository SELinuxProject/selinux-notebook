# Computing Security Contexts

SELinux uses a number of policy language statements and *libselinux*
functions to compute a security context via the kernel security server.

When security contexts are computed, the different kernel, userspace
tools and policy versions can influence the outcome. This is because
patches have been applied over the years that give greater flexiblity in
computing contexts. For example a 2.6.39 kernel with SELinux userspace
services supporting policy version 26 can influence the computed role.

The security context is computed for an object using the following
components: a source context, a target context and an object class.

The *libselinux* userspace functions used to compute a security context
are:

-   ***avc_compute_create**(3)* and ***security_compute_create**(3)*
-   ***avc_compute_member**(3)* and ***security_compute_member**(3)*
-   ***security_compute_relabel**(3)*

Note that these *libselinux* functions actually call the kernel
equivalent functions in the security server (see kernel source
*security/selinux/ss/services.c*: *security_compute_sid*,
*security_member_sid* and *security_change_sid*) that actually
compute the security context.

The kernel policy language statements that influence a computed security
context are:

`type_transition`, `role_transition`, `range_transition`,
`type_member` and `type_change`, `default_user`, `default_role`,
`default_type` and `default_range` statements (their corresponding CIL
statements).

The sections that follow give an overview of how security contexts are
computed for some kernel classes and also when using the userspace
*libselinux* functions.

## Security Context Computation for Kernel Objects

Using a combination of the email thread:
<http://www.spinics.net/lists/selinux/msg10746.html> and kernel 3.14
source, this is how contexts are computed by the security server for
various kernel objects (also see the
[**Linux Security Module and SELinux**](lsm_selinux.md#linux-security-module-and-selinux)
section.


### Process

The initial task starts with the kernel security context, but the
"init" process will typically transition into its own unique context
(e.g. `init_t`) when the init binary is executed after the policy has
been loaded. Some init programs re-exec themselves after loading policy,
while in other cases the initial policy load is performed by the
`initrd`/`initramfs` script prior to mounting the real root and
executing the real init program.

Processes inherit their security context as follows:

1.  On fork a process inherits the security context of its
    creator/parent.
2.  On `exec`, a process may transition to another security context
    based on policy statements: `type_transition`, `range_transition`,
    `role_transition` (policy version 26), `default_user`,
    `default_role`, `default_range` (policy versions 27) and
    `default_type` (policy version 28) or if a security-aware process,
    by calling ***setexeccon**(3)* if permitted by policy prior to
    invoking exec.
3.  At any time, a security-aware process may invoke ***setcon**(3)* to
    switch its security context (if permitted by policy) although this
    practice is generally discouraged - exec-based transitions are
    preferred.


### Files

The default behavior for labeling files (actually inodes that consist of
the following classes: files, symbolic links, directories, socket files,
fifo's and block/character) upon creation for any filesystem type that
supports labeling is as follows:

1.  The user component is inherited from the creating process (policy
    version 27 allows a `default_user` of source or target to be
    defined for each object class).
2.  The role component generally defaults to the `object_r` role
    (policy version 26 allows a `role_transition` and version 27 allows
    a `default_role` of source or target to be defined for each object
    class).
3.  The type component defaults to the type of the parent directory if
    no matching `type_transition` rule was specified in the policy
    (policy version 25 allows a filename `type_transition` rule and
    version 28 allows a `default_type` of source or target to be
    defined for each object class).
4.  The `range`/`level` component defaults to the low/current level of
    the creating process if no matching `range_transition` rule was
    specified in the policy (policy version 27 allows a `default_range`
    of source or target with the selected range being low, high or
    low-high to be defined for each object class).

Security-aware applications can override this default behavior by
calling ***setfscreatecon**(3)* prior to creating the file, if permitted
by policy.

For existing files the label is determined from the `xattr` value
associated with the file. If there is no `xattr` value set on the file,
then the file is treated as being labeled with the default file security
context for the filesystem. By default, this is the "*file*" initial
SID, which is mapped to a context by the policy. This default may be
overridden via the `defcontext=` mount option on a per-mount basis as
described in ***mount**(8)*.


### File Descriptors

Inherits the label of its creator/parent.


### Filesystems

Filesystems are labeled using the appropriate `fs_use` kernel policy
language statement as they are mounted, they are based on the filesystem
type name (e.g. `ext4`) and their behaviour (e.g. `xattr`). For example
if the policy specifies the following:

`fs_use_task pipefs system_u:object_r:fs_t:s0`

then as the `pipefs` filesystem is being mounted, the SELinux LSM
security hook `selinux_set_mnt_opts` will call `security_fs_use`
that will:

-  Look for the filesystem name within the policy (`pipefs`)
-  If present, obtain its behaviour (`fs_use_task`)
-  Then obtain the allocated security context (`system_u:object_r:fs_t:s0`)

Should the behaviour be defined as `fs_use_task`, then the filesystem
will be labeled as follows:

1.  The user component is inherited from the creating process (policy
    version 27 allows a `default_user` of source or target to be
    defined).
2.  The role component generally defaults to the `object_r` role
    (policy version 26 allows a `role_transition` and version 27 allows
    a `default_role` of source or target to be defined).
3.  The type component defaults to the type of the target type if no
    matching `type_transition` rule was specified in the policy (policy
    version 28 allows a `default_type` of source or target to be
    defined).
4.  The `range`/`level` component defaults to the low/current level of
    the creating process if no matching `range_transition` rule was
    specified in the policy (policy version 27 allows a `default_range`
    of source or target with the selected range being low, high or
    low-high to be defined).

Notes:

1.  Filesystems that support `xattr` extended attributes can be
    identified via the mount command as there will be a '`seclabel`'
    keyword present.
2.  There are mount options for allocating various context types:
    `context=`, `fscontext=`, `defcontext=` and `rootcontext=`. They are
    fully described in the ***mount**(8)* man page.


### Network File System (nfsv4.2)

If labeled NFS is implemented with `xattr` support, then the creation of
inodes are treated as described in the [Files](#files)
section.


### INET Sockets

If a socket is created by the ***socket**(3)* call they are labeled as
follows:

1.  The user component is inherited from the creating process (policy
    version 27 allows a `default_user` of source or target to be
    defined for each socket object class).
2.  The role component is inherited from the creating process (policy
    version 26 allows a `role_transition` and version 27 allows a
    `default_role` of source or target to be defined for each socket
    object class).
3.  The type component is inherited from the creating process if no
    matching `type_transition` rule was specified in the policy and
    version 28 allows a `default_type` of source or target to be
    defined for each socket object class).
4.  The `range`/`level` component is inherited from the creating process
    if no matching `range_transition` rule was specified in the policy
    (policy version 27 allows a `default_range` of source or target
    with the selected range being low, high or low-high to be defined
    for each socket object class).

Security-aware applications may use ***setsockcreatecon**(3)* to
explicitly label sockets they create if permitted by policy.

If created by a connection they are labeled with the context of the
listening process.

Some sockets may be labeled with the kernel SID to reflect the fact that
they are kernel-internal sockets that are not directly exposed to
applications.


### IPC

Inherits the label of its creator/parent.


### Message Queues

Inherits the label of its sending process. However if sending a message
that is unlabeled, compute a new label based on the current process and
the message queue it will be stored in as follows:

1.  The user component is inherited from the sending process (policy
    version 27 allows a `default_user` of source or target to be
    defined for the message object class).
2.  The role component is inherited from the sending process (policy
    version 26 allows a `role_transition` and version 27 allows a
    `default_role` of source or target to be defined for the message
    object class).
3.  The type component is inherited from the sending process if no
    matching `type_transition` rule was specified in the policy and
    version 28 allows a `default_type` of source or target to be
    defined for the message object class).
4.  The `range`/`level` component is inherited from the sending process
    if no matching `range_transition` rule was specified in the policy
    (policy version 27 allows a `default_range` of source or target
    with the selected range being low, high or low-high to be defined
    for the message object class).


### Semaphores

Inherits the label of its creator/parent.


### Shared Memory

Inherits the label of its creator/parent.


### Keys

Inherits the label of its creator/parent.

Security-aware applications may use ***setkeycreatecon**(3)* to
explicitly label keys they create if permitted by policy.


## Using libselinux Functions

### *avc_compute_create* and *security_compute_create*

**Table 1** below shows how the components from the source context
`scon`, target context `tcon` and class `tclass` are used to compute the
new context `newcon` (referenced by SIDs for
***avc_compute_create**(3)*). The following notes also apply:

1.  Any valid policy `role_transition`, `type_transition` and
    `range_transition` enforcement rules will influence the final
    outcome as shown.
2.  For kernels less than 2.6.39 the context generated will depend on
    whether the class is `process` or any other class.
3.  For kernels 2.6.39 and above the following also applies:
-   Those classes suffixed by `socket` will also be included in the `process`
    class outcome.
-   If a valid `role_transition` rule for `tclass`, then use that
    instead of the default `object_r`. Also requires policy version
    26 or greater - see ***security_policyvers**(3)*.
-   If the `type_transition` rule is classed as the 'file name
    transition rule' (i.e. it has an `object_name` parameter), then
    provided the object name in the rule matches the last component of
    the objects name (in this case a file or directory name), then use
    the rules `default_type`. Also requires policy version 25 or greater.
4.  For kernels 3.5 and above with policy version 27 or greater, the
    `default_user`, `default_role`, `default_range` statements will
    influence the `user`, `role` and `range` of the computed context for
    the specified class `tclass`. With policy version 28 or greater the
    `default_type` statement can also influence the `type` in the
    computed context.

<table>
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>user</strong></td>
<td><strong>role</strong></td>
<td><strong>type</strong></td>
<td><strong>range</strong></td>
</tr>
<tr>
<td><p>If kernel &gt;= 3.5 with a <strong>default_user </strong><em>tclass</em><strong> target</strong> rule then use <em>tcon</em> <em>user</em></p>
<p>ELSE</p>
<p>Use <em>scon</em> <em>user</em></p></td>
<td><p>If kernel &gt;=2.6.39, and there is a valid</p>
<p>role_transition</p>
<p> rule then use the rules <em>new_role</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <em><strong>default_role </strong>tclass<strong> source</strong></em> rule then use <em>scon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <em><strong>default_role </strong>tclass<strong> target</strong></em> rule then use <em>tcon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <em><strong>process</strong></em> or <em>socket</em>, then use <em>scon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <em><strong>process</strong></em>, then use <em>scon</em> <em>role</em></p>
<p>ELSE</p>
<p>Use <em><strong>object_r</strong></em></p></td>
<td><p>If there is a valid</p>
<p>type_transition</p>
<p>rule then use the rules <em>default_type</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <em><strong>default_type </strong>tclass<strong> source</strong></em> rule then use <em>scon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <em><strong>default_type </strong>tclass<strong> target</strong></em> rule then use <em>tcon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <em><strong>process</strong></em> or <em>socket</em>, then use <em>scon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <em><strong>process</strong></em>, then use <em>scon</em> <em>type</em></p>
<p>ELSE</p>
<p>Use <em>tcon</em> <em>type</em></p></td>
<td><p> If there is a valid</p>
<p>range_transition</p>
<p> rule then use the rules <em>new_range</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source low</strong> rule then use <em>scon</em> <em>low</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source high</strong> rule then use <em>scon</em> <em>high</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source low_high</strong> rule then use <em>scon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target low</strong> rule then use <em>tcon</em> <em>low</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target high</strong> rule then use <em>tcon</em> <em>high</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target low_high</strong> rule then use <em>tcon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <em><strong>process</strong></em> or <em>socket</em>, then use <em>scon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <em><strong>process</strong></em>, then use <em>scon</em> <em>range</em></p>
<p>ELSE</p>
<p>Use <em>scon</em> <em>low</em></p></td>
</tr>
</tbody>
</table>

**Table 1**


### *avc_compute_member* and *security_compute_member*

**Table 2** shows how the components from the source context,
`scon` target context, `tcon` and class, `tclass` are used to compute
the new context `newcon` (referenced by SIDs for
***avc_compute_member**(3)*). The following notes also apply:

1.  Any valid policy `type_member` enforcement rules will influence the
    final outcome as shown.
2.  For kernels less than 2.6.39 the context generated will depend on
    whether the class is `process` or any other class.
3.  For kernels 2.6.39 and above, those classes suffixed by `socket` are
    also included in the `process` class outcome.
4.  For kernels 3.5 and above with policy version 28 or greater, the
    `default_role`, `default_range` statements will influence the
    `role` and `range` of the computed context for the specified class
    `tclass`. With policy version 28 or greater the `default_type`
    statement can also influence the `type` in the computed context.

<table>
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>user</strong></td>
<td><strong>role</strong></td>
<td><strong>type</strong></td>
<td><strong>range</strong></td>
</tr>
<tr>
<td>Always uses <em>tcon</em> <em>user</em></td>
<td><p>If kernel &gt;= 3.5 with <strong>default_role </strong><em>tclass</em><strong> source</strong> rule then use <em>scon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_role </strong><em>tclass</em><strong> target</strong> rule then use <em>tcon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <strong>process</strong> or <em>socket</em>, then use <em>scon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <strong>process</strong>, then use <em>scon</em> <em>role</em></p>
<p>ELSE</p>
<p>Use <strong>object_r</strong></p></td>
<td><p>If there is a valid</p>
<p>type_member</p>
<p>rule then use the rules <em>member_type</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_type </strong><em>tclass</em><strong> source</strong> rule then use <em>scon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_type </strong><em>tclass</em><strong> target</strong> rule then use <em>tcon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <em><strong>process</strong></em> or <em>socket</em>, then use <em>scon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <strong>process</strong>, then use <em>scon</em> <em>type</em></p>
<p>ELSE</p>
<p>Use <em>tcon</em> <em>type</em></p></td>
<td><p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source low</strong> rule then use <em>scon</em> <em>low</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source high</strong> rule then use <em>scon</em> <em>high</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source low_high</strong> rule then use <em>scon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target low</strong> rule then use <em>tcon</em> <em>low</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target high</strong> rule then use <em>tcon</em> <em>high</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target low_high</strong> rule then use <em>tcon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <strong>process</strong> or <em>socket</em>, then use <em>scon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <strong>process</strong>, then use <em>scon</em> <em>range</em></p>
<p>ELSE</p>
<p>Use <em>scon</em> <em>low</em></p></td>
</tr>
</tbody>
</table>

**Table 2**


### *security_compute_relabel*

**Table 3** below shows how the components from the source context,
`scon` target context, `tcon` and class, `tclass` are used to compute
the new context `newcon` for ***security_compute_relabel**(3)*. The
following notes also apply:

1.  Any valid policy `type_change` enforcement rules will influence the
    final outcome shown in the table.
2.  For kernels less than 2.6.39 the context generated will depend on
    whether the class is `process` or any other class.
3.  For kernels 2.6.39 and above, those classes suffixed by `socket`
    are also included in the `process` class outcome.
4.  For kernels 3.5 and above with policy version 28 or greater, the
    `default_user`, `default_role`, `default_range` statements will
    influence the `user`, `role` and `range` of the computed context for
    the specified class `tclass`. With policy version 28 or greater the
    `default_type` statement can also influence the `type` in the
    computed context.

<table>
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>user</strong></td>
<td><strong>role</strong></td>
<td><strong>type</strong></td>
<td><strong>range</strong></td>
</tr>
<tr>
<td><p>If kernel &gt;= 3.5 with a <strong>default_user </strong><em>tclass</em><strong> target</strong> rule then use <em>tcon</em> <em>user</em></p>
<p>ELSE</p>
<p>Use <em>scon</em> <em>user</em></p></td>
<td><p>If kernel &gt;= 3.5 with <strong>default_role </strong><em>tclass</em><strong> source</strong> rule then use <em>scon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_role </strong><em>tclass</em><strong> target</strong> rule then use <em>tcon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <strong>process</strong> or <em>socket</em>, then use <em>scon</em> <em>role</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <strong>process</strong>, then use <em>scon</em> <em>role</em></p>
<p>ELSE</p>
<p>Use <strong>object_r</strong></p></td>
<td><p>If there is a valid</p>
<p>type_change</p>
<p>rule then use the rules <em>change_type</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_type </strong><em>tclass</em><strong> source</strong> rule then use <em>scon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_type </strong><em>tclass</em><strong> target</strong> rule then use <em>tcon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <em><strong>process</strong></em> or <em>socket</em>, then use <em>scon</em> <em>type</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <strong>process</strong>, then use <em>scon</em> <em>type</em></p>
<p>ELSE</p>
<p>Use <em>tcon</em> <em>type</em></p></td>
<td><p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source low</strong> rule then use <em>scon</em> <em>low</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source high</strong> rule then use <em>scon</em> <em>high</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> source low_high</strong> rule then use <em>scon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target low</strong> rule then use <em>tcon</em> <em>low</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target high</strong> rule then use <em>tcon</em> <em>high</em></p>
<p>OR</p>
<p>If kernel &gt;= 3.5 with <strong>default_range </strong><em>tclass</em><strong> target low_high</strong> rule then use <em>tcon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &gt;= 2.6.39 and <em>tclass</em> is <strong>process</strong> or <em>socket</em>, then use <em>scon</em> <em>range</em></p>
<p>OR</p>
<p>If kernel &lt;= 2.6.38 and <em>tclass</em> is <strong>process</strong>, then use <em>scon</em> <em>range</em></p>
<p>ELSE</p>
<p>Use <em>scon</em> <em>low</em></p></td>
</tr>
</tbody>
</table>

**Table 3**


<!-- %CUTHERE% -->

---
**[[ PREV ]](objects.md)** **[[ TOP ]](#)** **[[ NEXT ]](computing_access_decisions.md)**
