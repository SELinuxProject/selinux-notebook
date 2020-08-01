# File System Labeling Statements

There are four types of file labeling statements: *fs_use_xattr*,
*fs_use_task*, *fs_use_trans* and *genfscon* that are explained below.

The filesystem identifiers *fs_name* used by these statements are
defined by the SELinux teams who are responsible for their development,
the policy writer then uses those needed to be supported by the policy.

A security context is defined by these filesystem labeling statements,
therefore if the policy supports MCS / MLS, then an *mls_range* is
required as described in the
[**MLS range Definition**](mls_statements.md#mls-range-definition) section.


## *fs_use_xattr*

The *fs_use_xattr* statement is used to allocate a security context to
filesystems that support the extended attribute *security.selinux*. The
labeling is persistent for filesystems that support these extended
attributes, and the security context is added to these files (and directories)
by the SELinux commands such as ***setfiles**(8)* as explained in the
[**Labeling Extended Attribute Filesystems**](objects.md#labeling-extended-attribute-filesystems)
section.

**The statement definition is:**

```
fs_use_xattr fs_name fs_context;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>fs_use_xattr</code></td>
<td>The <code>fs_use_xattr</code> keyword.</td>
</tr>
<tr>
<td><code>fs_name</code></td>
<td>The filesystem name that supports extended attributes. Example names are: encfs, ext2, ext3, ext4, ext4dev, gfs, gfs2, jffs2, jfs, lustre and xfs.</td>
</tr>
<tr>
<td><code>fs_context</code></td>
<td>The security context allocated to the filesystem.</td>
</tr>
</tbody>
</table>

**The statement is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example:**

```
# These statements define file systems that support extended
# attributes (security.selinux).

fs_use_xattr encfs system_u:object_r:fs_t:s0;
fs_use_xattr ext2 system_u:object_r:fs_t:s0;
fs_use_xattr ext3 system_u:object_r:fs_t:s0;
```


## *fs_use_task*

The *fs_use_task* statement is used to allocate a security context to
pseudo filesystems that support task related services such as pipes and
sockets.

**The statement definition is:**

```
fs_use_task fs_name fs_context;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>fs_use_task</code></td>
<td>The <code>fs_use_task</code> keyword.</td>
</tr>
<tr>
<td><code>fs_name</code></td>
<td>Filesystem name that supports task related services. Example valid names are: eventpollfs, pipefs and sockfs.</td>
</tr>
<tr>
<td><code>fs_context</code></td>
<td>The security context allocated to the task based filesystem.</td>
</tr>
</tbody>
</table>

**The statement is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example:**

```
# These statements define the file systems that support pseudo
# filesystems that represent objects like pipes and sockets, so
# that these objects are labeled with the same type as the
# creating task.

fs_use_task eventpollfs system_u:object_r:fs_t:s0;
fs_use_task pipefs system_u:object_r:fs_t:s0;
fs_use_task sockfs system_u:object_r:fs_t:s0;
```


## *fs_use_trans*

The *fs_use_trans* statement is used to allocate a security context to
pseudo filesystems such as pseudo terminals and temporary objects. The
assigned context is derived from the creating process and that of the
filesystem type based on transition rules.

**The statement definition is:**

```
fs_use_trans fs_name fs_context;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>fs_use_trans</code></td>
<td>The <code>fs_use_trans</code> keyword.</td>
</tr>
<tr>
<td><code>fs_name</code></td>
<td>Filesystem name that supports transition rules. Example names are: mqueue, shm, tmpfs and devpts.</td>
</tr>
<tr>
<td><code>fs_context</code></td>
<td>The security context allocated to the transition based on that of the filesystem.</td>
</tr>
</tbody>
</table>

**The statement is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example:**

```
# These statements define pseudo filesystems such as devpts
# and tmpfs where objects are labeled with a derived context.

fs_use_trans mqueue system_u:object_r:tmpfs_t:s0;
fs_use_trans shm system_u:object_r:tmpfs_t:s0;
fs_use_trans tmpfs system_u:object_r:tmpfs_t:s0;
fs_use_trans devpts system_u:object_r:devpts_t:s0;
```


## *genfscon*

The *genfscon* statement is used to allocate a security context to
filesystems that cannot support any of the other file labeling
statements (*fs_use_xattr*, *fs_use_task* or *fs_use_trans*). Generally
a filesystem would have a single default security context assigned by
*genfscon* from the root (/) that would then be inherited by all files and
directories on that filesystem. The exception to this is the */proc*
filesystem, where directories can be labeled with a specific security
context (as shown in the examples). Note that there is no terminating
semi-colon on this statement.

**The statement definition is:**

```
genfscon fs_name partial_path fs_context
```

**Where:**

<table>
<tbody>
<tr>
<td><code>genfscon</code></td>
<td>The <code>genfscon</code> keyword.</td>
</tr>
<tr>
<td><code>fs_name</code></td>
<td>The filesystem name.</td>
</tr>
<tr>
<td><code>partial_path</code></td>
<td>If <code>fs_name</code> is <code>proc</code>, then the partial path (see the examples). For all other types, this must be <code>/</code>.</td>
</tr>
<tr>
<td><code>fs_context</code></td>
<td>The security context allocated to the filesystem</td>
</tr>
</tbody>
</table>

**The statement is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>

**MLS Examples:**

```
# The following examples show those filesystems that only
# support a single security context across the filesystem
# with the MLS levels added.

genfscon msdos / system_u:object_r:dosfs_t:s0
genfscon iso9660 / system_u:object_r:iso9660_t:s0
genfscon usbfs / system_u:object_r:usbfs_t:s0
genfscon selinuxfs / system_u:object_r:security_t:s0
```

```
# The following show some example /proc entries. Note that the
# /kmsg has the highest sensitivity level assigned (s15) because
# it is a trusted process.

genfscon proc / system_u:object_r:proc_t:s0
genfscon proc /sysvipc system_u:object_r:proc_t:s0
genfscon proc /fs/openafs system_u:object_r:proc_afs_t:s0
genfscon proc /kmsg system_u:object_r:proc_kmsg_t:s15:c0.c255
```


<!-- %CUTHERE% -->

---
**[[ PREV ]](sid_statement.md)** **[[ TOP ]](#)** **[[ NEXT ]](network_statements.md)**
