# SELinux Permissive and Enforcing Modes

SELinux has three major modes of operation:

**Enforcing** - SELinux is enforcing the loaded policy.

**Permissive** - SELinux has loaded the policy, however it is not
enforcing the policy rules. This is generally used for testing as the
audit log will contain the AVC denied messages as defined in the
[**Auditing SELinux Events**](auditing.md#auditing-selinux-events) section.
The SELinux utilities such as ***audit2allow**(1)* and
***audit2why**(8)* can then be used to determine the cause and possible
resolution by generating the appropriate allow rules.

**Disabled** - The SELinux infrastructure is not enabled, therefore no
policy can be loaded.

These flags are set in the */etc/selinux/config* file as described in the
[**Global Configuration Files**](global_config_files.md#etcselinuxconfig)
section.

There is another method for running specific domains in permissive mode
using the kernel policy *permissive* statement. This can be used directly in a
user written module or ***semanage**(8)* will generate the appropriate
module and load it using the following example command:

```
# This example will add a new module in:
#   /var/lib/selinux/<SELINUXTYPE>/active/modules/400/permissive_unconfined_t
# and then reload the policy:

semanage permissive -a unconfined_t
```

It is also possible to set permissive mode on a userspace object manager
using the *libselinux* function ***avc_open**(3)*, for example the
[**X-Windows Object Manager**](x_windows.md#x-windows-selinux-support)
uses *avc_open()* to set whether it will always run permissive,
enforcing or follow the current SELinux enforcement mode.

The ***sestatus**(8)* command will show the current SELinux
enforcement mode in its output, however it does not display individual
domain or object manager enforcement modes.



<!-- %CUTHERE% -->

---
**[[ PREV ]](types_of_policy.md)** **[[ TOP ]](#)** **[[ NEXT ]](auditing.md)**
