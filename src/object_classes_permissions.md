# Appendix A - Object Classes and Permissions

## Introduction

This section contains a list of object classes and their associated
permissions that have been taken from the Fedora policy sources. There
are also additional entries for Xen. The Android specific classes and
permissions are shown in the
[**Security Enhancements for Android**](seandroid.md#security-enhancements-for-android) section.

The SElinux Testsuite has tests that exercise a number of these object
classes/permissions and is a useful reference:
[**https://github.com/SELinuxProject/selinux-testsuite**](https://github.com/SELinuxProject/selinux-testsuite)

In most cases the permissions are self explanatory as they are those
used in the standard Linux function calls (such as 'create a socket' or
'write to a file'). Some SELinux specific permissions are:

<table>
<tbody>
<tr>
<td>relabelfrom</td>
<td>Used on most objects to allow the objects security context to be changed from the current type.</td>
</tr>
<tr>
<td>relabelto</td>
<td>Used on most objects to allow the objects security context to be changed to the new type.</td>
</tr>
<tr>
<td>entrypoint</td>
<td>Used for files to indicate that they can be used as an entry point into a domain via a domain transition.</td>
</tr>
<tr>
<td>execute_no_trans</td>
<td>Used for files to indicate that they can be used as an entry point into the calling domain (i.e. does not require a domain transition).</td>
</tr>
<tr>
<td>execmod</td>
<td>Generally used for files to indicate that they can execute the modified file in memory.</td>
</tr>
</tbody>
</table>

Where possible the specific object class permissions are explained,
however for some permissions it is difficult to determine what they are
used for, also some have been defined in documentation but never
implemented in code.

### Defining Object Classes and Permissions

The **Reference Policy** already contains the default object classes and
permissions required to manage the system and supporting services.

For those who write or manager SELinux policy, there is no need to
define new objects and their associated permissions as these would be
done by those who actually design and/or write object managers.

Note: In theory a policy could be defined with no classes or permissions
then set the `handle_unknown` flag when building the policy to `allow`
(***checkpolicy**(8)* and ***secilc**(8)*
`[-U handle-unknown (allow,deny,reject)]`). However:
-   CIL requires at least one class to be defined.
-   The `process` class with its `transition` and `dyntransition` permissions
    are still required for default labeling behaviors, role and range
    transitions in older policy versions.

The [**Object Class and Permission Statements**](class_permission_statements.md#object-class-and-permission-statements) section specifies how these are defined within the Kernel Policy
Language, and the
[**CIL Reference Guide**](./notebook-examples/selinux-policy/cil/CIL_Reference_Guide.pdf)
specifies the CIL Policy Language.

<br>

# Kernel Object Classes and Permissions

## Common Permissions

### Common File Permissions

The following table describes the common file permissions that are
inherited by a number of object classes.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong><strong>Permissions</strong></strong></td>
<td><strong><strong>Description (25 permissions)</strong></strong></td>
</tr>
<tr>
<td>append</td>
<td>Append to file.</td>
</tr>
<tr>
<td>audit_access</td>
<td><p>The rules for this permission work as follows:</p>
<p>If a process calls <em>access()</em> or <em>faccessat()</em> and SELinux denies their request there will be a check for a <em>dontaudit</em> rule on the <em>audit_access</em> permission. If there is a <em>dontaudit</em> rule on <em>audit_access</em> an AVC event will not be written. If there is no <em>dontaudit</em> rule an AVC event will be written for the permissions requested (<em>read</em>, <em>write</em>, or <em>exec</em>). </p>
<p>Notes:</p></td>
</tr>
<tr>
<td>create</td>
<td>Create new file.</td>
</tr>
<tr>
<td>execute</td>
<td>Execute the file with domain transition.</td>
</tr>
<tr>
<td>execmod</td>
<td>Make executable a file that has been modified by copy-on-write.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get file attributes.</td>
</tr>
<tr>
<td>ioctl</td>
<td>I/O control system call requests.</td>
</tr>
<tr>
<td>link</td>
<td>Create hard link.</td>
</tr>
<tr>
<td>lock</td>
<td>Set and unset file locks.</td>
</tr>
<tr>
<td>map</td>
<td>Allow a file to be memory mapped via mmap(2)</td>
</tr>
<tr>
<td>mounton</td>
<td>Use as mount point.</td>
</tr>
<tr>
<td>open</td>
<td>Added in 2.6.26 Kernel to control the open permission.</td>
</tr>
<tr>
<td>quotaon</td>
<td>Enable quotas.</td>
</tr>
<tr>
<td>read</td>
<td>Read file contents.</td>
</tr>
<tr>
<td>relabelfrom</td>
<td>Change the security context based on existing type.</td>
</tr>
<tr>
<td>relabelto</td>
<td>Change the security context based on the new type.</td>
</tr>
<tr>
<td>rename</td>
<td>Rename file.</td>
</tr>
<tr>
<td>setattr</td>
<td>Change file attributes.</td>
</tr>
<tr>
<td>unlink</td>
<td>Delete file (or remove hard link).</td>
</tr>
<tr>
<td>watch</td>
<td>Watch for file changes</td>
</tr>
<tr>
<td>watch_mount</td>
<td>Watch for mount changes</td>
</tr>
<tr>
<td>watch_sb</td>
<td>Watch for superblock changes</td>
</tr>
<tr>
<td>watch_with_perm</td>
<td>Allow <em><strong>fanotify</strong>(7)</em> masks.</td>
</tr>
<tr>
<td>watch_reads</td>
<td>Required to receive notifications from read-exclusive events.</td>
</tr>
<tr>
<td>write</td>
<td>Write or append file contents.</td>
</tr>
</tbody>
</table>

### Common Socket Permissions

The following table describes the common socket permissions that
are inherited by a number of object classes.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Permissions</strong></td>
<td><strong>Description</strong> (21 Permissions)</td>
</tr>
<tr>
<td>accept</td>
<td>Accept a connection.</td>
</tr>
<tr>
<td>append</td>
<td>Write or append socket content</td>
</tr>
<tr>
<td>bind</td>
<td>Bind to a name.</td>
</tr>
<tr>
<td>connect</td>
<td>Initiate a connection.</td>
</tr>
<tr>
<td>create</td>
<td>Create new socket.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get socket information.</td>
</tr>
<tr>
<td>getopt</td>
<td>Get socket options. </td>
</tr>
<tr>
<td>ioctl</td>
<td>Get and set attributes via ioctl call requests.</td>
</tr>
<tr>
<td>listen</td>
<td>Listen for connections.</td>
</tr>
<tr>
<td>lock</td>
<td>Lock and unlock socket file descriptor.</td>
</tr>
<tr>
<td>map</td>
<td>Allow a file to be memory mapped via mmap(2)</td>
</tr>
<tr>
<td>name_bind</td>
<td><p><em>AF_INET</em> - Controls relationship between a socket and the port number.</p>
<p><em>AF_UNIX</em> - Controls relationship between a socket and the file.</p></td>
</tr>
<tr>
<td>read</td>
<td>Read data from socket.</td>
</tr>
<tr>
<td>recvfrom</td>
<td>Receive datagrams from socket.</td>
</tr>
<tr>
<td>relabelfrom</td>
<td>Change the security context based on existing type.</td>
</tr>
<tr>
<td>relabelto</td>
<td>Change the security context based on the new type.</td>
</tr>
<tr>
<td>sendto</td>
<td>Send datagrams to socket.</td>
</tr>
<tr>
<td>setattr</td>
<td>Change attributes.</td>
</tr>
<tr>
<td>setopt</td>
<td>Set socket options.</td>
</tr>
<tr>
<td>shutdown</td>
<td>Terminate connection.</td>
</tr>
<tr>
<td>write</td>
<td>Write data to socket.</td>
</tr>
</tbody>
</table>

### Common IPC Permissions

The following table describes the common IPC permissions that are
inherited by a number of object classes.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong><strong>Permissions</strong></strong></td>
<td><strong><strong>Description</strong> </strong>(9 Permissions)</td>
</tr>
<tr>
<td>associate</td>
<td><p>shm - Get shared memory ID.</p>
<p>msgq - Get message ID.</p>
<p>sem - Get semaphore ID.</p></td>
</tr>
<tr>
<td>create</td>
<td>Create.</td>
</tr>
<tr>
<td>destroy</td>
<td>Destroy.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get information from IPC object.</td>
</tr>
<tr>
<td>read</td>
<td><p>shm - Attach shared memory to process.</p>
<p>msgq - Read message from queue.</p>
<p>sem - Get semaphore value.</p></td>
</tr>
<tr>
<td>setattr</td>
<td>Set IPC object information.</td>
</tr>
<tr>
<td>unix_read</td>
<td>Read.</td>
</tr>
<tr>
<td>unix_write</td>
<td>Write or append.</td>
</tr>
<tr>
<td>write</td>
<td><p>shm - Attach shared memory to process.</p>
<p>msgq - Send message to message queue.</p>
<p>sem - Change semaphore value.</p></td>
</tr>
</tbody>
</table>


### Common Capability Permissions

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permission</strong></td>
<td style="background-color:#F2F2F2;"><p><strong>Description</strong> (32 permissions) . Text mainly from : </p>
<p>/usr/include/linux/capability.h</p></td>
</tr>
<tr>
<td>audit_control</td>
<td>Change auditing rules. Set login UID.</td>
</tr>
<tr>
<td>audit_write</td>
<td>Send audit messages from user space.</td>
</tr>
<tr>
<td>chown</td>
<td>Allow changing file and group ownership.</td>
</tr>
<tr>
<td>dac_override</td>
<td>Overrides all DAC including ACL execute access.</td>
</tr>
<tr>
<td>dac_read_search</td>
<td>Overrides DAC for read and directory search.</td>
</tr>
<tr>
<td>fowner</td>
<td>Grant all file operations otherwise restricted due to different ownership except where FSETID capability is applicable. DAC and MAC accesses are not overridden.</td>
</tr>
<tr>
<td>fsetid</td>
<td>Overrides the restriction that the real or effective user ID of a process sending a signal must match the real or effective user ID of the process receiving the signal.</td>
</tr>
<tr>
<td>ipc_lock</td>
<td>Grants the capability to lock non-shared and shared memory segments.</td>
</tr>
<tr>
<td>ipc_owner</td>
<td>Grant the ability to ignore IPC ownership checks.</td>
</tr>
<tr>
<td>kill</td>
<td>Allow signal raising for any process.</td>
</tr>
<tr>
<td>lease</td>
<td>Grants ability to take leases on a file.</td>
</tr>
<tr>
<td>linux_immutable</td>
<td>Grant privilege to modify S_IMMUTABLE and S_APPEND file attributes on supporting filesystems.</td>
</tr>
<tr>
<td>mknod</td>
<td>Grants permission to creation of character and block device nodes.</td>
</tr>
<tr>
<td>net_admin</td>
<td>Allow the following: interface configuration; administration of IP firewall; masquerading and accounting; setting debug option on sockets; modification of routing tables; setting arbitrary process / group ownership on sockets; binding to any address for transparent proxying; setting TOS (type of service); setting promiscuous mode; clearing driver statistics; multicasting; read/write of device-specific registers; activation of ATM control sockets.</td>
</tr>
<tr>
<td>net_bind_service</td>
<td>Allow low port binding. Port &lt; 1024 for TCP/UDP. VCI &lt; 32 for ATM.</td>
</tr>
<tr>
<td>net_raw</td>
<td>Allows opening of raw sockets and packet sockets.</td>
</tr>
<tr>
<td>netbroadcast</td>
<td>Grant network broadcasting and listening to incoming multicasts.</td>
</tr>
<tr>
<td>setfcap</td>
<td>Allow the assignment of file capabilities.</td>
</tr>
<tr>
<td>setgid</td>
<td>Allow setgid(2) allow setgroups(2) allow fake gids on credentials passed over a socket.</td>
</tr>
<tr>
<td>setpcap</td>
<td>Transfer capability maps from current process to any process.</td>
</tr>
<tr>
<td>setuid</td>
<td>Allow all setsuid(2) type calls including fsuid. Allow passing of forged pids on credentials passed over a socket.</td>
</tr>
<tr>
<td>sys_admin</td>
<td>Allow the following: configuration of the secure attention key; administration of the random device; examination and configuration of disk quotas; configuring the kernel's syslog; setting the domainname; setting the hostname; calling bdflush(); mount() and umount(), setting up new smb connection; some autofs root ioctls; nfsservctl; VM86_REQUEST_IRQ; to read/write pci config on alpha; irix_prctl on mips (setstacksize); flushing all cache on m68k (sys_cacheflush); removing semaphores; locking/unlocking of shared memory segment; turning swap on/off; forged pids on socket credentials passing; setting readahead and flushing buffers on block devices; setting geometry in floppy driver; turning DMA on/off in xd driver; administration of md devices; tuning the ide driver; access to the nvram device; administration of apm_bios, serial and bttv (TV) device; manufacturer commands in isdn CAPI support driver; reading non-standardized portions of pci configuration space; DDI debug ioctl on sbpcd driver; setting up serial ports; sending raw qic-117 commands; enabling/disabling tagged queuing on SCSI controllers and sending arbitrary SCSI commands; setting encryption key on loopback filesystem; setting zone reclaim policy.</td>
</tr>
<tr>
<td>sys_boot</td>
<td>Grant ability to reboot the system.</td>
</tr>
<tr>
<td>sys_chroot</td>
<td>Grant use of the <strong>chroot</strong>(2) call.</td>
</tr>
<tr>
<td>sys_module</td>
<td>Allow unrestricted kernel modification including but not limited to loading and removing kernel modules. Allows modification of kernel's bounding capability mask. See sysctl. </td>
</tr>
<tr>
<td>sys_nice</td>
<td>Grants privilege to change priority of any process. Grants change of scheduling algorithm used by any process.</td>
</tr>
<tr>
<td>sys_pacct</td>
<td>Allow modification of accounting for any process.</td>
</tr>
<tr>
<td>sys_ptrace</td>
<td>Allow ptrace of any process.</td>
</tr>
<tr>
<td>sys_rawio</td>
<td>Grant permission to use <strong>ioperm</strong>(2) and <strong>iopl</strong>(2) as well as the ability to send messages to USB devices via /proc/bus/usb.</td>
</tr>
<tr>
<td>sys_resource</td>
<td><p>Override the following: resource limits; quota limits; reserved space on ext2 filesystem; size restrictions on IPC message queues; max number of consoles on console allocation; max number of keymaps.</p>
<p>Set resource limits.</p>
<p>Modify data journaling mode on ext3 filesystem, </p>
<p>Allow more than 64hz interrupts from the real-time clock.</p></td>
</tr>
<tr>
<td>sys_time</td>
<td>Grant permission to set system time and to set the real-time lock.</td>
</tr>
<tr>
<td>sys_tty_config</td>
<td>Grant permission to configure tty devices.</td>
</tr>
</tbody>
</table>

### Common Capability2 Permissions

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;">Description (6 permissions)</td>
</tr>
<tr>
<td>audit_read</td>
<td>Allow reading audits logs.</td>
</tr>
<tr>
<td>block_suspend</td>
<td>Prevent system suspends (was <em>epollwakeup</em>)</td>
</tr>
<tr>
<td>mac_admin</td>
<td><p>Allow MAC configuration state changes. For SELinux allow contexts not defined in the policy to be assigned. This is called 'deferred mapping of security contexts' and is explained at:</p>
<p><a href="http://marc.info/?l=selinux&amp;m=121017988131629&amp;w=2">http://marc.info/?l=selinux&amp;m=121017988131629&amp;w=2</a></p></td>
</tr>
<tr>
<td>mac_override</td>
<td>Allow MAC policy to be overridden. (not used)</td>
</tr>
<tr>
<td>syslog</td>
<td>Allow configuration of kernel <em>syslog</em> (<em>printk</em> behaviour).</td>
</tr>
<tr>
<td>wake_alarm</td>
<td>Trigger the system to wake up.</td>
</tr>
</tbody>
</table>

### Common Database Permissions

The following table describes the common database permissions that
are inherited by the database object classes. The
"[Security-Enhanced PostgreSQL Security Wiki](http://wiki.postgresql.org/wiki/SEPostgreSQL_Development)"
explains the objects, their permissions and how they should be used in detail.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Permissions</strong></td>
<td><strong>Description</strong> (6 Permissions)</td>
</tr>
<tr>
<td>create</td>
<td>Create a database object such as a 'TABLE'.</td>
</tr>
<tr>
<td>drop</td>
<td>Delete (<em>DROP</em>) a database object.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get metadata - needed to reference an object (e.g. SELECT ... FROM ...).</td>
</tr>
<tr>
<td>relabelfrom</td>
<td>Change the security context based on existing type.</td>
</tr>
<tr>
<td>relabelto</td>
<td>Change the security context based on the new type.</td>
</tr>
<tr>
<td>setattr</td>
<td>Set metadata - this permission is required to update information in the database (e.g. ALTER ...).</td>
</tr>
</tbody>
</table>


### Common X_Device Permissions

The following table describes the common *x_device* permissions that are
inherited by the X-Windows *x_keyboard* and *x_pointer* object classes.

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (19 permissions)</td>
</tr>
<tr>
<td>add</td>
<td></td>
</tr>
<tr>
<td>bell</td>
<td></td>
</tr>
<tr>
<td>create</td>
<td></td>
</tr>
<tr>
<td>destroy</td>
<td></td>
</tr>
<tr>
<td>force_cursor</td>
<td>Get window focus.</td>
</tr>
<tr>
<td>freeze</td>
<td></td>
</tr>
<tr>
<td>get_property</td>
<td>Required to create a device context. (source code)</td>
</tr>
<tr>
<td>getattr</td>
<td></td>
</tr>
<tr>
<td>getfocus</td>
<td></td>
</tr>
<tr>
<td>grab</td>
<td>Set window focus.</td>
</tr>
<tr>
<td>list_property</td>
<td></td>
</tr>
<tr>
<td>manage</td>
<td></td>
</tr>
<tr>
<td>read</td>
<td></td>
</tr>
<tr>
<td>remove</td>
<td></td>
</tr>
<tr>
<td>set_property</td>
<td></td>
</tr>
<tr>
<td>setattr</td>
<td></td>
</tr>
<tr>
<td>setfocus</td>
<td></td>
</tr>
<tr>
<td>use</td>
<td></td>
</tr>
<tr>
<td>write</td>
<td></td>
</tr>
</tbody>
</table>

<br>

## File Object Classes

### `filesystem`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>filesystem</strong> - A mounted filesystem</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (10 unique permissions)</td>
</tr>
<tr>
<td>associate</td>
<td>Use type as label for file.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get file attributes.</td>
</tr>
<tr>
<td>mount</td>
<td>Mount filesystem.</td>
</tr>
<tr>
<td>quotaget</td>
<td>Get quota information.</td>
</tr>
<tr>
<td>quotamod</td>
<td>Modify quota information.</td>
</tr>
<tr>
<td>relabelfrom</td>
<td>Change the security context based on existing type.</td>
</tr>
<tr>
<td>relabelto</td>
<td>Change the security context based on the new type.</td>
</tr>
<tr>
<td>remount</td>
<td>Remount existing mount.</td>
</tr>
<tr>
<td>unmount</td>
<td>Unmount filesystem.</td>
</tr>
<tr>
<td>watch</td>
<td>Watch for filesystem changes</td>
</tr>
</tbody>
</table>

### `dir`

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Class</strong></td>
<td><strong>dir</strong> - Directory</td>
</tr>
<tr style="background-color:#F2F2F2;">
<td><strong>Permissions</strong></td>
<td><strong>Description</strong> (Inherit 25 common file permissions + 5 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-file-permissions"><strong>Inherit Common File Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">append, audit_access, create, execute, execmod, getattr, ioctl, link, lock, map, mounton, open, quotaon, read, relabelfrom, relabelto, rename, setattr, unlink,<em> watch, watch_mount, watch_sb, watch_with_perm, watch_reads, write</td>
</tr>
<tr>
<td>add_name</td>
<td>Add entry to the directory.</td>
</tr>
<tr>
<td>remove_name</td>
<td>Remove an entry from the directory.</td>
</tr>
<tr>
<td>reparent</td>
<td>Change parent directory.</td>
</tr>
<tr>
<td>rmdir</td>
<td>Remove directory.</td>
</tr>
<tr>
<td>search</td>
<td>Search directory.</td>
</tr>
</tbody>
</table>

### `file`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>file</strong> - Ordinary file</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 25 common file permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-file-permissions"><strong>Inherit Common File Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">append, audit_access, create, execute, execmod, getattr, ioctl, link, lock, map, mounton, open, quotaon, read, relabelfrom, relabelto, rename, setattr, unlink,<em> watch, watch_mount, watch_sb, watch_with_perm, watch_reads, write</td>
</tr>
<tr>
<td>entrypoint</td>
<td>Entry point permission for a domain transition.</td>
</tr>
<tr>
<td>execute_no_trans</td>
<td>Execute in the caller's domain (i.e. no domain transition).</td>
</tr>
</tbody>
</table>

### `lnk_file`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>lnk_file</strong> - Symbolic links</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 25 common file permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-file-permissions"><strong>Inherit Common File Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">append, audit_access, create, execute, execmod, getattr, ioctl, link, lock, map, mounton, open, quotaon, read, relabelfrom, relabelto, rename, setattr, unlink,<em> watch, watch_mount, watch_sb, watch_with_perm, watch_reads, write</td>
</tr>
</tbody>
</table>

### `chr_file`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>chr_file</strong> - Character files</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 25 common file permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-file-permissions"><strong>Inherit Common File Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">append, audit_access, create, execute, execmod, getattr, ioctl, link, lock, map, mounton, open, quotaon, read, relabelfrom, relabelto, rename, setattr, unlink,<em> watch, watch_mount, watch_sb, watch_with_perm, watch_reads, write</td>
</tr>
</tbody>
</table>

### `blk_file`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>blk_file</strong> - Block files</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 25 common file permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-file-permissions"><strong>Inherit Common File Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">append, audit_access, create, execute, execmod, getattr, ioctl, link, lock, map, mounton, open, quotaon, read, relabelfrom, relabelto, rename, setattr, unlink,<em> watch, watch_mount, watch_sb, watch_with_perm, watch_reads, write</td>
</tr>
</tbody>
</table>

### `sock_file`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>sock_file</strong> - UNIX domain sockets</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 25 common file permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-file-permissions"><strong>Inherit Common File Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">append, audit_access, create, execute, execmod, getattr, ioctl, link, lock, map, mounton, open, quotaon, read, relabelfrom, relabelto, rename, setattr, unlink,<em> watch, watch_mount, watch_sb, watch_with_perm, watch_reads, write</td>
</tr>
</tbody>
</table>

### `fifo_file`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>fifo_file</strong> - Named pipes</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 25 common file permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-file-permissions"><strong>Inherit Common File Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">append, audit_access, create, execute, execmod, getattr, ioctl, link, lock, map, mounton, open, quotaon, read, relabelfrom, relabelto, rename, setattr, unlink,<em> watch, watch_mount, watch_sb, watch_with_perm, watch_reads, write</td>
</tr>
</tbody>
</table>

### `fd`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>fd</strong> - File descriptors</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (1 unique permission)</td>
</tr>
<tr>
<td>use</td>
<td><p>1) Inherit fd when process is executed and domain has been changed.</p>
<p>2) Receive fd from another process by Unix domain socket.</p>
<p>3) Get and set attribute of fd.</p></td>
</tr>
</tbody>
</table>

<br>

## Network Object Classes

### `node`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>node</strong> - IP address or range of IP addresses, used when peer labeling is configured.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>recvfrom</td>
<td>Network interface and address check permission for use with the ingress permission.</td>
</tr>
<tr>
<td>sendto</td>
<td>Network interface and address check permission for use with the egress permission.</td>
</tr>
</tbody>
</table>

### `netif`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netif</strong> - Network Interface (e.g. eth0) used when peer labeling is configured.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>egress</td>
<td>Each packet leaving the system must pass an egress access control. Also requires the node sendto permission.</td>
</tr>
<tr>
<td>ingress</td>
<td>Each packet entering the system must pass an ingress access control. Also requires the node recvfrom permission.</td>
</tr>
</tbody>
</table>

### `socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>socket</strong> - Socket that is not part of any other specific SELinux socket object class.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `tcp_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>tcp_socket</strong> - Protocol: PF_INET, PF_INET6 Family Type: SOCK_STREAM</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>name_connect</td>
<td>Connect to a specific port type.</td>
</tr>
<tr>
<td>node_bind</td>
<td>Bind to a node.</td>
</tr>
</tbody>
</table>

### `udp_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>udp_socket</strong> - Protocol: PF_INET, PF_INET6 Family Type: SOCK_DGRAM</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions + 1 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>node_bind</td>
<td>Bind to a node.</td>
</tr>
</tbody>
</table>

### `rawip_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>rawip_socket</strong> - Protocol: PF_INET, PF_INET6 Family Type: SOCK_RAW</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 1 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>node_bind</td>
<td>Bind to a node.</td>
</tr>
</tbody>
</table>

### `packet_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>packet_socket</strong> - Protocol: PF_PACKET Family Type: All.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `unix_stream_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>unix_stream_socket</strong> - Communicate with processes on same machine. Protocol: PF_STREAM Family Type: SOCK_STREAM</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 1 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>connectto</td>
<td>Connect to server socket.</td>
</tr>
</tbody>
</table>

### `unix_dgram_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>unix_dgram_socket</strong> - Communicate with processes on same machine. Protocol: PF_STREAM Family Type: SOCK_DGRAM</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `tun_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>tun_socket</strong> - TUN is Virtual Point-to-Point network device driver to support IP tunneling.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 1 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>attach_queue</td>
<td></td>
</tr>
</tbody>
</table>

<br>

## IPSec Network Object Classes

### `association`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>association</strong> - IPSec security association</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(4 unique permissions)</td>
</tr>
<tr>
<td>polmatch</td>
<td>Match IPSec Security Policy Database (SPD) context (-ctx) entries to an SELinux domain (contained in the Security Association Database (SAD) .</td>
</tr>
<tr>
<td>recvfrom</td>
<td>Receive from an IPSec association.</td>
</tr>
<tr>
<td>sendto</td>
<td>Send to an IPSec association.</td>
</tr>
<tr>
<td>setcontext</td>
<td>Set the context of an IPSec association on creation.</td>
</tr>
</tbody>
</table>

### `key_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>key_socket</strong> - IPSec key management. Protocol: PF_KEY Family Type: All</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_xfrm_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_xfrm_socket</strong> - Netlink socket to maintain IPSec parameters. </td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>nlmsg_read</td>
<td>Get IPSec configuration information.</td>
</tr>
<tr>
<td>nlmsg_write</td>
<td>Set IPSec configuration information.</td>
</tr>
</tbody>
</table>

<br>

## Netlink Object Classes

Netlink sockets communicate between userspace and the kernel – also see
***netlink**(7)*.

### `netlink_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_socket</strong> - Netlink socket that is not part of any specific SELinux Netlink socket class. Protocol: PF_NETLINK Family Type: All other types that are not part of any other specific netlink object class.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_route_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_route_socket</strong> - Netlink socket to manage and control network resources.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>nlmsg_read</td>
<td>Read kernel routing table.</td>
</tr>
<tr>
<td>nlmsg_write</td>
<td>Write to kernel routing table.</td>
</tr>
</tbody>
</table>

### `netlink_firewall_socket` (Deprecated)

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>obsolete_netlink_firewall_socket</strong> - Netlink socket for firewall filters.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>nlmsg_read</td>
<td>Read netlink message.</td>
</tr>
<tr>
<td>nlmsg_write</td>
<td>Write netlink message.</td>
</tr>
</tbody>
</table>

### `netlink_tcpdiag_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_tcpdiag_socket</strong> - Netlink socket to monitor TCP connections.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>nlmsg_read</td>
<td>Request information about a protocol.</td>
</tr>
<tr>
<td>nlmsg_write</td>
<td>Write netlink message.</td>
</tr>
</tbody>
</table>

### `netlink_nflog_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_nflog_socket</strong> - Netlink socket for Netfilter logging</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_selinux_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_selinux_socket</strong> - Netlink socket to receive SELinux events such as a policy or boolean change.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_audit_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_audit_socket</strong> - Netlink socket for audit service.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 5 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>nlmsg_read</td>
<td>Query status of audit service.</td>
</tr>
<tr>
<td>nlmsg_readpriv</td>
<td>List auditing configuration rules.</td>
</tr>
<tr>
<td>nlmsg_relay</td>
<td>Send userspace audit messages to theaudit service.</td>
</tr>
<tr>
<td>nlmsg_tty_audit</td>
<td>Control TTY auditing.</td>
</tr>
<tr>
<td>nlmsg_write</td>
<td>Update audit service configuration.</td>
</tr>
</tbody>
</table>

### `netlink_ip6fw_socket` (Deprecated)

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>obsolete_netlink_ip6fw_socket</strong> - Netlink socket for IPv6 firewall filters.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>nlmsg_read</td>
<td>Read netlink message.</td>
</tr>
<tr>
<td>nlmsg_write</td>
<td>Write netlink message.</td>
</tr>
</tbody>
</table>

### `netlink_dnrt_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_dnrt_socket</strong> - Netlink socket for DECnet routing</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_kobject_uevent_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>netlink_kobject_uevent_socket</strong> - Netlink socket to send kernel events to userspace.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_iscsi_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netlink_iscsi_socket</strong> </em>- Netlink socket to support RFC 3720 - Internet Small Computer Systems Interface (iSCSI).</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_fib_lookup_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netlink_fib_lookup_socket</strong></em> - Netlink socket to Forwarding Informaton Base services.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_connector_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netlink_connector_socket</strong></em> - Netlink socket to support kernel connector services.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_netfilter_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netlink_netfilter_socket</strong></em> - Netlink socket netfilter services.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_generic_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netlink_generic_socket</strong></em> – Simplified netlink socket.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_scsitransport_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netlink_scsitransport_socket</strong></em> – SCSI transport netlink socket.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_rdma_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netlink_rdma_socket</strong></em> - Remote Direct Memory Access netlink socket.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `netlink_crypto_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netlink_crypto_socket</strong></em> - Kernel crypto API netlink socket.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

<br>

## Miscellaneous Network Object Classes

### `peer`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>peer </strong>- NetLabel and Labeled IPsec have separate access controls, the network peer label consolidates these two access controls into a single one (see <a href="http://paulmoore.livejournal.com/1863.html"><em><em>http://paulmoore.livejournal.com/1863.html</em></em></a> for details).</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (1 unique permission)</td>
</tr>
<tr>
<td>recv</td>
<td>Receive packets from a labeled networking peer.</td>
</tr>
</tbody>
</table>

### `packet`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>packet</strong> - Supports 'secmark' services where packets are labeled using iptables to select and label packets, SELinux then enforces policy using these packet labels.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (5 unique permissions)</td>
</tr>
<tr>
<td>forward_in</td>
<td>Allow inbound forwaded packets. </td>
</tr>
<tr>
<td>forward_out</td>
<td>Allow outbound forwarded packets. </td>
</tr>
<tr>
<td>recv</td>
<td>Receive inbound locally consumed packets. </td>
</tr>
<tr>
<td>relabelto</td>
<td>Control how domains can apply specific labels to packets.</td>
</tr>
<tr>
<td>send</td>
<td>Send outbound locally generated packets. </td>
</tr>
</tbody>
</table>

### `appletalk_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>appletalk_socket</strong> - Appletalk socket</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

### `dccp_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>dccp_socket - </strong>Datagram Congestion Control Protocol (DCCP)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>name_connect</td>
<td>Allow DCCP name connect(). </td>
</tr>
<tr>
<td>node_bind</td>
<td>Allow DCCP bind().</td>
</tr>
</tbody>
</table>

<br>

## Sockets via *extended_socket_class*

These socket classes that were introduced by the
*extended_socket_class* policy capability in kernel version 4.16 ?.

### `sctp_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>sctp_socket - </strong>Stream Control Transmission Protocol (SCTP)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 3 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>association</td>
<td>Allow an SCTP association.</td>
</tr>
<tr>
<td>name_connect</td>
<td>Allow SCTP name connect(2) and <em>connectx(3)</em>.</td>
</tr>
<tr>
<td>node_bind</td>
<td>Allow SCTP bind(2) and <em>bindx(3)</em>.</td>
</tr>
</tbody>
</table>

### `icmp_socket`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>icmp_socket - </strong>Internet Control Message Protocol (ICMP)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 21 common socket permissions + 1unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
<tr>
<td>node_bind</td>
<td>Allow ICMP bind().</td>
</tr>
</tbody>
</table>

### Miscellaneous Extended Socket Classes

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>ax25_socket</strong></em> - Amateur X.25</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>ipx_socket</strong></em> - Internetwork Packet Exchange</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>netrom_socket</strong></em> – Part of Amateur X.25</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>atmpvc_socket</strong></em> - Asynchronous Transfer Mode Permanent Virtual Circuit</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>x25_socket</strong></em> - X.25</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>rose_socket</strong></em> - Remote Operations Service Element</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>decnet_socket</strong></em> – Everyone knows this</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>atmsvc_socket</strong></em> - Asynchronous Transfer Mode Switched Virtual Circuit</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>rds_socket</strong></em> - Remote Desktop Protocol</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>irda_socket</strong></em> - Infrared Data Association (IrDA)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>pppox_socket</strong></em> - Point-to-Point Protocol over Ethernet/ATM ...</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>llc_socket</strong></em> – Link Level Control</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>can_socket</strong></em> - Controller Area Network</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>tipc_socket</strong></em> - Transparent Inter Process Communication</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>bluetooth_socket</strong></em> </td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>iucv_socket</strong></em> - Inter User Communication Vehicle</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>rxrpc_socket</strong></em> – A reliable two phase transport</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>isdn_socket</strong></em> - Integrated Services Digital Network</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>phonet_socket</strong></em> - packet protocol used by Nokia cellular modems</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>ieee802154_socket</strong></em> – For low-rate wireless personal area networks (LR-WPANs).</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>caif_socket</strong></em> - Communication CPU to Application CPU Interface </td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>alg_socket</strong></em> - algorithm interface</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>nfc_socket</strong></em> – Near Field Commuications</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>vsock_socket</strong></em> - Virtual Socket protocol</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>kcm_socket</strong></em> - Kernel Connection Multiplexor</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>qipcrtr_socket</strong></em> - communicating with services running on co-processors in Qualcomm platforms</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>smc_socket</strong></em> - Shared Memory Communications</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>xdp_socket</strong></em> - eXpress Data Path</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 21 common socket permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-socket-permissions"><strong>Inherit Common Socket Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">accept, append, bind, connect, create, getattr, getopt, ioctl, listen, lock, map, name_bind, read, recvfrom, relabelfrom, relabelto, sendto, setattr, setopt, shutdown, write</td>
</tr>
</tbody>
</table>

<br>

## BPF Object Class

### `bpf`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>bpf</strong> - Support for extended Berkeley Packet Filters <em><strong>bpf</strong>(2) </em></td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (5 unique permissions)</td>
</tr>
<tr>
<td>map_create</td>
<td>Create map</td>
</tr>
<tr>
<td>map_read</td>
<td>Read map</td>
</tr>
<tr>
<td>map_write</td>
<td>Write to map</td>
</tr>
<tr>
<td>prog_load</td>
<td>Load program</td>
</tr>
<tr>
<td>prog_run</td>
<td>Run program</td>
</tr>
</tbody>
</table>

<br>

## Performance Event Object Class

### `perf_event`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>perf_event</strong> – Control <em><strong>perf</strong>(1)</em> events </td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (6 unique permissions)</td>
</tr>
<tr>
<td>cpu</td>
<td>Monitor cpu</td>
</tr>
<tr>
<td>kernel</td>
<td>Monitor kernel</td>
</tr>
<tr>
<td>open</td>
<td>Open a perf event</td>
</tr>
<tr>
<td>read</td>
<td>Read perf event</td>
</tr>
<tr>
<td>tracepoint</td>
<td>Set tracepoints</td>
</tr>
<tr>
<td>write</td>
<td>Write a perf event</td>
</tr>
</tbody>
</table>

<br>

## Lockdown Object Class

Note: If the *lockdown* LSM is enabled alongside SELinux, then the
lockdown access control will take precedence over the SELinux lockdown
implementation.

### `lockdown`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>lockdown</strong> – Stop userspace extracting/modify kernel data</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (6 unique permissions)</td>
</tr>
<tr>
<td>confidentiality</td>
<td>Kernel features that allow userspace to extract confidential information from the kernel are disabled.</td>
</tr>
<tr>
<td>integrity</td>
<td>Kernel features that allow userspace to modify the running kernel are disabled</td>
</tr>
</tbody>
</table>

<br>

## IPC Object Classes

### `ipc`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>ipc</strong> - Interprocess communications</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 9 common IPC permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-ipc-permissions"><strong>Inherit Common IPC Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">associate, create, destroy, getattr, read, setattr, unix_read, unix_write, write</td>
</tr>
</tbody>
</table>

### `sem`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>sem</strong> - Semaphores</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 9 common IPC permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-ipc-permissions"><strong>Inherit Common IPC Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">associate, create, destroy, getattr, read, setattr, unix_read, unix_write, write</td>
</tr>
</tbody>
</table>

### `msgq`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>msgq</strong> - IPC Message queues</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 9 common IPC permissions + 1 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-ipc-permissions"><strong>Inherit Common IPC Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">associate, create, destroy, getattr, read, setattr, unix_read, unix_write, write</td>
</tr>
<tr>
<td>enqueue</td>
<td>Send message to message queue.</td>
</tr>
</tbody>
</table>

### `msg`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>msg</strong> - Message in a queue</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>receive</td>
<td>Read (and remove) message from queue.</td>
</tr>
<tr>
<td>send</td>
<td>Add message to queue.</td>
</tr>
</tbody>
</table>

### `shm`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>shm</strong> - Shared memory segment</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 9 common IPC permissions + 1 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-ipc-permissions"><strong>Inherit Common IPC Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">associate, create, destroy, getattr, read, setattr, unix_read, unix_write, write</td>
</tr>
<tr>
<td>lock</td>
<td>Lock or unlock shared memory.</td>
</tr>
</tbody>
</table>

<br>

## Process Object Class

### `process`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>process</strong> - An object is instantiated for each process created by the system.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (31 unique permissions)</td>
</tr>
<tr>
<td>dyntransition</td>
<td>Dynamically transition to a new context using <em><strong>setcon</strong>(3)</em>.</td>
</tr>
<tr>
<td>execheap</td>
<td>Make the heap executable.</td>
</tr>
<tr>
<td>execmem</td>
<td>Make executable an anonymous mapping or private file mapping that is writable.</td>
</tr>
<tr>
<td>execstack</td>
<td>Make the main process stack executable.</td>
</tr>
<tr>
<td>fork</td>
<td>Create new process using fork(2).</td>
</tr>
<tr>
<td>getattr</td>
<td>Get process security information.</td>
</tr>
<tr>
<td>getcap</td>
<td>Get Linux capabilities of process.</td>
</tr>
<tr>
<td>getpgid</td>
<td>Get group Process ID of another process.</td>
</tr>
<tr>
<td>getsched</td>
<td>Get scheduling information of another process.</td>
</tr>
<tr>
<td>getsession</td>
<td>Get session ID of another process.</td>
</tr>
<tr>
<td>getrlimit</td>
<td>Get process rlimit information.</td>
</tr>
<tr>
<td>noatsecure</td>
<td>Disable secure mode environment cleansing.</td>
</tr>
<tr>
<td>ptrace</td>
<td>Trace program execution of parent (<strong>ptrace</strong>(2)).</td>
</tr>
<tr>
<td>rlimitinh</td>
<td>Inherit rlimit information from parent process.</td>
</tr>
<tr>
<td>setcap</td>
<td>Set Linux capabilities of process.</td>
</tr>
<tr>
<td>setcurrent</td>
<td>Set the current process context.</td>
</tr>
<tr>
<td>setexec</td>
<td>Set security context of executed process by <strong>setexecon</strong>(3).</td>
</tr>
<tr>
<td>setfscreate</td>
<td>Set security context by <strong>setfscreatecon</strong>(3).</td>
</tr>
<tr>
<td>setkeycreate</td>
<td>Set security context by <strong>setkeycreatecon</strong>(3).</td>
</tr>
<tr>
<td>setpgid</td>
<td>Set group Process ID of another process.</td>
</tr>
<tr>
<td>setrlimit</td>
<td>Change process rlimit information.</td>
</tr>
<tr>
<td>setsched</td>
<td>Modify scheduling information of another process.</td>
</tr>
<tr>
<td>setsockcreate</td>
<td>Set security context by <strong>setsockcreatecon</strong>(3).</td>
</tr>
<tr>
<td>share</td>
<td>Allow state sharing with cloned or forked process.</td>
</tr>
<tr>
<td>sigchld</td>
<td>Send SIGCHLD signal.</td>
</tr>
<tr>
<td>siginh</td>
<td>Inherit signal state from parent process.</td>
</tr>
<tr>
<td>sigkill</td>
<td>Send SIGKILL signal.</td>
</tr>
<tr>
<td>signal</td>
<td>Send a signal other than SIGKILL, SIGSTOP, or SIGCHLD.</td>
</tr>
<tr>
<td>signull</td>
<td>Test for exisitence of another process without sending a signal</td>
</tr>
<tr>
<td>sigstop</td>
<td>Send SIGSTOP signal</td>
</tr>
<tr>
<td>transition</td>
<td>Transition to a new context on exec().</td>
</tr>
</tbody>
</table>

### `process2`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">process2</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>nnp_transition</td>
<td>Enables SELinux domain transitions to occur under <em>no_new_privs</em> (NNP) </td>
</tr>
<tr>
<td>nosuid_transition</td>
<td>Enables SELinux domain transitions to occur on <em>nosuid</em> <em><strong>mount</strong>(8)</em> </td>
</tr>
</tbody>
</table>

<br>

## Security Object Class

### `security`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>security</strong> - This is the security server object and there is only one instance of this object (for the SELinux security server).</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (13 unique permissions)</td>
</tr>
<tr>
<td>check_context</td>
<td>Determine whether the context is valid by querying the security server.</td>
</tr>
<tr>
<td>compute_av</td>
<td>Compute an access vector given a source, target and class.</td>
</tr>
<tr>
<td>compute_create</td>
<td>Determine context to use when querying the security server about a transition rule (type_transition).</td>
</tr>
<tr>
<td>compute_member</td>
<td>Determine context to use when querying the security server about a membership decision (type_member for a polyinstantiated object).</td>
</tr>
<tr>
<td>compute_relabel</td>
<td>Determines the context to use when querying the security server about a relabeling decision (type_change).</td>
</tr>
<tr>
<td>compute_user</td>
<td>Determines the context to use when querying the security server about a user decision (user).</td>
</tr>
<tr>
<td>load_policy</td>
<td>Load the security policy into the kernel (the security server).</td>
</tr>
<tr>
<td>read_policy</td>
<td>Read the kernel policy to userspace.</td>
</tr>
<tr>
<td>setbool</td>
<td>Change a boolean value within the active policy.</td>
</tr>
<tr>
<td>setcheckreqprot</td>
<td>Set if SELinux will check original protection mode or modified protection mode (read-implies-exec) for mmap / mprotect.</td>
</tr>
<tr>
<td>setenforce</td>
<td>Change the enforcement state of SELinux (permissive or enforcing).</td>
</tr>
<tr>
<td>setsecparam</td>
<td>Set kernel access vector cache tuning parameters.</td>
</tr>
<tr>
<td>validate_trans</td>
<td>Compute a <em>validatetrans</em> rule.</td>
</tr>
</tbody>
</table>

<br>

## System Operation Object Class

Note that while this is defined as a kernel object class, the userspace
***systemd**(1)* has hitched a ride.

### `system`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>system</strong> - This is the overall system object and there is only one instance of this object.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (6 unique <strong>kernel</strong> permissions)</td>
</tr>
<tr>
<td>ipc_info</td>
<td>Get info about an IPC object.</td>
</tr>
<tr>
<td>module_load</td>
<td>Required permission when reading a file that is a 'kernel module'. See <a href="http://marc.info/?l=selinux&amp;m=145988689809307&amp;w=2">http://marc.info/?l=selinux&amp;m=145988689809307&amp;w=2</a> for an example.</td>
</tr>
<tr>
<td>module_request</td>
<td>Request the kernel to load a module.</td>
</tr>
<tr>
<td>syslog_console</td>
<td>Control output of kernel messages to the console with syslog(2).</td>
</tr>
<tr>
<td>syslog_mod</td>
<td>Clear kernel message buffer with syslog(2).</td>
</tr>
<tr>
<td>syslog_read</td>
<td>Read kernel message with syslog(2).</td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr>
<td>User-space Permissions</td>
<td><strong>Description</strong> (8 unique <strong>userspace</strong> permissions). These have been added for use by <em>systemd(1)</em>.</td>
</tr>
<tr>
<td>disable</td>
<td>?</td>
</tr>
<tr>
<td>enable</td>
<td>Enable default target/file</td>
</tr>
<tr>
<td>halt</td>
<td>Allow systemd to close down</td>
</tr>
<tr>
<td>reboot</td>
<td>Allow reboot by system manager</td>
</tr>
<tr>
<td>reload</td>
<td>Allow reload</td>
</tr>
<tr>
<td>stop</td>
<td>?</td>
</tr>
<tr>
<td>start</td>
<td>?</td>
</tr>
<tr>
<td>status</td>
<td>Obtain systemd status</td>
</tr>
</tbody>
</table>

<br>

## Miscellaneous Kernel Object Classes

### `kernel_service`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>kernel_service</strong> - Used to add kernel services.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>use_as_override</td>
<td><p>Grant a process the right to nominate an alternate process SID for the kernel to use as an override for the SELinux subjective security when accessing information on behalf of another process.</p>
<p>For example, CacheFiles when accessing the cache on behalf of a process accessing an NFS file needs to use a subjective security ID appropriate to the cache rather than the one the calling process is using. The <em>cachefilesd</em> daemon will nominate the security ID to be used.</p></td>
</tr>
<tr>
<td>create_files_as</td>
<td>Grant a process the right to nominate a file creation label for a kernel service to use.</td>
</tr>
</tbody>
</table>

### `key`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>key</strong> - This is a kernel object to manage Keyrings.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permission</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (7 unique permissions)</td>
</tr>
<tr>
<td>create</td>
<td>Create a keyring.</td>
</tr>
<tr>
<td>link</td>
<td>Link a key into the keyring.</td>
</tr>
<tr>
<td>read</td>
<td>Read a keyring.</td>
</tr>
<tr>
<td>search</td>
<td>Search a keyring.</td>
</tr>
<tr>
<td>setattr</td>
<td>Change permissions on a keyring.</td>
</tr>
<tr>
<td>view</td>
<td>View a keyring.</td>
</tr>
<tr>
<td>write</td>
<td>Add a key to the keyring.</td>
</tr>
</tbody>
</table>

### `memprotect`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>memprotect - </strong>This is a kernel object to protect lower memory blocks.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permission</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (1 unique permission)</td>
</tr>
<tr>
<td>mmap_zero</td>
<td>Security check on mmap operations to see if the user is attempting to mmap to low area of the address space. The amount of space protected is indicated by a proc tunable (<em>/proc/sys/vm/mmap_min_addr</em>). Setting this value to 0 will disable the checks. The "<a href="http://eparis.livejournal.com/891.html">SELinux hardening for mmap_min_addr protections</a>" [13] describes additional checks that will be added to the kernel to protect against some kernel exploits (by requiring <em>CAP_SYS_RAWIO</em> (root) and the SELinux <em>memprotect</em> / <em>mmap_zero</em> permission instead of only one or the other).</td>
</tr>
</tbody>
</table>

### `binder`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>binder</strong></em> - This is a kernel object to manage the Binder IPC service.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permission</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (4 unique permissions)</td>
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

<br>

## Capability Object Classes

### `capability`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>capability</strong> - Used to manage the Linux capabilities granted to root processes.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 32 permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-capability-permissions"><strong>Common Capability Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">audit_write, chown, dac_override, dac_read_search, fowner, fsetid, ipc_lock, ipc_owner, kill, lease, linux_immutable, mknod, net_admin, net_bind_service, net_raw, netbroadcast, setfcap, setgid, setpcap, setuid, sys_admin, sys_boot, sys_chroot, sys_module, sys_nice, sys_pacct, sys_ptrace, sys_rawio, sys_resource, sys_time, sys_tty_config</td>
</tr>
</tbody>
</table>

### `capability2`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">capability2</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-capability2-permissions"><strong>Common Capability2 Permissions<strong></td>
<td style="background-color:#F2F2F2;">audit_read, block_suspend, mac_admin, mac_override, syslog, wake_alarm</td>
</tr>
</tbody>
</table>

### `cap_userns`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>cap_userns</strong> - Used to manage the Linux capabilities granted to namespace processes.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 32 permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-capability-permissions"><strong>Common Capability Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">audit_write, chown, dac_override, dac_read_search, fowner, fsetid, ipc_lock, ipc_owner, kill, lease, linux_immutable, mknod, net_admin, net_bind_service, net_raw, netbroadcast, setfcap, setgid, setpcap, setuid, sys_admin, sys_boot, sys_chroot, sys_module, sys_nice, sys_pacct, sys_ptrace, sys_rawio, sys_resource, sys_time, sys_tty_config</td>
</tr>
</tbody>
</table>

### `cap2_userns`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">cap2_userns – For namespaces.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-capability2-permissions"><strong>Common Capability2 Permissions<strong></td>
<td style="background-color:#F2F2F2;">audit_read, block_suspend, mac_admin, mac_override, syslog, wake_alarm</td>
</tr>
</tbody>
</table>

<br>

## InfiniBand Object Classes

### `infiniband_pkey`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">infiniband_pkey</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (1 unique permission)</td>
</tr>
<tr>
<td>access</td>
<td>Access one or more partition keys based on their subnet.</td>
</tr>
</tbody>
</table>

### `infiniband_endport`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">infiniband_endport</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (1 unique permission)</td>
</tr>
<tr>
<td>manage_subnet</td>
<td>Allow send and receive of subnet management packets on the end port specified by the device name and port.</td>
</tr>
</tbody>
</table>

<br>

**Userspace** Object Classes
=============================

## X Windows Object Classes

These are userspace objects managed by XSELinux.

### `x_drawable`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><p><strong>x_drawable</strong> - The drawable parameter specifies the area into which the text will be drawn. It may be either a pixmap or a window.</p>
<p>Some of the permission information has been extracted from an <a href="http://marc.info/?l=selinux&amp;m=121485496531386&amp;q=raw">email</a> describing them in terms of an MLS system.</p></td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (19 unique permissions)</td>
</tr>
<tr>
<td>add_child</td>
<td>Add new window. Normally SystemLow for MLS systems.</td>
</tr>
<tr>
<td>blend</td>
<td>There are two cases: 1) Allow a non-root window to have a transparent background. 2) The application is redirecting the contents of the window and its sub-windows into a memory buffer when using the Composite extension. Only <em>SystemHigh</em> processes should have the blend permission on the root window.</td>
</tr>
<tr>
<td>create</td>
<td>Create a drawable object. Not applicable to the root windows as it cannot be created.</td>
</tr>
<tr>
<td>destroy</td>
<td>Destroy a drawable object. Not applicable to the root windows as it cannot be destroyed.</td>
</tr>
<tr>
<td>get_property</td>
<td>Read property information. Normally <em>SystemLow</em> for MLS systems.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get attributes from a drawable object. Most applications will need this so SystemLow.</td>
</tr>
<tr>
<td>hide</td>
<td>Hide a drawable object. Not applicable to the root windows as it cannot be hidden.</td>
</tr>
<tr>
<td>list_child</td>
<td>Allows all child window IDs to be returned. From the root window it will show the client that owns the window and their stacking order. If hiding this information is required then processes should be <em>SystemHigh</em>.</td>
</tr>
<tr>
<td>list_property</td>
<td>List property associated with a window. Normally SystemLow for MLS systems.</td>
</tr>
<tr>
<td>manage</td>
<td>Required to create a context, move and resize windows. Not applicable to the root windows as it cannot be resized etc.</td>
</tr>
<tr>
<td>override</td>
<td>Allow setting the <em>override-redirect</em> bit on the window. Not applicable to the root windows as it cannot be overridden.</td>
</tr>
<tr>
<td>read</td>
<td>Read window contents. Note that this will also give read permission to all child windows, therefore (for MLS), only <em>SystemHigh</em> processes should have read permission on the root window.</td>
</tr>
<tr>
<td>receive</td>
<td>Allow receiving of events. Normally <em>SystemLow</em> for MLS systems (but could leak information between clients running at different levels, therefore needs investigation).</td>
</tr>
<tr>
<td>remove_child</td>
<td>Remove child window. Normally <em>SystemLow</em> for MLS systems.</td>
</tr>
<tr>
<td>send</td>
<td>Allow sending of events. Normally <em>SystemLow</em> for MLS systems (but could leak information between clients running at different levels, therefore needs investigation).</td>
</tr>
<tr>
<td>set_property</td>
<td>Set property. Normally SystemLow for MLS systems (but could leak information between clients running at different levels, therefore needs investigation. Polyinstantiation may be required).</td>
</tr>
<tr>
<td>setattr</td>
<td>Allow window attributes to be set. This permission protects operations on the root window such as setting the background image or colour, setting the colormap and setting the mouse cursor to display when the cursor is in nthe window, therefore only <em>SystemHigh</em> processes should have the <em>setattr</em> permission.</td>
</tr>
<tr>
<td>show</td>
<td>Show window. Not applicable to the root windows as it cannot be hidden.</td>
</tr>
<tr>
<td>write</td>
<td>Draw within a window. Note that this will also give write permission to all child windows, therefore (for MLS), only <em>SystemHigh</em> processes should have <em>write</em> permission on the root window.</td>
</tr>
</tbody>
</table>

### `x_screen`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_screen -</strong> The specific screen available to the display (X-server) <em>(hostname:display_number.screen</em>)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (8 unique permissions)</td>
</tr>
<tr>
<td>getattr</td>
<td></td>
</tr>
<tr>
<td>hide_cursor</td>
<td></td>
</tr>
<tr>
<td>saver_getattr</td>
<td></td>
</tr>
<tr>
<td>saver_hide</td>
<td></td>
</tr>
<tr>
<td>saver_setattr</td>
<td></td>
</tr>
<tr>
<td>saver_show</td>
<td></td>
</tr>
<tr>
<td>setattr</td>
<td></td>
</tr>
<tr>
<td>show_cursor</td>
<td></td>
</tr>
</tbody>
</table>

### `x_gc`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_gc - </strong>The graphics contexts allows the X-server to cache information about how graphics requests should be interpreted. It reduces the network traffic.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (5 unique permissions)</td>
</tr>
<tr>
<td>create</td>
<td>Create Graphic Contexts object.</td>
</tr>
<tr>
<td>destroy</td>
<td>Free (dereference) a Graphics Contexts object.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get attributes from Graphic Contexts object.</td>
</tr>
<tr>
<td>setattr</td>
<td>Set attributes for Graphic Contexts object.</td>
</tr>
<tr>
<td>use</td>
<td>Allow GC contexts to be used.</td>
</tr>
</tbody>
</table>

### `x_font`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_font - </strong>An X-server resource for managing the different fonts.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (6 unique permissions)</td>
</tr>
<tr>
<td>add_glyph</td>
<td>Create glyph for cursor</td>
</tr>
<tr>
<td>create</td>
<td>Load a font.</td>
</tr>
<tr>
<td>destroy</td>
<td>Free a font.</td>
</tr>
<tr>
<td>getattr</td>
<td>Obtain font names, path, etc.</td>
</tr>
<tr>
<td>remove_glyph</td>
<td>Free glyph</td>
</tr>
<tr>
<td>use</td>
<td>Use a font.</td>
</tr>
</tbody>
</table>

### `x_colormap`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_colormap - </strong>An X-server resource for managing colour mapping. A new colormap can be created using <em>XCreateColormap</em>.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (10 unique permissions)</td>
</tr>
<tr>
<td>add_color</td>
<td>Add a colour</td>
</tr>
<tr>
<td>create</td>
<td>Create a new Colormap.</td>
</tr>
<tr>
<td>destroy</td>
<td>Free a Colormap.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get the color gamut of a screen.</td>
</tr>
<tr>
<td>install</td>
<td>Copy a virtual colormap into the display hardware.</td>
</tr>
<tr>
<td>read</td>
<td>Read color cells of colormap.</td>
</tr>
<tr>
<td>remove_color</td>
<td>Remove a colour</td>
</tr>
<tr>
<td>uninstall</td>
<td>Remove a virtual colormap from the display hardware.</td>
</tr>
<tr>
<td>use</td>
<td>Use a colormap</td>
</tr>
<tr>
<td>write</td>
<td>Change color cells in colormap.</td>
</tr>
</tbody>
</table>

### `x_property`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_property - </strong>An InterClient Communications (ICC) service where each property has a name and ID (or Atom). Properties are attached to windows and can be uniquely identified by the <em>windowID</em> and <em>propertyID</em>. XSELinux supports polyinstantiation of properties.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (7 unique permissions)</td>
</tr>
<tr>
<td>append</td>
<td>Append a property.</td>
</tr>
<tr>
<td>create</td>
<td>Create property object.</td>
</tr>
<tr>
<td>destroy</td>
<td>Free (dereference) a property object.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get attributes of a property.</td>
</tr>
<tr>
<td>read</td>
<td>Read a property.</td>
</tr>
<tr>
<td>setattr</td>
<td>Set attributes of a property.</td>
</tr>
<tr>
<td>write</td>
<td>Write a property.</td>
</tr>
</tbody>
</table>

### `x_selection`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_selection - </strong>An InterClient Communications (ICC) service that allows two parties to communicate about passing information. The information uses properties to define the the format (e.g. whether text or graphics). XSELinux supports polyinstantiation of selections.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (4 unique permissions)</td>
</tr>
<tr>
<td>getattr</td>
<td>Get selection owner (<em>XGetSelectionOwner</em>).</td>
</tr>
<tr>
<td>read</td>
<td>Read the information from the selection owner</td>
</tr>
<tr>
<td>setattr</td>
<td>Set the selection owner (<em>XSetSelectionOwner</em>).</td>
</tr>
<tr>
<td>write</td>
<td>Send the information to the selection requestor.</td>
</tr>
</tbody>
</table>

### `x_cursor`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_cursor -</strong> The cursor on the screen</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (7 unique permissions)</td>
</tr>
<tr>
<td>create</td>
<td>Create an arbitrary cursor object.</td>
</tr>
<tr>
<td>destroy</td>
<td>Free (dereference) a cursor object.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get attributes of the cursor.</td>
</tr>
<tr>
<td>read</td>
<td>Read the cursor.</td>
</tr>
<tr>
<td>setattr</td>
<td>Set attributes of the cursor.</td>
</tr>
<tr>
<td>use</td>
<td>Associate a cursor object with a window.</td>
</tr>
<tr>
<td>write</td>
<td>Write a cursor</td>
</tr>
</tbody>
</table>

### `x_client`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_client - </strong>The X-client connecting to the X-server.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (4 unique permissions)</td>
</tr>
<tr>
<td>destroy</td>
<td>Close down a client.</td>
</tr>
<tr>
<td>getattr</td>
<td>Get attributes of X-client.</td>
</tr>
<tr>
<td>manage</td>
<td>Required to create an X-client context. (source code)</td>
</tr>
<tr>
<td>setattr</td>
<td>Set attributes of X-client.</td>
</tr>
</tbody>
</table>

### `x_device`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>x_device</strong></em> - These are any other devices used by the X-server as the keyboard and pointer devices have their own object classes.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 19 common <em>x_device</em> permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-x_device-permissions"><strong>Inherit Common X__Device Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">add, bell, create, destroy, force_cursor, freeze, get_property, getattr, getfocus, grab, list_property, manage, read, remove, set_property, setattr, setfocus, use, write</td>
</tr>
</tbody>
</table>

### `x_server`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_server - </strong>The X-server that manages the display, keyboard and pointer.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (6 unique permissions)</td>
</tr>
<tr>
<td>debug</td>
<td></td>
</tr>
<tr>
<td>getattr</td>
<td></td>
</tr>
<tr>
<td>grab</td>
<td></td>
</tr>
<tr>
<td>manage</td>
<td>Required to create a context. (source code)</td>
</tr>
<tr>
<td>record</td>
<td></td>
</tr>
<tr>
<td>setattr</td>
<td></td>
</tr>
</tbody>
</table>

### `x_extension`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_extension -</strong> An X-Windows extension that can be added to the X-server (such as the XSELinux object manager itself).</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>query</td>
<td>Query for an extension.</td>
</tr>
<tr>
<td>use</td>
<td>Use the extensions services.</td>
</tr>
</tbody>
</table>

### `x_resource`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_resource - </strong>These consist of Windows, Pixmaps, Fonts, Colormaps etc. that are classed as resources.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>read</td>
<td>Allow reading a resource.</td>
</tr>
<tr>
<td>write</td>
<td>Allow writing to a resource.</td>
</tr>
</tbody>
</table>

### `x_event`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_event -</strong> Manage X-server events.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>receive</td>
<td>Receive an event</td>
</tr>
<tr>
<td>send</td>
<td>Send an event</td>
</tr>
</tbody>
</table>

### `x_synthetic_event`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_synthetic_event -</strong> Manage some X-server events (e.g. <em>confignotify</em>). Note the <em>x_event</em> permissions will still be required (its magic).</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>receive</td>
<td>Receive an event</td>
</tr>
<tr>
<td>send</td>
<td>Send an event</td>
</tr>
</tbody>
</table>

### `x_application_data`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>x_application_data -</strong> Not specifically used by XSELinux, however is used by userspace applications that need to manage copy and paste services (such as the <em>CUT_BUFFER</em>s).</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permission</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (3 unique permissions)</td>
</tr>
<tr>
<td>copy</td>
<td>Copy the data</td>
</tr>
<tr>
<td>paste</td>
<td>Paste the data</td>
</tr>
<tr>
<td>paste_after_confirm</td>
<td>Need to confirm that the paste is allowed.</td>
</tr>
</tbody>
</table>

### `x_pointer`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>x_pointer</strong></em> - The mouse or other pointing device managed by the X-server.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 19 common <em>x_device</em> permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-x_device-permissions"><strong>Inherit Common X__Device Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">add, bell, create, destroy, force_cursor, freeze, get_property, getattr, getfocus, grab, list_property, manage, read, remove, set_property, setattr, setfocus, use, write</td>
</tr>
</tbody>
</table>

### `x_keyboard`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><em><strong>x_keyboard</strong></em> - The keyboard managed by the X-server.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description </strong>(Inherit 19 common <em>x_device</em> permissions)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-x_device-permissions"><strong>Inherit Common X__Device Permissions</strong></a></td>
<td style="background-color:#F2F2F2;">add, bell, create, destroy, force_cursor, freeze, get_property, getattr, getfocus, grab, list_property, manage, read, remove, set_property, setattr, setfocus, use, write</td>
</tr>
</tbody>
</table>

<br>

## Database Object Classes

These are userspace objects - The PostgreSQL database supports these
with their SE-PostgreSQL database extension. The
"[**Security-Enhanced PostgreSQL Security Wiki**](http://wiki.postgresql.org/wiki/SEPostgreSQL_Development)"
explains the objects, their permissions and how they should be used in detail.

### `db_database`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_database</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 3 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>access</td>
<td>Required to connect to the database - this is the minimum permission required by an SE-PostgreSQL client.</td>
</tr>
<tr>
<td>install_module</td>
<td>Required to install a dynmic link library.</td>
</tr>
<tr>
<td>load_module</td>
<td>Required to load a dynmic link library.</td>
</tr>
</tbody>
</table>

### `db_table`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_table</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 5 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>delete</td>
<td>Required to delete from a table with a DELETE statement, or when removing the table contents with a TRUNCATE statement.</td>
</tr>
<tr>
<td>insert</td>
<td>Required to insert into a table with an INSERT statement, or when restoring it with a COPY FROM statement.</td>
</tr>
<tr>
<td>lock</td>
<td>Required to get a table lock with a LOCK statement.</td>
</tr>
<tr>
<td>select</td>
<td>Required to refer to a table with a SELECT statement or to dump the table contents with a COPY TO statement.</td>
</tr>
<tr>
<td>update</td>
<td>Required to update a table with an UPDATE statement.</td>
</tr>
</tbody>
</table>

### `db_schema`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_schema</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 3 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>search</td>
<td>Search for an object in the schema.</td>
</tr>
<tr>
<td>add_name</td>
<td>Add an object to the schema.</td>
</tr>
<tr>
<td>remove_name</td>
<td>Remove an object from the schema.</td>
</tr>
</tbody>
</table>

### `db_procedure`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_procedure</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 3 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>entrypoint</td>
<td>Required for any functions defined as Trusted Procedures.</td>
</tr>
<tr>
<td>execute</td>
<td>Required for functions executed with SQL queries.</td>
</tr>
<tr>
<td>install</td>
<td></td>
</tr>
</tbody>
</table>

### `db_column`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_column</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 3 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>insert</td>
<td>Required to insert a new entry using the INSERT statement.</td>
</tr>
<tr>
<td>select</td>
<td>Required to reference columns.</td>
</tr>
<tr>
<td>update</td>
<td>Required to update a table with an UPDATE statement.</td>
</tr>
</tbody>
</table>

### `db_tuple`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_tuple</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (7 unique)</td>
</tr>
<tr>
<td>delete</td>
<td>Required to delete entries with a DELETE or TRUNCATE statement.</td>
</tr>
<tr>
<td>insert</td>
<td>Required when inserting a entry with an INSERT statement, or restoring tables with a COPY FROM statement.</td>
</tr>
<tr>
<td>relabelfrom</td>
<td>The security context of an entry can be changed with an UPDATE to the security_context column at which time relabelfrom and relabelto permission is evaluated. The client must have relabelfrom permission to the security context before the entry is changed, and relabelto permission to the security context after the entry is changed.</td>
</tr>
<tr>
<td>relabelto</td>
<td></td>
</tr>
<tr>
<td>select</td>
<td><p>Required when: reading entries with a SELECT statement, returning entries that are subjects for updating queries with a RETURNING clause, or dumping tables with a COPY TO statement.</p>
<p>Entries that the client does not have select permission on will be filtered from the result set.</p></td>
</tr>
<tr>
<td>update</td>
<td>Required when updating an entry with an UPDATE statement. Entries that the client does not have update permission on will not be updated.</td>
</tr>
<tr>
<td>use</td>
<td>Controls usage of system objects that require permission to "use" objects such as data types, tablespaces and operators.</td>
</tr>
</tbody>
</table>

### `db_blob`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_blob</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permission</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 4 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>export</td>
<td>Export a binary large object by calling the lo_export() function.</td>
</tr>
<tr>
<td>import</td>
<td>Import a file as a binary large object by calling the lo_import() function.</td>
</tr>
<tr>
<td>read</td>
<td>Read a binary large object the loread() function.</td>
</tr>
<tr>
<td>write</td>
<td>Write a binary large objecty with the lowrite() function. </td>
</tr>
</tbody>
</table>

### `db_view`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_view</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 1 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>expand</td>
<td>Allows the expansion of a 'view'.</td>
</tr>
</tbody>
</table>

### `db_sequence`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_sequence - A sequential number generator</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 3 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>get_value</td>
<td>Get a value from the sequence generator object.</td>
</tr>
<tr>
<td>next_value</td>
<td>Get and increment value.</td>
</tr>
<tr>
<td>set_value</td>
<td>Set an arbitrary value.</td>
</tr>
</tbody>
</table>

### `db_language`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;">db_language - Support for script languages such as Perl and Tcl for SQL Procedures</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (Inherit 6 common database permissions + 2 unique)</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><a href="#common-database-permissions"><strong>Inherit Common Database Permissions</strong></td>
<td style="background-color:#F2F2F2;">create, drop, getattr, relabelfrom, relabelto, setattr</td>
</tr>
<tr>
<td>implement</td>
<td>Whether the language can be implemented or not for the SQL procedure.</td>
</tr>
<tr>
<td>execute</td>
<td>Allow the execution of a code block using a '<em>DO</em>' statement.</td>
</tr>
</tbody>
</table>

<br>

## Miscellaneous Userspace Object Classes

### `passwd`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>passwd - </strong>This is a userspace object for controlling changes to passwd information.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (5 unique permissions)</td>
</tr>
<tr>
<td>chfn</td>
<td>Change another users finger info.</td>
</tr>
<tr>
<td>chsh</td>
<td>Change another users shell.</td>
</tr>
<tr>
<td>crontab</td>
<td>crontab another user.</td>
</tr>
<tr>
<td>passwd</td>
<td>Change another users passwd.</td>
</tr>
<tr>
<td>rootok</td>
<td>pam_rootok check - skip authentication.</td>
</tr>
</tbody>
</table>

### `nscd`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>nscd - </strong>This is a userspace object for the Name Service Cache Daemon.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (12 unique permissions)</td>
</tr>
<tr>
<td>admin</td>
<td>Allow the nscd daemon to be shut down.</td>
</tr>
<tr>
<td>getgrp</td>
<td>Get group information.</td>
</tr>
<tr>
<td>gethost</td>
<td>Get host information.</td>
</tr>
<tr>
<td>getnetgrp</td>
<td></td>
</tr>
<tr>
<td>getpwd</td>
<td>Get password information.</td>
</tr>
<tr>
<td>getserv</td>
<td>Get ?? information.</td>
</tr>
<tr>
<td>getstat</td>
<td>Get the AVC stats from the nscd daemon.</td>
</tr>
<tr>
<td>shmemgrp</td>
<td>Get shmem group file descriptor.</td>
</tr>
<tr>
<td>shmemhost</td>
<td>Get shmem host descriptor. ??</td>
</tr>
<tr>
<td>shmemnetgrp</td>
<td></td>
</tr>
<tr>
<td>shmempwd</td>
<td></td>
</tr>
<tr>
<td>shmemserv</td>
<td></td>
</tr>
</tbody>
</table>

### `dbus`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>dbus - </strong>This is a userspace object for the D-BUS Messaging service that is required to run various services.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>acquire_svc</td>
<td>Open a virtual circuit (communications channel).</td>
</tr>
<tr>
<td>send_msg</td>
<td>Send a message.</td>
</tr>
</tbody>
</table>

### `context`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>context</strong> - This is a userspace object for the translation daemon mcstransd. These permissions are required to allow translation and querying of level and ranges for MCS and MLS systems.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (2 unique permissions)</td>
</tr>
<tr>
<td>contains</td>
<td>Calculate a MLS/MCS subset - Required to check what the configuration file contains.</td>
</tr>
<tr>
<td>translate</td>
<td>Translate a raw MLS/MCS label - Required to allow a domain to translate contexts.</td>
</tr>
</tbody>
</table>

### `service`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>service</strong> - This is a userspace object to manage <em>systemd</em> services.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (8 unique permissions)</td>
</tr>
<tr>
<td>disable</td>
<td>Disable services.</td>
</tr>
<tr>
<td>enable</td>
<td>Enable services.</td>
</tr>
<tr>
<td>kill</td>
<td>Kill services.</td>
</tr>
<tr>
<td>load</td>
<td>Load services</td>
</tr>
<tr>
<td>reload</td>
<td>Restart systemd services.</td>
</tr>
<tr>
<td>start</td>
<td>Start systemd services.</td>
</tr>
<tr>
<td>status</td>
<td>Read service status.</td>
</tr>
<tr>
<td>stop</td>
<td>Stop systemd services.</td>
</tr>
</tbody>
</table>

### `proxy`

<table>
<tbody>
<tr>
<td style="background-color:#F2F2F2;"><strong>Class</strong></td>
<td style="background-color:#F2F2F2;"><strong>proxy</strong> - This is a userspace object for <em>gssd</em> services.</td>
</tr>
<tr>
<td style="background-color:#F2F2F2;"><strong>Permissions</strong></td>
<td style="background-color:#F2F2F2;"><strong>Description</strong> (1 unique permission)</td>
</tr>
<tr>
<td>read</td>
<td>Read credentials.</td>
</tr>
</tbody>
</table>


<br>

<!-- %CUTHERE% -->

---
**[[ PREV ]](seandroid.md)** **[[ TOP ]](#)** **[[ NEXT ]](libselinux_functions.md)**
