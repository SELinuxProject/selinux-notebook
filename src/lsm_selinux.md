# Linux Security Module and SELinux

- [The LSM Module](#the-lsm-module)
  - [*/proc/self/attr/* Filesystem Files](#procselfattr-filesystem-files)
  - [Core LSM Source Files](#core-lsm-source-files)
    - [LSM Program Loading Hooks](#lsm-program-loading-hooks)
- [The SELinux Module](#the-selinux-module)
  - [Core SELinux Source Files](#core-selinux-source-files)
  - [Fork System Call Walk-thorough](#fork-system-call-walk-thorough)
  - [Process Transition Walk-thorough](#process-transition-walk-thorough)
  - [SELinux Filesystem](#selinux-filesystem)

This section gives a high level overview of the LSM and SELinux internal
kernel structure and workings as enabled in a kernel. A more detailed
view can be found in the
[**Implementing SELinux as a Linux Security Module**](https://www.nsa.gov/Portals/70/documents/resources/everyone/digital-media-center/publications/research-papers/implementing-selinux-as-linux-security-module-report.pdf)
that was used extensively to develop this section (and also using
the SELinux kernel source code). The major areas covered are:

1. How the LSM and SELinux modules work together.
2. The major SELinux internal services.
3. The ***fork**(2)* and ***exec**(2)* system calls are followed through as an
   example to tie in with the transition process covered in the
   [**Domain Transition**](domain_object_transitions.md#domain-transition)
   section.
4. The SELinux filesystem */sys/fs/selinux*.
5. The */proc* filesystem area most applicable to SELinux.

## The LSM Module

The LSM is the Linux security framework that allows 3rd party
access control mechanisms to be linked into the GNU / Linux kernel.
There are a number of services that utilise the LSM:

1. SELinux - the subject of this Notebook.
2. AppArmor is a MAC service based on pathnames and does not require
   labeling or relabeling of filesystems. See
   <http://wiki.apparmor.net/> for details.
3. Simplified Mandatory Access Control Kernel (SMACK). See
   <http://www.schaufler-ca.com/> for details.
4. Tomoyo that is a name based MAC and details can be found at
   <http://sourceforge.jp/projects/tomoyo/docs>.
5. Yama extends the DAC support for ***ptrace**(2)*. See
   *Documentation/security/Yama.txt* for further details.
6. Lockdown feature. If set to integrity, kernel features that allow
   userspace to modify the running kernel are disabled. If set to
   confidentiality, kernel features that allow userspace to extract
   confidential information from the kernel are disabled.

The basic idea behind LSM is to:

- Insert security function hooks and security data structures in the
  various kernel services to allow access control to be applied over
  and above that already implemented via DAC. The type of service that
  have hooks inserted are shown in with an example task and program
  execution shown in the
  [Fork System Call Walk-thorough](#fork-system-call-walk-thorough) and
  [Process Transition Walk-thorough](#process-transition-walk-thorough)
  sections.
- Allow registration and initialisation services for the
  3rd party security modules.
- Allow process security attributes to be available to userspace
  services by extending the */proc* filesystem with a security
  namespace as shown in
  [*/proc/self/attr/* Filesystem Files](#procselfattr-filesystem-files).
  These are located at:

```
/proc/<self|pid>/attr/<attr>
```

```
/proc/<self|pid>/task/<tid>/attr/<attr>
```

Where *\<pid\>* is the process id, *\<tid\>* is the thread id, and *\<attr\>*
is the entry described in the
[*/proc/self/attr/* Filesystem Files](#procselfattr-filesystem-files) section.

- Support filesystems that use extended attributes (SELinux uses
  *security.selinux* as explained in the
  [**Labeling Extended Attribute Filesystems**](objects.md#labeling-extended-attribute-filesystems)
  section).
- Later kernels allow 'module stacking' where the LSM modules  can be called
  in a predefined order, for example:

```
lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf
```

It should be noted that the LSM does not provide any security services
itself, only the hooks and structures for supporting 3rd party modules.
If no 3rd party module is loaded, the capabilities module becomes the default
module thus allowing standard DAC access control.

These are the type of kernel services that LSM has inserted security hooks and
structures to allow access control to be managed by 3rd party modules:

|                           |                       |                   |
| ------------------------- | --------------------- | ----------------- |
| Program execution         | Filesystem operations | Inode operations  |
| File operations           | Task operations       | Netlink messaging |
| Unix domain networking    | Socket operations     | XFRM operations   |
| Key Management operations | IPC operations        | Memory Segments   |
| Semaphores                | Capability            | Sysctl            |
| Syslog                    | Audit                 |                   |

### */proc/self/attr/* Filesystem Files

The following */proc/self/attr/* filesystem files are used by the kernel
services and via libselinux (for userspace) to manage setting and reading of
security contexts within the LSM defined data structures:

*current*

- Contains the current process security context.

*exec*

- Used to set the security context for the next exec call.

*fscreate*

- Used to set the security context of a newly created file.

*keycreate*

- Used to set the security context for keys that are cached in the kernel.

*prev*

- Contains the previous process security context.

*sockcreate*

- Used to set the security context of a newly created socket.

### Core LSM Source Files

The core kernel LSM source files  that form the LSM are as follows:

*include/linux/lsm_hooks.h*

- Contains comments on each of the LSM hooks use and requirements, also
  defines the main security structures for module stacking.

*include/linux/lsm_hook_defs.h*

- Defines each *LSM_HOOK* that will be expanded by macros in *lsm_hooks.h*.

*include/linux/security.h*

- *if/else* table of LSM hooks expanding those that are defined in the kernel
  build or no-op those that are not.

*security/commoncap.c*, *security/device_cgroup.c*

- Some capability functions were in various kernel modules have been
  consolidated into these source files.

*security/inode.c*

- This allows the 3rd party security module to initialise a security
  filesystem. In the case of SELinux this would be */sys/fs/selinux* that is
  defined in the *security/selinux/selinuxfs.c* source file.

*security/security.c*

- Contains the LSM framework initialisation services that will set up the
  hooks described in *include/linux/lsm_hooks.h* and those in the capability
  source files. It also provides functions to initialise 3rd party modules.

*security/lsm_audit.c*

- Contains common LSM audit functions.

*security/min_addr.c*

- Minimum VM address protection from userspace for DAC and LSM.

#### LSM Program Loading Hooks

The LSM hooks for validating program loading and execution (*security_bprm_\**
functions) are listed with their *security/selinux/hooks.c* links (although see
*include/linux/lsm_hooks.h* for greater detail). These hooks are used in the
[**Process Transition Walk-thorough**](#process-transition-walk-thorough)
section.

*security_bprm_set_creds->selinux_bprm_set_creds*

- Set up security information in the *bprm->security* field based on the file
  to be exec'ed contained in *bprm->file*. SELinux uses this hook to check
  for domain transitions and the whether the appropriate permissions have been
  granted, and obtaining a new SID if required.

*security_bprm_committing_creds->selinux_bprm_committing_creds*

- Prepare to install the new security attributes of the process being transformed
  by an *execve* operation. SELinux uses this hook to close any unauthorised
  files, clear parent signal and reset resource limits if required.

*security_bprm_committed_creds->selinux_bprm_committed_creds*

- Tidy up after the installation of the new security attributes of a process
  being transformed by an *execve* operation. SELinux uses this hook to check
  whether signal states can be inherited if new SID allocated.

*security_bprm_check->selinux_bprm_check_security*

- This hook is not used by SELinux.

## The SELinux Module

This section does not go into detail of all the SELinux module
functionality as the
[**Implementing SELinux as a Linux Security Module**](https://www.nsa.gov/resources/everyone/digital-media-center/publications/research-papers/assets/files/implementing-selinux-as-linux-security-module-report.pdf)
 does this (although a bit dated).

However this section does attempt to highlight the way some areas work by
using the example described in the
[**Domain and Object Transitions**](domain_object_transitions.md#domain-and-object-transitions)
section. To achieve this, these will describe the:

- [**Fork System Call Walk-thorough**](#fork-system-call-walk-thorough)
- [**Process Transition Walk-thorough**](#process-transition-walk-thorough)

### Core SELinux Source Files

 The diagrams shown in
[**Figure 2: High Level SELinux Architecture**](core_components.md#core-selinux-components)
and **Figure 12: The Main LSM / SELinux Modules** can be used
to see how some of these SELinux modules fit together with the
*security/selinux* following files:

*avc.c*

- Access Vector Cache functions and structures. The function calls are for
  the kernel services, however they have been ported to form the *libselinux*
  userspace library.

*exports.c*

- Exported SELinux services for SECMARK (as there is SELinux specific code
  in the *netfilter* source tree).

*hooks.c*

- Contains all the SELinux functions that are called by the kernel resources
  via the *security_ops* structure or the *security_hook_list* in
  kernels supporting multiple LSMs (they form the kernel resource object
  managers). There are also support functions for managing process exec's,
  managing SID allocation and removal, interfacing into the AVC and Security
  Server.

*netif.c*

- These manage the mapping between labels and SIDs for the *net\** language
  statements when they are declared in the active policy.

*netnode.c*, *netport.c*, *netlabel.c*

- The interface between ***NetLabel**(8)* services and SELinux.

*netlink.c*, *nlmsgtab.c*

- Manages the notification of policy updates to resources including
  userspace applications via *libselinux*.

*selinuxfs.c*

- The *selinuxfs* pseudo filesystem (*/sys/fs/selinux*) that imports/exports
  security policy information to/from userspace services. The services
  exported are shown in the
  [**SELinux Filesystem**](lsm_selinux.md#selinux-filesystem) section.

*xfrm.c*

- Contains the IPSec XFRM (transform) hooks for SELinux.

*include/classmap.h*, *include/initial_sid_to_string.h*

- Contains all the kernel security classes and permissions.
  *initial_sid_to_string.h* contains the initial SID contexts. These are used
  to build the *flask.h* and *av_permissions.h* kernel configuration files
  when the kernel is being built (using the *genheaders* script defined in
  the *selinux/Makefile*). These files are now built support the dynamic
  security class mapping structure removing the need for fixed class to SID
  mapping.

*ss/avtab.c*

- AVC table functions for inserting / deleting entries.

*ss/conditional.c*

- Support boolean statement functions and implements a conditional AV table
  to hold entries.

*ss/ebitmap.c*

- Bitmaps to represent sets of values, such as types, roles, categories,
  and classes.

*ss/hashtab.c*

- Hash table.

*ss/mls.c*

- Functions to support MLS.

*ss/policydb.c*

- Defines the structure of the policy database. See the
  [**SELinux Policy Module Primer**](http://securityblog.org/brindle/2006/07/05/selinux-policy-module-primer/)
  article for details on the structure.

*ss/services.c*

- This contains the supporting services for kernel hooks defined in *hooks.c*,
  the AVC and the Security Server. For example the *security_transition_sid()*
  that computes the SID for a new subject / object shown in
  **Figure 12: The Main LSM / SELinux Modules**.

*ss/sidtab.c*

- The SID table contains the security context indexed by its SID value.

*ss/status.c*

- Interface for *selinuxfs/status*. Used by the ***selinux_status_\***(3)*
  functions.

*ss/symtab.c*

- Maintains associations between symbol strings and their values.

### Fork System Call Walk-thorough

This section walks through the ***fork**(2)* system call shown in
[**Figure 7: Domain Transition**](domain_object_transitions.md#domain-transition)
starting at the kernel hooks that link to the SELinux services. The way the
SELinux hooks are initialised into the LSM *security_ops* function table (or the
*security_hook_list* in kernels supporting multiple LSMs) are also described.

Using **Figure 10: Hooks for the** ***fork**(2)* **system call**,
the major steps to check whether the *unconfined_t* process has permission
to use the *fork* permission are:

1. The *kernel/fork.c* has a hook that links it to the LSM function
   *security_task_create()* that is called to check access permissions.
2. Because the SELinux module has been initialised as the security
   module, the *security_ops*/*security_hook_list* table has been set
   to point to the SELinux *selinux_task_create()* function in *hooks.c*.
3. The *selinux_task_create()* function check whether the task has
   permission via the *current_has_perm(current, PROCESS\_\_FORK)* function.
4. This will result in a call to the AVC via the *avc_has_perm()*
   function in *avc.c* that checks whether the permission has been
   granted or not. First (via *avc_has_perm_noaudit()*) the cache is
   checked for an entry. Assuming that there is no entry in the AVC,
   then the *security_compute_av()* function in *services.c* is called.
5. The *security_compute_av()* function will search the SID table for
   source and target entries, and if found will then call the
   *context_struct_compute_av()* function.
   The *context_struct_compute_av()* function carries out many checks to
   validate whether access is allowed. The steps are (assuming the access
   is valid):
   - Initialise the AV structure so that it is clear.
   - Check the object class and permissions are correct. It also checks
     the status of the *allow_unknown* flag (see the
     [**SELinux Filesystem**](#selinux-filesystem),
     [***/etc/selinux/semanage.conf***](global_config_files.md#etcselinuxsemanage.conf)
     and
     [**Reference Policy Build Options**](reference_policy.md#the-reference-policy)
     *build.conf* and *UNK_PERMS* sections.
   - Checks if there are any type enforcement rules (*AVTAB_ALLOWED*,
     *AVTAB_AUDITALLOW*, *AVTAB_AUDITDENY*, *AVTAB_XPERMS*).
   - Check whether any conditional statements are involved via the
     *cond_compute_av()* function in *conditional.c*.
   - Remove permissions that are defined in any *constraint* rule via the
     *constraint_expr_eval()* function call (in *services.c*). This
     function will also check any MLS constraints.
   - *context_struct_compute_av()* checks if a process transition is
     being requested (it is not). If it were, then the *transition* and
     *dyntransition* permissions are checked and whether the role is
     changing.
   - Finally check whether there are any constraints applied via the
     *typebounds* rule.
7. Once the result has been computed it is returned to the
   *kernel/fork.c* system call via the initial *selinux_task_create()*
   function. In this case the ***fork**(2)* call is allowed.
8. **The End.**

![](./images/10-fork.png)

**Figure 10: Hooks for the** ***fork**(2)* **system call** - *This describes
the steps required to check access permissions for Object Class process and
permission fork.*

### Process Transition Walk-thorough

This section walks through the ***execve**(2)* and checking whether a
process transition to the *ext_gateway_t* domain is allowed, and if so
obtain a new SID for the context
*unconfined_u:message_filter_r:ext_gateway_t* as shown in
[**Figure 7: Domain Transition**](domain_object_transitions.md#domain-transition).

The process starts with the Linux operating system issuing a
*do_execve* (that passes over the file name to be run and its
environment + arguments) call from the CPU specific architecture code to execute
a new program (for example, from *arch/ia64/kernel/process.c*). The
*do_execve()* function is located in the *fs/exec.c* source code module
and does the loading and final exec as described below.

*do_execve()* has a number of calls to *security_bprm_\** functions
that are a part of the LSM (see *include/linux/lsm_hooks.h*), and are
hooked by SELinux during the initialisation process (in
*security/selinux/hooks.c*). **The LSM / SELinux Program Loading Hooks**
describes these *security_bprm* functions that are hooks for validating
program loading and execution (although see *lsm_hooks.h* for greater detail).

Therefore starting at the *do_execve()* function and using
**Figure 11: Process Transition**, the following major steps will be carried
out to check whether the *unconfined_t* process has permission to transition
the *secure_server* executable to the *ext_gateway_t* domain:

1. The executable file is opened, a call issued to the *sched_exec()*
   function and the *bprm* structure is initialised with the file
   parameters (name, environment and arguments).
2. Via the *prepare_binprm()* function call the UID and GIDs are
   checked and a call issued to *security_bprm_set_creds()* that
   will carry out the following:
3. Call *cap_bprm_set_creds* function in *commoncap.c*, that will
   set up credentials based on any configured capabilities.
   If ***setexeccon**(3)* has been called prior to the *exec*, then that
   context will be used otherwise call *security_transition_sid()*
   function in *services.c*. This function will then call
   *security_compute_sid()* to check whether a new SID needs to be
   computed. This function will (assuming there are no errors):
   - Search the SID table for the source and target SIDs.
   - Sets the SELinux user identity.
   - Set the source role and type.
   - Checks that a *type_transition* rule exists in the *AV table* and /
     or the *conditional AV table*
     (see **Figure 12: The Main LSM / SELinux Modules**).
   - If a *type_transition*, then also check for a *role_transition*
     (there is a role change in the *ext_gateway.conf* policy module),
     set the role.
   - Check if any MLS attributes by calling *mls_compute_sid()* in
     *mls.c*. It also checks whether MLS is enabled or not, if so sets
     up MLS contexts.
   - Check whether the contexts are valid by calling
     *compute_sid_handle_invalid_context()* that will also log an
     audit message if the context is invalid.
   - Finally obtains a SID for the new context by calling
     *sidtab_context_to_sid()* in *sidtab.c* that will search the
     SID table (see **Figure 12: The Main LSM / SELinux Modules**)
     and insert a new entry if okay or log a kernel event if invalid.
4. The *selinux_bprm_set_creds()* function will continue by checking
   via the *avc_has_perm()* functions (in *avc.c*) whether the *file*
   class *file_execute_no_trans* is set (in this case it is not),
   therefore the *process* class *transition* and *file* class
   *entrypoint* permissions are checked (in this case they are
   allowed), therefore the new SID is set, and after checking various
   other permissions, control is passed back to the *do_execve* function.
5. The *exec_binprm* function will ultimately commit the credentials
   calling the SELinux *selinux_bprm_committing_creds* and
   *selinux_bprm_committed_creds*.
6. Various strings are copied (args etc.) and a check is made to see if
   the exec succeeded or not (in this case it did), therefore the
   *security_bprm_free()* function is ultimately called to free the
   *bprm* security structure.
7. **The End.**

![](./images/11-transition.png)

**Figure 11: Process Transition** - *This shows the major steps required to
check if a transition is allowed from the unconfined_t domain to the
ext_gateway_t domain.*

![](./images/12-lsm-selinux-arch.png)

**Figure 12: The Main LSM / SELinux Modules** - *The fork and exec functions
link to
[**Figure 7: Domain Transition**](domain_object_transitions.md#domain-transition)
where the transition process is described.*

### SELinux Filesystem

The table below shows the information contained in the SELinux filesystem
(*selinuxfs*) */sys/fs/selinux* where the SELinux kernel service exports
information regarding its configuration and active policy.
*selinuxfs* is a read/write interface used by SELinux library functions
for userspace SELinux-aware applications and object managers. Note:
while it is possible for userspace applications to read/write to this
interface, it is not recommended - use the
[***libselinux***]((libselinux_functions.md#appendix-b---libselinux-api-summary)
or *libsepol* library.

*/sys/fs/selinux* - Directory

- This is the root directory where the SELinux kernel exports relevant
  information regarding its configuration and active policy for use by the
  libselinux library.

*access*

- Compute access decision interface that is used by the
  ***security_compute_av**(3)*,***security_compute_av_flags**(3)*,
  ***avc_has_perm**(3)* and ***avc_has_perm_noaudit**(3)* functions.
  The kernel security server (see *security/services.c*) converts the
  contexts to SIDs and then calls the *security_compute_av_user* function
  to compute the new SID that is then converted to a context string.
  Requires *security { compute_av }* permission.

*checkreqprot*

- *0* = Check requested protection applied by kernel.
  *1* = Check protection requested by application. This is the default.
  These apply to the *mmap* and *mprotect* kernel calls. Default value can
  be changed at boot time via the *checkreqprot=* parameter.
  Requires *security { setcheckreqprot }* permission.

*commit_pending_bools*

- Commit new boolean values to the kernel policy.
  Requires *security { setbool }* permission.

*context*

- Validate context interface used by the ***security_check_context**(3)*
  function.
  Requires *security { check_context }* permission.

*create*

- Compute create labeling decision interface that is used by the
  ***security_compute_create**(3)* and ***avc_compute_create**(3)* functions.
  The kernel security server (see *security/selinux/ss/services.c*) converts
  the contexts to SIDs and then calls the *security_transition_sid_user*
  function to compute the new SID that is then converted to a context string.
  Requires *security { compute_create }* permission.

*deny_unknown*, *reject_unknown*

- These two files export *deny_unknown*, (read by the
  ***security_deny_unknown**(3)* function) and *reject_unknown* status
  to user space.
  These are taken from the *handle-unknown* parameter set in the
  [***/etc/selinux/semanage.conf***](global_config_files.md#etcselinuxsemanage.conf)
  when policy is being built and are set as follows:
  - *deny:reject*
  - 0:0 = Allow unknown object class / permissions. This will set the
    returned AV with all 1's.
  - 1:0 = Deny unknown object class / permissions (the default). This will
    set the returned AV with all 0's.
  - 1:1 = Reject loading the policy if it does not contain all the object
    classes / permissions.

*disable*

- Disable SELinux until next reboot.

*enforce*

- Get or set enforcing status.
  Requires *security { setenforce }* permission.

*load*

- Load policy interface.
  Requires *security { load_policy }* permission.

*member*

- Compute polyinstantiation membership decision interface that is used by
  the ***security_compute_member**(3)* and ***avc_compute_member**(3)*
  functions.
  The kernel security server (see *security/selinux/ss/services.c*) converts
  the contexts to SIDs and then calls the *security_member_sid()* function
  to compute the new SID that is then converted to a context string.
  Requires *security { compute_member }* permission.

*mls*

- Returns 1 if MLS policy is enabled or 0 if not.

*null*

- The SELinux equivalent of */dev/null* for file descriptors that have been
  redirected by SELinux.

*policy*

- Interface to upload the current running policy in kernel binary format.
  This is useful to check the running policy using ***apol**(1)*,
  *dispol*/*sedispol* etc. (e.g. *apol /sys/fs/selinux/policy*).

*policyvers*

- Returns supported policy version for kernel. Read by
  ***security_policyvers**(3)* function.

*relabel*

- Compute relabeling decision interface that is used by the
  ***security_compute_relabel**(3)* function.
  The kernel security server (see *security/selinux/ss/services.c*) converts
  the contexts to SIDs and then calls the *security_change_sid()* function
  to compute the new SID that is then converted to a context string.
  Requires *security { compute_relabel }* permission.

*status*

- This can be used to obtain enforcing mode and policy load changes with
  much less over-head than using the *libselinux* netlink / call backs.
  This was added for Object Managers that have high volumes of AVC requests
  so they can quickly check whether to invalidate their cache or not.
  The status structure indicates the following:
  - *version* - Version number of the status structure. This will increase
    as other entries are added.
  - *sequence* - This is incremented for each event with an even number
    meaning that the events are stable. An odd number indicates that one of
    the events is changing and therefore the userspace application should
    wait before reading the status of any event.
  - *enforcing* - *0* = Permissive mode, *1* = Enforcing mode.
  - *policyload* - This contains the policy load sequence number and should
    be read and stored, then compared to detect a policy reload.
  - *deny_unknown* - *0* = Allow and *1* = Deny unknown object classes /
    permissions. This is the same as the *deny_unknown* entry above.

*user*

- Compute reachable user contexts interface that is used by the
  deprecated ***security_compute_user**(3)* function.
  The kernel security server (see *security/selinux/ss/services.c*) converts
  the contexts to SIDs and then calls the *security_get_user_sids()* function
  to compute the user SIDs that are then converted to context strings.
  Requires *security { compute_user }* permission.

*validatetrans*

- Compute *validatetrans* decision interface.
  Requires *security { validate_trans }* permission.
  Used by the ***security_validatetrans**(3)* function.

*/sys/fs/selinux/avc* - Directory

- This directory contains information regarding the kernel AVC that can be
  displayed by the ***avcstat**(8)* command.

*avc/cache_stats*

- Shows the kernel AVC lookups, hits, misses etc.

*avc/cache_threshold*

- The default value is 512, however caching can be turned off (but
  performance suffers) by: *echo 0 \> /selinux/avc/cache_threshold*
  Requires *security { setsecparam }* permission.

*avc/hash_stats*

- Shows the number of kernel AVC entries, longest chain etc.

*/sys/fs/selinux/booleans* - Directory

- Contains a file named after each boolean defined by policy.

*booleans/\<boolean_name\>*

- Each file contains the current and pending status of the boolean
  (0 = false or 1 = true). The ***getsebool**(8)*, ***setsebool**(8)*
  and ***sestatus**(8)* commands use this interface via the *libselinux*
  library functions.

*/sys/fs/selinux/initial_contexts* - Directory

- Contains a file named after each initial SID defined by policy.

*initial_contexts/\<initial_sid\>*

- Each file contains the initial SID context as defined by policy
  (e.g. *any_socket* context: *system_u:object_r:unlabeled_t:s0*).

*/sys/fs/selinux/policy_capabilities* - Directory

- Contains a file named after each policy capability defined by policy
  using the *policycap* statement. Their default values are false.

*policy_capabilities/always_check_network*

- If true SECMARK and NetLabel peer labeling are always enabled even if
  there are no SECMARK, NetLabel or Labeled IPsec rules configured.
  This forces checking of the *packet* class to protect the system should
  any rules fail to load or they get maliciously flushed.
  Requires kernel 3.13 minimum.

*policy_capabilities/cgroup_seclabel*

- Allows userspace to set labels on cgroup/cgroup2 files, enabling
  fine-grained labeling of cgroup files by userspace.
  Requires kernel 4.11 minimum.

*policy_capabilities/extended_socket_class*

- Enables the use of separate socket security classes for all network
  address families rather than the generic socket class.

*policy_capabilities/genfs_seclabel_symlinks*

- Enables fine-grained labeling of symlinks in pseudo filesystems based
  on *genfscon* rules.

*policy_capabilities/network_peer_controls*

- If true the following *network_peer_controls* are enabled:
  - *node { sendto recvfrom }*
  - *netif { ingress egress }*
  - *peer { recv }*

*policy_capabilities/nnp_nosuid_transition*

- Enables SELinux domain transitions to occur under *no_new_privs* (NNP)
  or on *nosuid* mounts if the corresponding permission (*nnp_transition*
  for NNP, *nosuid_transition* for *nosuid*, defined in the *process2*
  security class) is allowed between the old and new contexts.

*policy_capabilities/open_perms*

- If true the *open* permission is enabled by default on the following
  object classes: *dir*, *file*, *fifo_file*, *chr_file*, *blk_file*.

*/sys/fs/selinux/class* - Directory

- Contains a directory named after each class defined by policy.

*class/\<object_class\>* - Directory

- Each class directory contains an *index* file and a *perms* directory.

*class/\<object_class\>/index*

- This file contains an allocated class number that is derived from the
  policy source order (e.g. alg_socket is the 124th class entry in the
  policy taken from the Fedora *policy/flask/security_classes* file
  (or 121st for the Reference Policy)).

*class/\<object_class\>/perms* - Directory

- Contains one file named after each permission defined by policy.

*class/\<object_class\>/perms/\<perm_name\>*

- Each file is named by the permission assigned in policy and contains
  an allocated permission number that is derived from the policy source order
  (e.g. *accept* is the 15th permission from the Fedora or Reference Policy
  *policy/flask/access_vector* file for the *alg_socket*).

Notes:

1. Kernel SIDs are not passed to userspace only the context strings.
2. The */proc* filesystem exports the process security context string
   to userspace via */proc/\<self|pid\>/attr* and
   */proc/\<self|pid\>/task/\<tid\>/attr/\<attr\>*
   interfaces.

<!-- %CUTHERE% -->

---
**[[ PREV ]](pam_login.md)** **[[ TOP ]](#)** **[[ NEXT ]](userspace_libraries.md)**
