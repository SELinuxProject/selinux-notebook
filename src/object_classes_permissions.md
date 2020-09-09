# Appendix A - Object Classes and Permissions

- [Introduction](#introduction)
  - [Defining Object Classes and Permissions](#defining-object-classes-and-permissions)
- [Kernel Object Classes and Permissions](#kernel-object-classes-and-permissions)
  - [Common Permissions](#common-permissions)
    - [Common File Permissions](#common-file-permissions)
    - [Common Socket Permissions](#common-socket-permissions)
    - [Common IPC Permissions](#common-ipc-permissions)
    - [Common Capability Permissions](#common-capability-permissions)
    - [Common Capability2 Permissions](#common-capability2-permissions)
    - [Common Database Permissions](#common-database-permissions)
    - [Common X_Device Permissions](#common-x_device-permissions)
  - [File Object Classes](#file-object-classes)
    - [*filesystem*](#filesystem)
    - [*dir*](#dir)
    - [*file*](#file)
    - [*lnk_file*](#lnk_file)
    - [*chr_file*](#chr_file)
    - [*blk_file*](#blk_file)
    - [*sock_file*](#sock_file)
    - [*fifo_file*](#fifo_file)
    - [*fd*](#fd)
  - [Network Object Classes](#network-object-classes)
    - [*node*](#node)
    - [*netif*](#netif)
    - [*socket*](#socket)
    - [*tcp_socket*](#tcp_socket)
    - [*udp_socket*](#udp_socket)
    - [*rawip_socket*](#rawip_socket)
    - [*packet_socket*](#packet_socket)
    - [*unix_stream_socket*](#unix_stream_socket)
    - [*unix_dgram_socket*](#unix_dgram_socket)
    - [*tun_socket*](#tun_socket)
  - [IPSec Network Object Classes](#ipsec-network-object-classes)
    - [*association*](#association)
    - [*key_socket*](#key_socket)
    - [*netlink_xfrm_socket*](#netlink_xfrm_socket)
  - [Netlink Object Classes](#netlink-object-classes)
    - [*netlink_socket*](#netlink_socket)
    - [*netlink_route_socket*](#netlink_route_socket)
    - [*netlink_firewall_socket* (Deprecated)](#netlink_firewall_socket-deprecated)
    - [*netlink_tcpdiag_socket*](#netlink_tcpdiag_socket)
    - [*netlink_nflog_socket*](#netlink_nflog_socket)
    - [*netlink_selinux_socket*](#netlink_selinux_socket)
    - [*netlink_audit_socket*](#netlink_audit_socket)
    - [*netlink_ip6fw_socket* (Deprecated)](#netlink_ip6fw_socket-deprecated)
    - [*netlink_dnrt_socket*](#netlink_dnrt_socket)
    - [*netlink_kobject_uevent_socket*](#netlink_kobject_uevent_socket)
    - [*netlink_iscsi_socket*](#netlink_iscsi_socket)
    - [*netlink_fib_lookup_socket*](#netlink_fib_lookup_socket)
    - [*netlink_connector_socket*](#netlink_connector_socket)
    - [*netlink_netfilter_socket*](#netlink_netfilter_socket)
    - [*netlink_generic_socket*](#netlink_generic_socket)
    - [*netlink_scsitransport_socket*](#netlink_scsitransport_socket)
    - [*netlink_rdma_socket*](#netlink_rdma_socket)
    - [*netlink_crypto_socket*](#netlink_crypto_socket)
  - [Miscellaneous Network Object Classes](#miscellaneous-network-object-classes)
    - [*peer*](#peer)
    - [*packet*](#packet)
    - [*appletalk_socket*](#appletalk_socket)
    - [*dccp_socket*](#dccp_socket)
  - [Sockets via *extended_socket_class*](#sockets-via-extended_socket_class)
    - [*sctp_socket*](#sctp_socket)
    - [*icmp_socket*](#icmp_socket)
    - [Miscellaneous Extended Socket Classes](#miscellaneous-extended-socket-classes)
  - [BPF Object Class](#bpf-object-class)
    - [*bpf*](#bpf)
  - [Performance Event Object Class](#performance-event-object-class)
    - [*perf_event*](#perf_event)
  - [Lockdown Object Class](#lockdown-object-class)
    - [*lockdown*](#lockdown)
  - [IPC Object Classes](#ipc-object-classes)
    - [*ipc* (Deprecated)](#ipc-deprecated)
    - [*sem*](#sem)
    - [*msgq*](#msgq)
    - [*msg*](#msg)
    - [*shm*](#shm)
  - [Process Object Class](#process-object-class)
    - [*process*](#process)
    - [*process2*](#process2)
  - [Security Object Class](#security-object-class)
    - [*security*](#security)
  - [System Operation Object Class](#system-operation-object-class)
    - [*system*](#system)
  - [Miscellaneous Kernel Object Classes](#miscellaneous-kernel-object-classes)
    - [*kernel_service*](#kernel_service)
    - [*key*](#key)
    - [*memprotect*](#memprotect)
    - [*binder*](#binder)
  - [Capability Object Classes](#capability-object-classes)
    - [*capability*](#capability)
    - [*capability2*](#capability2)
    - [*cap_userns*](#cap_userns)
    - [*cap2_userns*](#cap2_userns)
  - [InfiniBand Object Classes](#infiniband-object-classes)
    - [*infiniband_pkey*](#infiniband_pkey)
    - [*infiniband_endport*](#infiniband_endport)
- [Userspace Object Classes](#userspace-object-classes)
  - [X Windows Object Classes](#x-windows-object-classes)
    - [*x_drawable*](#x_drawable)
    - [*x_screen*](#x_screen)
    - [*x_gc*](#x_gc)
    - [*x_font*](#x_font)
    - [*x_colormap*](#x_colormap)
    - [*x_property*](#x_property)
    - [*x_selection*](#x_selection)
    - [*x_cursor*](#x_cursor)
    - [*x_client*](#x_client)
    - [*x_device*](#x_device)
    - [*x_server*](#x_server)
    - [*x_extension*](#x_extension)
    - [*x_resource*](#x_resource)
    - [*x_event*](#x_event)
    - [*x_synthetic_event*](#x_synthetic_event)
    - [*x_application_data*](#x_application_data)
    - [*x_pointer*](#x_pointer)
    - [*x_keyboard*](#x_keyboard)
  - [Database Object Classes](#database-object-classes)
    - [*db_database*](#db_database)
    - [*db_table*](#db_table)
    - [*db_schema*](#db_schema)
    - [*db_procedure*](#db_procedure)
    - [*db_column*](#db_column)
    - [*db_tuple*](#db_tuple)
    - [*db_blob*](#db_blob)
    - [*db_view*](#db_view)
    - [*db_sequence*](#db_sequence)
    - [*db_language*](#db_language)
  - [Miscellaneous Userspace Object Classes](#miscellaneous-userspace-object-classes)
    - [*passwd*](#passwd)
    - [*nscd*](#nscd)
    - [*dbus*](#dbus)
    - [*context*](#context)
    - [*service*](#service)
    - [*proxy*](#proxy)

## Introduction

This section contains a list of object classes and their associated
permissions that have been taken from the Fedora policy sources. There
are also additional entries for Xen. The Android specific classes and
permissions are shown in the
[**Security Enhancements for Android**](seandroid.md#security-enhancements-for-android)
section.

The SElinux Testsuite has tests that exercise a number of these object
classes/permissions and is a useful reference:
[**https://github.com/SELinuxProject/selinux-testsuite**](https://github.com/SELinuxProject/selinux-testsuite)

In most cases the permissions are self explanatory as they are those
used in the standard Linux function calls (such as 'create a socket' or
'write to a file'). Some SELinux specific permissions are:

*relabelfrom*

- Used on most objects to allow the objects security context to be changed from
  the current type.

*relabelto*

- Used on most objects to allow the objects security context to be changed to
  the new type.

*entrypoint*

- Used for files to indicate that they can be used as an entry point into a
  domain via a domain transition.

*execute_no_trans*

- Used for files to indicate that they can be used as an entry point into the
  calling domain (i.e. does not require a domain transition).

*execmod*

- Generally used for files to indicate that they can execute the modified file
  in memory.

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
then set the *handle_unknown* flag when building the policy to *allow*
(***checkpolicy**(8)* and ***secilc**(8)*
*[-U handle-unknown (allow,deny,reject)]*). However:
- CIL requires at least one class to be defined.
- The *process* class with its *transition* and *dyntransition* permissions
  are still required for default labeling behaviors, role and range
  transitions in older policy versions.

The [**Object Class and Permission Statements**](class_permission_statements.md#object-class-and-permission-statements)
section specifies how these are defined within the Kernel Policy Language,
and the
[**CIL Reference Guide**](./notebook-examples/selinux-policy/cil/CIL_Reference_Guide.pdf)
specifies the CIL Policy Language.

# Kernel Object Classes and Permissions

## Common Permissions

### Common File Permissions

The following table describes the common *file* permissions that are
inherited by a number of object classes.

**Permissions** - 25 permissions:

*append*

- Append to file.

*audit_access*

- The rules for this permission work as follows:
  - If a process calls *access()* or *faccessat()* and SELinux denies their
    request there will be a check for a *dontaudit* rule on the *audit_access*
    permission.
  - If there is a *dontaudit* rule on *audit_access* an AVC event will not be
    written.
  - If there is no *dontaudit* rule an AVC event will be written for the
    permissions requested (*read*, *write*, or *exec*).
- Notes:
  1. There will never be a denial message with the *audit_access*
     permission as this permission does not control security decisions.
  2. *allow* and *auditallow* rules with this permission are therefore
     meaningless, however the kernel will accept a policy with such rules,
     but they will do nothing.

*create*

- Create new file.

*execute*

- Execute the file with domain transition.

*execmod*

- Make executable a file that has been modified by copy-on-write.

*getattr*

- Get file attributes.

*ioctl*

- I/O control system call requests.

*link*

- Create hard link.

*lock*

- Set and unset file locks.

*map*

- Allow a file to be memory mapped via ***mmap**(2)*.

*mounton*

- Use as mount point.

*open*

- Added in 2.6.26 Kernel to control the open permission.

*quotaon*

- Enable quotas.

*read*

- Read file contents.

*relabelfrom*

- Change the security context based on existing type.

*relabelto*

- Change the security context based on the new type.

*rename*

- Rename file.

*setattr*

- Change file attributes.

*unlink*

- Delete file (or remove hard link).

*watch*

- Watch for file changes.

*watch_mount*

- Watch for mount changes.

*watch_sb*

- Watch for superblock changes.

*watch_with_perm*

- Allow ***fanotify**(7)* masks.

*watch_reads*

- Required to receive notifications from read-exclusive events.

*write*

- Write or append file contents.

### Common Socket Permissions

The following table describes the common socket permissions that
are inherited by a number of object classes.

**Permissions** - 21 Permissions:

*accept*

- Accept a connection.

*append*

- Write or append socket content.

*bind*

- Bind to a name.

*connect*

- Initiate a connection.

*create*

- Create new socket.

*getattr*

- Get socket information.

*getopt*

- Get socket options.

*ioctl*

- Get and set attributes via ioctl call requests.

*listen*

- Listen for connections.

*lock*

- Lock and unlock socket file descriptor.

*map*

- Allow a file to be memory mapped via ***mmap**(2)*.

*name_bind*

- *AF_INET* - Controls relationship between a socket and the port number.
- *AF_UNIX* - Controls relationship between a socket and the file.

*read*

- Read data from socket.

*recvfrom*

- Receive datagrams from socket.

*relabelfrom*

- Change the security context based on existing type.

*relabelto*

- Change the security context based on the new type.

*sendto*

- Send datagrams to socket.

*setattr*

- Change attributes.

*setopt*

- Set socket options.

*shutdown*

- Terminate connection.

*write*

- Write data to socket.

### Common IPC Permissions

The following table describes the common IPC permissions that are
inherited by a number of object classes.

**Permissions** - 9 Permissions:

*associate*

- shm  - Get shared memory ID.
- msgq - Get message ID.
- sem  - Get semaphore ID.

*create*

- Create.

*destroy*

- Destroy.

*getattr*

- Get information from IPC object.

*read*

- shm  - Attach shared memory to process.
- msgq - Read message from queue.
- sem  - Get semaphore value.

*setattr*

- Set IPC object information.

*unix_read*

- Read.

*unix_write*

- Write or append.

*write*

- shm  - Attach shared memory to process.
- msgq - Send message to message queue.
- sem  - Change semaphore value.

### Common Capability Permissions

**Permission** - 32 permissions - Text from */usr/include/linux/capability.h*

*audit_control*

- Change auditing rules. Set login UID.

*audit_write*

- Send audit messages from user space.

*chown*

- Allow changing file and group ownership.

*dac_override*

- Overrides all DAC including ACL execute access.

*dac_read_search*

- Overrides DAC for read and directory search.

*fowner*

- Grant all file operations otherwise restricted due to different ownership
  except where *FSETID* capability is applicable. DAC and MAC accesses are not
  overridden.

*fsetid*

- Overrides the restriction that the real or effective user ID of a process
  sending a signal must match the real or effective user ID of the process
  receiving the signal.

*ipc_lock*

- Grants the capability to lock non-shared and shared memory segments.

*ipc_owner*

- Grant the ability to ignore IPC ownership checks.

*kill*

- Allow signal raising for any process.

*lease*

- Grants ability to take leases on a file.

*linux_immutable*

- Grant privilege to modify *S_IMMUTABLE* and *S_APPEND* file attributes on
  supporting filesystems.

*mknod*

- Grants permission to creation of character and block device nodes.

*net_admin*

- Allow the following: interface configuration; administration of IP firewall;
  masquerading and accounting; setting debug option on sockets; modification of
  routing tables; setting arbitrary process / group ownership on sockets;
  binding to any address for transparent proxying; setting TOS (type of service);
  setting promiscuous mode; clearing driver statistics; multicasting; read/write
  of device-specific registers; activation of ATM control sockets.

*net_bind_service*

- Allow low port binding. Port \< 1024 for TCP/UDP. VCI \< 32 for ATM.

*net_raw*

- Allows opening of raw sockets and packet sockets.

*net_broadcast*

- Grant network broadcasting and listening to incoming multicasts.

*setfcap*

- Allow the assignment of file capabilities.

*setgid*

- Allow ***setgid**(2)* allow ***setgroups**(2)* allow fake *gids* on
  credentials passed over a socket.

*setpcap*

- Transfer capability maps from current process to any process.

*setuid*

- Allow all ***setsuid**(2)* type calls including fsuid. Allow passing of forged
  pids on credentials passed over a socket.

*sys_admin*

- Allow the following: configuration of the secure attention key;
  administration of the random device; examination and configuration of disk
  quotas; configuring the kernel's syslog; setting the domainname; setting
  the hostname; calling bdflush(); mount() and umount(), setting up new smb
  connection; some autofs root ioctls; nfsservctl; VM86_REQUEST_IRQ; to
  read/write pci config on alpha; irix_prctl on mips (setstacksize); flushing
  all cache on m68k (sys_cacheflush); removing semaphores; locking/unlocking of
  shared memory segment; turning swap on/off; forged pids on socket credentials
  passing; setting readahead and flushing buffers on block devices; setting
  geometry in floppy driver; turning DMA on/off in xd driver; administration
  of md devices; tuning the ide driver; access to the nvram device;
  administration of apm_bios, serial and bttv (TV) device; manufacturer
  commands in isdn CAPI support driver; reading non-standardized portions of
  pci configuration space; DDI debug ioctl on sbpcd driver; setting up serial
  ports; sending raw qic-117 commands; enabling/disabling tagged queuing on
  SCSI controllers and sending arbitrary SCSI commands; setting encryption key
  on loopback filesystem; setting zone reclaim policy.

*sys_boot*

- Grant ability to reboot the system.

*sys_chroot*

- Grant use of the ***chroot**(2)* call.

*sys_module*

- Allow unrestricted kernel modification including but not limited to loading
  and removing kernel modules. Allows modification of kernel's bounding
  capability mask. See sysctl.

*sys_nice*

- Grants privilege to change priority of any process. Grants change of
  scheduling algorithm used by any process.

*sys_pacct*

- Allow modification of accounting for any process.

*sys_ptrace*

- Allow ptrace of any process.

*sys_rawio*

- Grant permission to use ***ioperm**(2)* and ***iopl**(2)* as well as the
  ability to send messages to USB devices via */proc/bus/usb*.

*sys_resource*

- Override the following: resource limits; quota limits; reserved space on
  ext2 filesystem; size restrictions on IPC message queues; max number of
  consoles on console allocation; max number of keymaps.
- Set resource limits.
- Modify data journaling mode on ext3 filesystem.
- Allow more than 64hz interrupts from the real-time clock.

*sys_time*

- Grant permission to set system time and to set the real-time lock.

*sys_tty_config*

- Grant permission to configure tty devices.

### Common Capability2 Permissions

**Permissions** - 8 permissions:

*audit_read*

- Allow reading audits logs.

*bpf*

- Create maps, do other *sys_bpf()* commands and load *SK_REUSEPORT* progs.
  Note that loading tracing programs also requires *CAP_PERFMON* and that
  loading networking programs also requires *CAP_NET_ADMIN*.

*block_suspend*

- Prevent system suspends (was *epollwakeup*)

*mac_admin*

- Allow MAC configuration state changes. For SELinux allow contexts not
  defined in the policy to be assigned. This is called 'deferred mapping of
  security contexts' and is explained at:
  <http://marc.info/?l=selinux&amp;m=121017988131629&amp;w=2>

*mac_override*

- Allow MAC policy to be overridden (not used).

*perfmon*

- Allow system performance monitoring and observability operations.

*syslog*

- Allow configuration of kernel *syslog* (*printk()* behaviour).

*wake_alarm*

- Trigger the system to wake up.

### Common Database Permissions

The following table describes the common database permissions that
are inherited by the database object classes. The
[**Security-Enhanced PostgreSQL Security Wiki**](http://wiki.postgresql.org/wiki/SEPostgreSQL_Development)
explains the objects, their permissions and how they should be used in detail.

**Permissions** - 6 Permissions:

*create*

- Create a database object such as a *TABLE*.

*drop*

- Delete (*DROP*) a database object.

*getattr*

- Get metadata - needed to reference an object (e.g. *SELECT ... FROM ...*).

*relabelfrom*

- Change the security context based on existing type.

*relabelto*

- Change the security context based on the new type.

*setattr*

- Set metadata - this permission is required to update information in the
  database (e.g. *ALTER ...*).

### Common X_Device Permissions

The following table describes the common *x_device* permissions that are
inherited by the X-Windows *x_keyboard* and *x_pointer* object classes.

**Permissions** - 19 permissions:

*add*

- Unused.

*bell*

- Unused.

*create*

- Unused.

*destroy*

- Unused.

*force_cursor*

- Get window focus.

*freeze*

- Unused.

*get_property*

- Required to create a device context (source code).

*getattr*

- Unused.

*getfocus*

- Unused.

*grab*

- Set window focus.

*list_property*

- Unused.

*manage*

- Unused.

*read*

- Unused.

*remove*

- Unused.

*set_property*

- Unused.

*setattr*

- TBC

*setfocus*

- Unused.

*use*

- Unused.

*write*

- Unused.

## File Object Classes

### *filesystem*

A mounted *filesystem*

**Permissions** - 10 unique permissions:

*associate*

- Use type as label for file.

*getattr*

- Get file attributes.

*mount*

- Mount filesystem.

*quotaget*

- Get quota information.

*quotamod*

- Modify quota information.

*relabelfrom*

- Change the security context based on existing type.

*relabelto*

- Change the security context based on the new type.

*remount*

- Remount existing mount.

*unmount*

- Unmount filesystem.

*watch*

- Watch for filesystem changes.

### *dir*

A Directory

**Permissions** - Inherit 25
[**Common File Permissions**](#common-file-permissions) + 5 unique:

- *append*, *audit_access*, *create*, *execute*, *execmod*, *getattr*, *ioctl*,
  *link*, *lock*, *map*, *mounton*, *open*, *quotaon*, *read*, *relabelfrom*,
  *relabelto*, *rename*, *setattr*, *unlink*, *watch*, *watch_mount*,
  *watch_sb*, *watch_with_perm*, *watch_reads*, *write*

*add_name*

- Add entry to the directory.

*remove_name*

- Remove an entry from the directory.

*reparent*

- Change parent directory.

*rmdir*

- Remove directory.

*search*

- Search directory.

### *file*

Ordinary file

**Permissions** - Inherit 25
[**Common File Permissions**](#common-file-permissions) + 2 unique:

- *append*, *audit_access*, *create*, *execute*, *execmod*, *getattr*, *ioctl*,
  *link*, *lock*, *map*, *mounton*, *open*, *quotaon*, *read*, *relabelfrom*,
  *relabelto*, *rename*, *setattr*, *unlink*, *watch*, *watch_mount*,
  *watch_sb*, *watch_with_perm*, *watch_reads*, *write*

*entrypoint*

- Entry point permission for a domain transition.

*execute_no_trans*

- Execute in the caller's domain (i.e. no domain transition).

### *lnk_file*

Symbolic links

**Permissions** - Inherit 25
[**Common File Permissions**](#common-file-permissions):

- *append*, *audit_access*, *create*, *execute*, *execmod*, *getattr*, *ioctl*,
  *link*, *lock*, *map*, *mounton*, *open*, *quotaon*, *read*, *relabelfrom*,
  *relabelto*, *rename*, *setattr*, *unlink*, *watch*, *watch_mount*,
  *watch_sb*, *watch_with_perm*, *watch_reads*, *write*

### *chr_file*

Character files

**Permissions** - Inherit 25
[**Common File Permissions**](#common-file-permissions):

- *append*, *audit_access*, *create*, *execute*, *execmod*, *getattr*, *ioctl*,
  *link*, *lock*, *map*, *mounton*, *open*, *quotaon*, *read*, *relabelfrom*,
  *relabelto*, *rename*, *setattr*, *unlink*, *watch*, *watch_mount*,
  *watch_sb*, *watch_with_perm*, *watch_reads*, *write*

### *blk_file*

Block files

**Permissions** - Inherit 25
[**Common File Permissions**](#common-file-permissions):

- *append*, *audit_access*, *create*, *execute*, *execmod*, *getattr*, *ioctl*,
  *link*, *lock*, *map*, *mounton*, *open*, *quotaon*, *read*, *relabelfrom*,
  *relabelto*, *rename*, *setattr*, *unlink*, *watch*, *watch_mount*,
  *watch_sb*, *watch_with_perm*, *watch_reads*, *write*

### *sock_file*

UNIX domain sockets

**Permissions** - Inherit 25
[**Common File Permissions**](#common-file-permissions):

- *append*, *audit_access*, *create*, *execute*, *execmod*, *getattr*, *ioctl*,
  *link*, *lock*, *map*, *mounton*, *open*, *quotaon*, *read*, *relabelfrom*,
  *relabelto*, *rename*, *setattr*, *unlink*, *watch*, *watch_mount*,
  *watch_sb*, *watch_with_perm*, *watch_reads*, *write*

### *fifo_file*

Named pipes

**Permissions** - Inherit 25
[**Common File Permissions**](#common-file-permissions):

- *append*, *audit_access*, *create*, *execute*, *execmod*, *getattr*, *ioctl*,
  *link*, *lock*, *map*, *mounton*, *open*, *quotaon*, *read*, *relabelfrom*,
  *relabelto*, *rename*, *setattr*, *unlink*, *watch*, *watch_mount*,
  *watch_sb*, *watch_with_perm*, *watch_reads*, *write*

### *fd*

File descriptors

**Permissions** - 1 unique permission:

*use*

- Inherit *fd* when process is executed and domain has been changed.
- Receive *fd* from another process by Unix domain socket.
- Get and set attribute of *fd*.

## Network Object Classes

### *node*

IP address or range of IP addresses, used when peer labeling is configured.

**Permissions** - 2 unique permissions:

*recvfrom*

- Network interface and address check permission for use with the *ingress*
  permission.

*sendto*

- Network interface and address check permission for use with the *egress*
  permission.

### *netif*

Network Interface (e.g. eth0) used when peer labeling is configured.

**Permissions** - 2 unique permissions:

*egress*

- Each packet leaving the system must pass an *egress* access control. Also
  requires the *node sendto* permission.

*ingress*

- Each packet entering the system must pass an *ingress* access control. Also
  requires the *node recvfrom* permission.

### *socket*

Socket that is not part of any other specific SELinux socket object class.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *tcp_socket*

Protocol: *PF_INET*, *PF_INET6* Family Type: *SOCK_STREAM*

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 2 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*name_connect*

- Connect to a specific port type.

*node_bind*

- Bind to a node.

### *udp_socket*

Protocol: *PF_INET*, *PF_INET6* Family Type: *SOCK_DGRAM*

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 1 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*node_bind*

- Bind to a node.

### *rawip_socket*

Protocol: *PF_INET*, *PF_INET6* Family Type: *SOCK_RAW*

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 1 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*node_bind*

- Bind to a node.

### *packet_socket*

Protocol: *PF_PACKET* Family Type: All.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *unix_stream_socket*

Communicate with processes on same machine. Protocol: *PF_STREAM*
Family Type: *SOCK_STREAM*

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 1 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*connectto*

- Connect to server socket.

### *unix_dgram_socket*

Communicate with processes on same machine. Protocol: *PF_STREAM*
Family Type: *SOCK_DGRAM*

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *tun_socket*

TUN is Virtual Point-to-Point network device driver to support IP tunneling.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 1 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*attach_queue*

- Attach to an interface queue.

## IPSec Network Object Classes

### *association*

IPSec security association

**Permissions** - 4 unique permissions:

*polmatch*

- Match IPSec Security Policy Database (SPD) context (-ctx) entries to an
  SELinux domain (contained in the Security Association Database (SAD)).

*recvfrom*

- Receive from an IPSec association.

*sendto*

- Send to an IPSec association.

*setcontext*

- Set the context of an IPSec association on creation.

### *key_socket*

IPSec key management. Protocol: *PF_KEY* Family Type: All

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_xfrm_socket*

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 2 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*nlmsg_read*

- Get IPSec configuration information.

*nlmsg_write*

- Set IPSec configuration information.

## Netlink Object Classes

Netlink sockets communicate between userspace and the kernel - also see
***netlink**(7)*.

### *netlink_socket*

Netlink socket that is not part of any specific SELinux Netlink socket class.
Protocol: *PF_NETLINK* Family Type: All other types that are not part of any
other specific netlink object class.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_route_socket*

Netlink socket to manage and control network resources.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 2 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*nlmsg_read*

- Read kernel routing table.

*nlmsg_write*

- Write to kernel routing table.

### *netlink_firewall_socket* (Deprecated)

Netlink socket for firewall filters.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 2 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*nlmsg_read*

- Read netlink message.

*nlmsg_write*

- Write netlink message.

### *netlink_tcpdiag_socket*

Netlink socket to monitor TCP connections.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 2 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*nlmsg_read*

- Request information about a protocol.

*nlmsg_write*

- Write netlink message.

### *netlink_nflog_socket*

Netlink socket for Netfilter logging

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_selinux_socket*

Netlink socket to receive SELinux events such as a policy or boolean change.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_audit_socket*

Netlink socket for audit service.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 5 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*nlmsg_read*

- Query status of audit service.

*nlmsg_readpriv*

- List auditing configuration rules.

*nlmsg_relay*

- Send userspace audit messages to theaudit service.

*nlmsg_tty_audit*

- Control TTY auditing.

*nlmsg_write*

- Update audit service configuration.

### *netlink_ip6fw_socket* (Deprecated)

Netlink socket for IPv6 firewall filters.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 2 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*nlmsg_read*

- Read netlink message.

*nlmsg_write*

- Write netlink message.

### *netlink_dnrt_socket*

Netlink socket for DECnet routing

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_kobject_uevent_socket*

Netlink socket to send kernel events to userspace.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_iscsi_socket*

Netlink socket to support RFC 3720 - Internet Small Computer Systems Interface
(iSCSI).

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_fib_lookup_socket*

Netlink socket to Forwarding Informaton Base services.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_connector_socket*

Netlink socket to support kernel connector services.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_netfilter_socket*

Netlink socket netfilter services.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_generic_socket*

Simplified netlink socket.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_scsitransport_socket*

SCSI transport netlink socket.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_rdma_socket*

Remote Direct Memory Access netlink socket.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *netlink_crypto_socket*

Kernel crypto API netlink socket.

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

## Miscellaneous Network Object Classes

### *peer*

NetLabel and Labeled IPsec have separate access controls, the network peer
label consolidates these two access controls into a single one (see
<http://paulmoore.livejournal.com/1863.html> for details).

**Permissions** - 1 unique permission:

*recv*

- Receive packets from a labeled networking peer.

### *packet*

Supports *secmark* services where packets are labeled using iptables to select
and label packets, SELinux then enforces policy using these packet labels.

**Permissions** - 5 unique permissions:

*forward_in*

- Allow inbound forwaded packets.

*forward_out*

- Allow outbound forwarded packets.

*recv*

- Receive inbound locally consumed packets.

*relabelto*

- Control how domains can apply specific labels to packets.

*send*

- Send outbound locally generated packets.

### *appletalk_socket*

Appletalk socket

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

### *dccp_socket*

Datagram Congestion Control Protocol (DCCP)

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 2 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*name_connect*

- Allow DCCP name ***connect**(2)*.

*node_bind*

- Allow DCCP ***bind**(2)*.

## Sockets via *extended_socket_class*

These socket classes that were introduced by the
*extended_socket_class* policy capability in kernel version 4.16.

### *sctp_socket*

Stream Control Transmission Protocol (SCTP)

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 3 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*association*

- Allow an SCTP association.

*name_connect*

- Allow SCTP ***connect**(2)* and ***connectx**(3)*.

*node_bind*

- Allow SCTP ***bind**(2)* and ***bindx**(3)*.

### *icmp_socket*

Internet Control Message Protocol (ICMP)

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions) + 1 unique:

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

*node_bind*

- Allow ICMP ***bind**(2)*.

### Miscellaneous Extended Socket Classes

**Class:**

- *ax25_socket* - Amateur X.25
- *ipx_socket* - Internetwork Packet Exchange
- *netrom_socket* - Part of Amateur X.25
- *atmpvc_socket* - Asynchronous Transfer Mode Permanent Virtual Circuit
- *x25_socket* - X.25
- *rose_socket* - Remote Operations Service Element
- *decnet_socket* - Everyone knows this
- *atmsvc_socket* - Asynchronous Transfer Mode Switched Virtual Circuit
- *rds_socket* - Remote Desktop Protocol
- *irda_socket* - Infrared Data Association (IrDA)
- *pppox_socket* - Point-to-Point Protocol over Ethernet/ATM ...
- *llc_socket* - Link Level Control
- *can_socket* - Controller Area Network
- *tipc_socket* - Transparent Inter Process Communication
- *bluetooth_socket*
- *iucv_socket* - Inter User Communication Vehicle
- *rxrpc_socket* - A reliable two phase transport
- *isdn_socket* - Integrated Services Digital Network
- *phonet_socket* - packet protocol used by Nokia cellular modems
- *ieee802154_socket* - For low-rate wireless personal area networks (LR-WPANs).
- *caif_socket* - Communication CPU to Application CPU Interface
- *alg_socket* - algorithm interface
- *nfc_socket* - Near Field Commuications
- *vsock_socket* - Virtual Socket protocol
- *kcm_socket* - Kernel Connection Multiplexor
- *qipcrtr_socket* - communicating with services running on co-processors in
  Qualcomm platforms
- *smc_socket* - Shared Memory Communications
- *xdp_socket* - eXpress Data Path

**Permissions** - Inherit 21
[**Common Socket Permissions**](#common-socket-permissions):

- *accept*, *append*, *bind*, *connect*, *create*, *getattr*, *getopt*,
  *ioctl*, *listen*, *lock*, *map*, *name_bind*, *read*, *recvfrom*,
  *relabelfrom*, *relabelto*, *sendto*, *setattr*, *setopt*, *shutdown*, *write*

## BPF Object Class

### *bpf*

Support for extended Berkeley Packet Filters ***bpf**(2)*

**Permissions** - 5 unique permissions:

*map_create*

- Create map

*map_read*

- Read map

*map_write*

- Write to map

*prog_load*

- Load program

*prog_run*

- Run program

## Performance Event Object Class

### *perf_event*

Control ***perf**(1)* events

**Permissions** - 6 unique permissions:

*cpu*

- Monitor cpu

*kernel*

- Monitor kernel

*open*

- Open a perf event

*read*

- Read perf event

*tracepoint*

- Set tracepoints

*write*

- Write a perf event

## Lockdown Object Class

Note: If the *lockdown* LSM is enabled alongside SELinux, then the
lockdown access control will take precedence over the SELinux lockdown
implementation.

### *lockdown*

Stop userspace extracting/modify kernel data.

**Permissions** - 6 unique permissions:

*confidentiality*

- Kernel features that allow userspace to extract confidential information
  from the kernel are disabled.

*integrity*

- Kernel features that allow userspace to modify the running kernel are disabled.

## IPC Object Classes

### *ipc* (Deprecated)

Interprocess communications

**Permissions** - Inherit 9
[**Common IPC Permissions**](#common-ipc-permissions):

- *associate*, *create*, *destroy*, *getattr*, *read*, *setattr*, *unix_read*,
  *unix_write*, *write*

### *sem*

Semaphores

**Permissions** - Inherit 9
[**Common IPC Permissions**](#common-ipc-permissions):

- *associate*, *create*, *destroy*, *getattr*, *read*, *setattr*, *unix_read*,
  *unix_write*, *write*

### *msgq*

IPC Message queues

**Permissions** - Inherit 9
[**Common IPC Permissions**](#common-ipc-permissions) + 1 unique:

- *associate*, *create*, *destroy*, *getattr*, *read*, *setattr*, *unix_read*,
  *unix_write*, *write*

*enqueue*

- Send message to message queue.

### *msg*

Message in a queue

**Permissions** - Inherit 9
[**Common IPC Permissions**](#common-ipc-permissions) + 2 unique:

- *associate*, *create*, *destroy*, *getattr*, *read*, *setattr*, *unix_read*,
  *unix_write*, *write*

*receive*

- Read (and remove) message from queue.

*send*

- Add message to queue.

### *shm*

Shared memory segment

**Permissions** - Inherit 9
[**Common IPC Permissions**](#common-ipc-permissions) + 1 unique:

- *associate*, *create*, *destroy*, *getattr*, *read*, *setattr*, *unix_read*,
  *unix_write*, *write*

*lock*

- Lock or unlock shared memory.

## Process Object Class

### *process*

An object is instantiated for each process created by the system.

**Permissions** - 31 unique permissions:

*dyntransition*

- Dynamically transition to a new context using ***setcon**(3)*.

*execheap*

- Make the heap executable.

*execmem*

- Make executable an anonymous mapping or private file mapping that is writable.

*execstack*

- Make the main process stack executable.

*fork*

- Create new process using ***fork**(2)*.

*getattr*

- Get process security information.

*getcap*

- Get Linux capabilities of process.

*getpgid*

- Get group Process ID of another process.

*getsched*

- Get scheduling information of another process.

*getsession*

- Get session ID of another process.

*getrlimit*

- Get process rlimit information.

*noatsecure*

- Disable secure mode environment cleansing.

*ptrace*

- Trace program execution of parent (***ptrace**(2)*).

*rlimitinh*

- Inherit rlimit information from parent process.

*setcap*

- Set Linux capabilities of process.

*setcurrent*

- Set the current process context.

*setexec*

- Set security context of executed process by ***setexecon**(3)*.

*setfscreate*

- Set security context by ***setfscreatecon**(3)*.

*setkeycreate*

- Set security context by ***setkeycreatecon**(3)*.

*setpgid*

- Set group Process ID of another process.

*setrlimit*

- Change process rlimit information.

*setsched*

- Modify scheduling information of another process.

*setsockcreate*

- Set security context by ***setsockcreatecon**(3)*.

*share*

- Allow state sharing with cloned or forked process.

*sigchld*

- Send *SIGCHLD* signal.

*siginh*

- Inherit signal state from parent process.

*sigkill*

- Send *SIGKILL* signal.

*signal*

- Send a signal other than *SIGKILL*, *SIGSTOP*, or *SIGCHLD*.

*signull*

- Test for exisitence of another process without sending a signal.

*sigstop*

- Send *SIGSTOP* signal

*transition*

- Transition to a new context on *exec()*.

### *process2*

Extension of *process* class.

**Permissions** - 2 unique permissions:

*nnp_transition*

- Enables SELinux domain transitions to occur under *no_new_privs* (*NNP*).

*nosuid_transition*

- Enables SELinux domain transitions to occur on *nosuid* ***mount**(8)*

## Security Object Class

### *security*

This is the security server object and there is only one instance of this
object (for the SELinux security server).

**Permissions** - 13 unique permissions:

*check_context*

- Determine whether the context is valid by querying the security server.

*compute_av*

- Compute an access vector given a source, target and class.

*compute_create*

- Determine context to use when querying the security server about a
  transition rule (*type_transition*).

*compute_member*

- Determine context to use when querying the security server about a
  membership decision (*type_member* for a polyinstantiated object).

*compute_relabel*

- Determines the context to use when querying the security server about
  a relabeling decision (*type_change*).

*compute_user*

- Determines the context to use when querying the security server about a
  user decision (*user*).

*load_policy*

- Load the security policy into the kernel (the security server).

*read_policy*

- Read the kernel policy to userspace.

*setbool*

- Change a boolean value within the active policy.

*setcheckreqprot*

- Set if SELinux will check original protection mode or modified protection
  mode (read-implies-exec) for *mmap* / *mprotect*.

*setenforce*

- Change the enforcement state of SELinux (permissive or enforcing).

*setsecparam*

- Set kernel access vector cache tuning parameters.

*validate_trans*

- Compute a *validatetrans* rule.

## System Operation Object Class

Note that while this is defined as a kernel object class, the userspace
***systemd**(1)* has hitched a ride.

### *system*

This is the overall system object and there is only one instance of this object.

**Permissions** - 6 unique permissions:

*ipc_info*

- Get info about an IPC object.

*module_load*

- Required permission when reading a file that is a 'kernel module'.
  See <http://marc.info/?l=selinux&amp;m=145988689809307&amp;w=2>
  for an example.

*module_request*

- Request the kernel to load a module.

*syslog_console*

- Control output of kernel messages to the console with ***syslog**(2)*.

*syslog_mod*

- Clear kernel message buffer with ***syslog**(2)*.

*syslog_read*

- Read kernel message with ***syslog**(2)*.

**User-space Permissions** - 8 unique added for use by ***systemd**(1)*:

*disable*

- Unused.

*enable*

- Enable default target/file.

*halt*

- Allow systemd to close down.

*reboot*

- Allow reboot by system manager.

*reload*

- Allow reload.

*stop*

- Unused.

*start*

- Unused.

*status*

- Obtain systemd status

## Miscellaneous Kernel Object Classes

### *kernel_service*

Used to add kernel services.

**Permissions** - 2 unique permissions:

*use_as_override*

- Grant a process the right to nominate an alternate process SID for the
  kernel to use as an override for the SELinux subjective security when
  accessing information on behalf of another process. For example, *CacheFiles*
  when accessing the cache on behalf of a process accessing an NFS file needs
  to use a subjective security ID appropriate to the cache rather than the one
  the calling process is using. The *cachefilesd* daemon will nominate the
  security ID to be used.

*create_files_as*

- Grant a process the right to nominate a file creation label for a kernel
  service to use.

### *key*

Manage Keyrings.

**Permission** - 7 unique permissions:

*create*

- Create a keyring.

*link*

- Link a key into the keyring.

*read*

- Read a keyring.

*search*

- Search a keyring.

*setattr*

- Change permissions on a keyring.

*view*

- View a keyring.

*write*

- Add a key to the keyring.

### *memprotect*

Protect lower memory blocks.

**Permission** - 1 unique permission:

*mmap_zero*

- Security check on mmap operations to see if the user is attempting to
  ***mmap**(2)* to low area of the address space. The amount of space protected
  is indicated by a proc tunable (*/proc/sys/vm/mmap_min_addr*). Setting this
  value to 0 will disable the checks. The <http://eparis.livejournal.com/891.html>
  describes additional checks that will be added to the kernel to protect
  against some kernel exploits (by requiring *CAP_SYS_RAWIO* (root) and the
  SELinux *memprotect* / *mmap_zero* permission instead of only one or the other).

### *binder*

Manage the Binder IPC service.

**Permission** - 4 unique permissions:

*call*

- Perform a binder IPC to a given target process (can A call B?).

*impersonate*

- Perform a binder IPC on behalf of another process (can A impersonate B
  on an IPC).

*set_context_mgr*

- Register self as the Binder Context Manager aka *servicemanager*
  (global name service). Can A set the context manager to B,
  where normally A == B.

*transfer*

- Transfer a binder reference to another process (can A transfer a binder
  reference to B?).

## Capability Object Classes

### *capability*

Used to manage the Linux capabilities granted to root processes.

**Permissions** - Inherit 32
[**Common Capability Permissions**](#common-capability-permissions):

- *audit_write*, *chown*, *dac_override*, *dac_read_search*, *fowner*, *fsetid*,
  *ipc_lock*, *ipc_owner*, *kill*, *lease*, *linux_immutable*, *mknod*,
  *net_admin*, *net_bind_service*, *net_raw*, *netbroadcast*, *setfcap*,
  *setgid*, *setpcap*, *setuid*, *sys_admin*, *sys_boot*, *sys_chroot*,
  *sys_module*, *sys_nice*, *sys_pacct*, *sys_ptrace*, *sys_rawio*,
  *sys_resource*, *sys_time*, *sys_tty_config*

### *capability2*

Extended *capability* class.

**Permissions** - Inherit 8
[**Common Capability2 Permissions**](#common-capability2-permissions):

- *audit_read*, *bpf*, *block_suspend*, *mac_admin*, *mac_override*, *perfmon*,
  *syslog*, *wake_alarm*

### *cap_userns*

Used to manage the Linux capabilities granted to namespace processes.

**Permissions** - Inherit 32
[**Common Capability Permissions**](#common-capability-permissions):

- *audit_write*, *chown*, *dac_override*, *dac_read_search*, *fowner*, *fsetid*,
  *ipc_lock*, *ipc_owner*, *kill*, *lease*, *linux_immutable*, *mknod*,
  *net_admin*, *net_bind_service*, *net_raw*, *netbroadcast*, *setfcap*,
  *setgid*, *setpcap*, *setuid*, *sys_admin*, *sys_boot*, *sys_chroot*,
  *sys_module*, *sys_nice*, *sys_pacct*, *sys_ptrace*, *sys_rawio*,
  *sys_resource*, *sys_time*, *sys_tty_config*

### *cap2_userns*

Extended *cap_userns* class.

**Permissions** - Inherit 8
[**Common Capability2 Permissions**](#common-capability2-permissions):

- *audit_read*, *bpf*, *block_suspend*, *mac_admin*, *mac_override*, *perfmon*,
  *syslog*, *wake_alarm*

## InfiniBand Object Classes

Support for Mellanox InfiniBand smart adapters, see:
<https://www.mellanox.com/products/infiniband-adapter-cards>

### *infiniband_pkey*

Manage partition keys.

**Permissions** - 1 unique permission:

*access*

- Access one or more partition keys based on their subnet.

### *infiniband_endport*

Manage packets.

**Permissions** - 1 unique permission:

*manage_subnet*

- Allow send and receive of subnet management packets on the end port specified
  by the device name and port.

# Userspace Object Classes

## X Windows Object Classes

These are userspace objects managed by XSELinux.

### *x_drawable*

The drawable parameter specifies the area into which the text will be drawn.
It may be either a pixmap or a window. Some of the permission information has
been extracted from an
<http://marc.info/?l=selinux&amp;m=121485496531386&amp;q=raw>
email describing them in terms of an MLS system.

**Permissions** - 19 unique permissions:

*add_child*

- Add new window. Normally SystemLow for MLS systems.

*blend*

- There are two cases:
  1. Allow a non-root window to have a transparent background.
  2. The application is redirecting the contents of the window and its
     sub-windows into a memory buffer when using the Composite extension.
     Only *SystemHigh* processes should have the blend permission on the
     root window.

*create*

- Create a drawable object. Not applicable to the root windows as it
  cannot be created.

*destroy*

- Destroy a drawable object. Not applicable to the root windows as it
  cannot be destroyed.

*get_property*

- Read property information. Normally *SystemLow* for MLS systems.

*getattr*

- Get attributes from a drawable object. Most applications will need this so
  *SystemLow*.

*hide*

- Hide a drawable object. Not applicable to the root windows as it cannot
  be hidden.

*list_child*

- Allows all child window IDs to be returned. From the root window it will
  show the client that owns the window and their stacking order. If hiding
  this information is required then processes should be *SystemHigh*.

*list_property*

- List property associated with a window. Normally *SystemLow* for MLS systems.

*manage*

- Required to create a context, move and resize windows. Not applicable
  to the root windows as it cannot be resized etc.

*override*

- Allow setting the *override-redirect* bit on the window. Not applicable
  to the root windows as it cannot be overridden.

*read*

- Read window contents. Note that this will also give read permission to all
  child windows, therefore (for MLS), only *SystemHigh* processes should have
  read permission on the root window.

*receive*

- Allow receiving of events. Normally *SystemLow* for MLS systems (but could
  leak information between clients running at different levels, therefore
  needs investigation).

*remove_child*

- Remove child window. Normally *SystemLow* for MLS systems.

*send*

- Allow sending of events. Normally *SystemLow* for MLS systems (but could leak information between clients running at different levels, therefore needs investigation).

*set_property*

- Set property. Normally SystemLow for MLS systems (but could leak information
  between clients running at different levels, therefore needs investigation.
  Polyinstantiation may be required).

*setattr*

- Allow window attributes to be set. This permission protects operations on the
  root window such as setting the background image or colour, setting the
  colormap and setting the mouse cursor to display when the cursor is in the
  window, therefore only *SystemHigh* processes should have the *setattr*
  permission.

*show*

- Show window. Not applicable to the root windows as it cannot be hidden.

*write*

- Draw within a window. Note that this will also give write permission to
  all child windows, therefore (for MLS), only *SystemHigh* processes should
  have *write* permission on the root window.

### *x_screen*

The specific screen available to the display (X-server)
(*hostname:display_number.screen*)

**Permissions** - 8 unique permissions:

*getattr*

- TBC

*hide_cursor*

- TBC

*saver_getattr*

- TBC

*saver_hide*

- TBC

*saver_setattr*

- TBC

*saver_show*

- TBC

*setattr*

- TBC

*show_cursor*

- TBC

### *x_gc*

The graphics contexts allows the X-server to cache information about how
graphics requests should be interpreted. It reduces the network traffic.

**Permissions** - 5 unique permissions:

*create*

- Create Graphic Contexts object.

*destroy*

- Free (dereference) a Graphics Contexts object.

*getattr*

- Get attributes from Graphic Contexts object.

*setattr*

- Set attributes for Graphic Contexts object.

*use*

- Allow GC contexts to be used.

### *x_font*

An X-server resource for managing the different fonts.

**Permissions** - 6 unique permissions:

*add_glyph*

- Create glyph for cursor

*create*

- Load a font.

*destroy*

- Free a font.

*getattr*

- Obtain font names, path, etc.

*remove_glyph*

- Free glyph

*use*

- Use a font.

### *x_colormap*

An X-server resource for managing colour mapping. A new colormap can be
created using *XCreateColormap*.

**Permissions** - 10 unique permissions:

*add_color*

- Add a colour.

*create*

- Create a new Colormap.

*destroy*

- Free a Colormap.

*getattr*

- Get the color gamut of a screen.

*install*

- Copy a virtual colormap into the display hardware.

*read*

- Read color cells of colormap.

*remove_color*

- Remove a colour

*uninstall*

- Remove a virtual colormap from the display hardware.

*use*

- Use a colormap.

*write*

- Change color cells in colormap.

### *x_property*

An InterClient Communications (ICC) service where each property has a name
and ID (or Atom). Properties are attached to windows and can be uniquely
identified by the *windowID* and *propertyID*. XSELinux supports
polyinstantiation of properties.

**Permissions** - 7 unique permissions:

*append*

- Append a property.

*create*

- Create property object.

*destroy*

- Free (dereference) a property object.

*getattr*

- Get attributes of a property.

*read*

- Read a property.

*setattr*

- Set attributes of a property.

*write*

- Write a property.

### *x_selection*

An InterClient Communications (ICC) service that allows two parties to
communicate about passing information. The information uses properties to
define the format (e.g. whether text or graphics). XSELinux supports
polyinstantiation of selections.

**Permissions** - 4 unique permissions:

*getattr*

- Get selection owner (*XGetSelectionOwner*).

*read*

- Read the information from the selection owner

*setattr*

- Set the selection owner (*XSetSelectionOwner*).

*write*

- Send the information to the selection requestor.

### *x_cursor*

The cursor on the screen

**Permissions** - 7 unique permissions:

*create*

- Create an arbitrary cursor object.

*destroy*

- Free (dereference) a cursor object.

*getattr*

- Get attributes of the cursor.

*read*

- Read the cursor.

*setattr*

- Set attributes of the cursor.

*use*

- Associate a cursor object with a window.

*write*

- Write a cursor.

### *x_client*

The X-client connecting to the X-server.

**Permissions** - 4 unique permissions:

*destroy*

- Close down a client.

*getattr*

- Get attributes of X-client.

*manage*

- Required to create an X-client context.

*setattr*

- Set attributes of X-client.

### *x_device*

These are any other devices used by the X-server as the keyboard and pointer
devices have their own object classes.

**Permissions** - Inherit 19
[**Common X_Device Permissions**](#common-x_device-permissions):

- *add*, *bell*, *create*, *destroy*, *force_cursor*, *freeze*, *get_property*,
  *getattr*, *getfocus*, *grab*, *list_property*, *manage*, *read*, *remove*,
  *set_property*, *setattr*, *setfocus*, *use*, *write*

### *x_server*

The X-server that manages the display, keyboard and pointer.

**Permissions** - 6 unique permissions:

*debug*

- TBC

*getattr*

- TBC

*grab*

- TBC

*manage*

- Required to create a context. (source code)

*record*

- TBC

*setattr*

- TBC

### *x_extension*

An X-Windows extension that can be added to the X-server (such as the
XSELinux object manager itself).

**Permissions** - 2 unique permissions:

*query*

- Query for an extension.

*use*

- Use the extensions services.

### *x_resource*

These consist of Windows, Pixmaps, Fonts, Colormaps etc. that are classed as
resources.

**Permissions** - 2 unique permissions:

*read*

- Allow reading a resource.

*write*

- Allow writing to a resource.

### *x_event*

Manage X-server events.

**Permissions** - 2 unique permissions:

*receive*

- Receive an event

*send*

- Send an event

### *x_synthetic_event*

Manage some X-server events (e.g. *confignotify*). Note the *x_event*
permissions will still be required.

**Permissions** - 2 unique permissions:

*receive*

- Receive an event

*send*

- Send an event

### *x_application_data*

Not specifically used by XSELinux, however is used by userspace applications
that need to manage copy and paste services (such as the *CUT_BUFFER*s).

**Permission** - 3 unique permissions:

*copy*

- Copy the data

*paste*

- Paste the data

*paste_after_confirm*

- Need to confirm that the paste is allowed.

### *x_pointer*

The mouse or other pointing device managed by the X-server.

**Permissions** - Inherit 19
[**Common X_Device Permissions**](#common-x_device-permissions):

- *add*, *bell*, *create*, *destroy*, *force_cursor*, *freeze*, *get_property*,
  *getattr*, *getfocus*, *grab*, *list_property*, *manage*, *read*, *remove*,
  *set_property*, *setattr*, *setfocus*, *use*, *write*

### *x_keyboard*

The keyboard managed by the X-server.

**Permissions** - Inherit 19
[**Common X_Device Permissions**](#common-x_device-permissions):

- *add*, *bell*, *create*, *destroy*, *force_cursor*, *freeze*, *get_property*,
  *getattr*, *getfocus*, *grab*, *list_property*, *manage*, *read*, *remove*,
  *set_property*, *setattr*, *setfocus*, *use*, *write*

## Database Object Classes

These are userspace objects - The PostgreSQL database supports these
with their SE-PostgreSQL database extension. The
"[**Security-Enhanced PostgreSQL Security Wiki**](http://wiki.postgresql.org/wiki/SEPostgreSQL_Development)"
explains the objects, their permissions and how they should be used in detail.

### *db_database*

Manage a database.

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 3 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*access*

- Required to connect to the database - this is the minimum permission
  required by an SE-PostgreSQL client.

*install_module*

- Required to install a dynmic link library.

*load_module*

- Required to load a dynmic link library.

### *db_table*

Manage a database table.

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 5 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*delete*

- Required to delete from a table with a *DELETE* statement, or when removing
the table contents with a *TRUNCATE* statement.

*insert*

- Required to insert into a table with an *INSERT* statement, or when restoring
  it with a *COPY FROM* statement.

*lock*

- Required to get a table lock with a *LOCK* statement.

*select*

- Required to refer to a table with a *SELECT* statement or to dump the table
  contents with a *COPY TO* statement.

*update*

- Required to update a table with an *UPDATE* statement.

### *db_schema*

Manage a database schema.

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 3 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*search*

- Search for an object in the schema.

*add_name*

- Add an object to the schema.

*remove_name*

- Remove an object from the schema.

### *db_procedure*

Manage a database procedure.

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 3 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*entrypoint*

- Required for any functions defined as Trusted Procedures.

*execute*

- Required for functions executed with SQL queries.

*install*

- Install a procedure.

### *db_column*

Manage a database column.

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 3 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*insert*

- Required to insert a new entry using the *INSERT* statement.

*select*

- Required to reference columns.

*update*

- Required to update a table with an *UPDATE* statement.

### *db_tuple*

Manage a database tuple.

**Permissions** - 7 unique:

*delete*

- Required to delete entries with a *DELETE* or *TRUNCATE* statement.

*insert*

- Required when inserting a entry with an *INSERT* statement, or restoring
  tables with a *COPY FROM* statement.

*relabelfrom*

- The security context of an entry can be changed with an *UPDATE* to the
  *security_context* column at which time *relabelfrom* and *relabelto*
  permission is evaluated. The client must have *relabelfrom* permission to
  the security context before the entry is changed, and *relabelto* permission
  to the security context after the entry is changed.

*relabelto*

- See *relabelfrom*.

*select*

- Required when: reading entries with a *SELECT* statement, returning entries
  that are subjects for updating queries with a *RETURNING* clause, or dumping
  tables with a *COPY TO* statement. Entries that the client does not have
  *select* permission on will be filtered from the result set.

*update*

- Required when updating an entry with an *UPDATE* statement. Entries that the
  client does not have update permission on will not be updated.

*use*

- Controls usage of system objects that require permission to "use" objects
  such as data types, tablespaces and operators.

### *db_blob*

Manage a database blob.

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 4 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*export*

- Export a binary large object by calling the *lo_export()* function.

*import*

- Import a file as a binary large object by calling the *lo_import()* function.

*read*

- Read a binary large object the *loread()* function.

*write*

- Write a binary large object with the *lowrite()* function.

### *db_view*

Manage a database view.

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 1 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*expand*

- Allows the expansion of a 'view'.

### *db_sequence*

A sequential number generator.

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 3 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*get_value*

- Get a value from the sequence generator object.

*next_value*

- Get and increment value.

*set_value*

- Set an arbitrary value.

### *db_language*

Support for script languages such as Perl and Tcl for SQL Procedures

**Permissions** - Inherit 6
[**Common Database Permissions**](#common-database-permissions) + 2 unique:

- *create*, *drop*, *getattr*, *relabelfrom*, *relabelto*, *setattr*

*implement*

- Whether the language can be implemented or not for the SQL procedure.

*execute*

- Allow the execution of a code block using a *DO* statement.

## Miscellaneous Userspace Object Classes

### *passwd*

Controlling changes to passwd information.

**Permissions** - 5 unique permissions:

*chfn*

- Change another users finger info.

*chsh*

- Change another users shell.

*crontab*

- crontab another user.

*passwd*

- Change another users passwd.

*rootok*

- *pam_rootok* check - skip authentication.

### *nscd*

Manage the Name Service Cache Daemon.

**Permissions** - 12 unique permissions:

*admin*

- Allow the ***nscd**(8)* daemon to be shut down.

*getgrp*

- Get group information.

*gethost*

- Get host information.

*getnetgrp*

- TBC

*getpwd*

- Get password information.

*getserv*

- Get ?? information.

*getstat*

- Get the AVC stats from the nscd daemon.

*shmemgrp*

- Get shmem group file descriptor.

*shmemhost*

- Get shmem host descriptor. ??

*shmemnetgrp*

- TBC

*shmempwd*

- TBC

*shmemserv*

- TBC

### *dbus*

Manage the D-BUS Messaging service that is required to run various services.

**Permissions** - 2 unique permissions:

*acquire_svc*

- Open a virtual circuit (communications channel).

*send_msg*

- Send a message.

### *context*

Support for the translation daemon ***mcstransd**(8)*. These permissions are
required to allow translation and querying of level and ranges for MCS and
MLS systems.

**Permissions** - 2 unique permissions:

*contains*

- Calculate a MLS/MCS subset - Required to check what the configuration
  file contains.

*translate*

- Translate a raw MLS/MCS label - Required to allow a domain to translate
  contexts.

### *service*

Manage ***systemd**(1)* services.

**Permissions** - 8 unique permissions:

*disable*

- Disable services.

*enable*

- Enable services.

*kill*

- Kill services.

*load*

- Load services

*reload*

- Restart *systemd* services.

*start*

- Start *systemd* services.

*status*

- Read service status.

*stop*

- Stop *systemd* services.

### *proxy*

Manages ***gssd**(8)* services.

**Permissions** - 1 unique permission:

*read*

- Read credentials.

<!-- %CUTHERE% -->

---
**[[ PREV ]](seandroid.md)** **[[ TOP ]](#)** **[[ NEXT ]](libselinux_functions.md)**
