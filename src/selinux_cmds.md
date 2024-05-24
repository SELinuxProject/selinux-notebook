# Appendix C - SELinux Commands

This section gives a brief summary of the SELinux specific commands.
Some of these have been used within this Notebook, however the
appropriate man pages do give more detail and the SELinux project site
has a page that details all the available tools and commands at:

<https://github.com/SELinuxProject/selinux/wiki/Tools>

***audit2allow**(1)*

Generates policy allow rules from an audit log file.

***audit2why**(8)*

Describes audit log messages and why access was denied.

***avcstat**(8)*

Displays the AVC statistics.

***chcat**(8)*

Change or remove a category from a file or user.

***chcon**(1)*

Changes the security context of a file.

***checkmodule**(8)*

Compiles base and loadable modules from source.

***checkpolicy**(8)*

Compiles a monolithic policy from source.

***fixfiles**(8)*

Update / correct the security context of for filesystems that use extended
attributes.

***genhomedircon**(8)*

Generates file configuration entries for users home directories.
This command has also been built into ***semanage**(8)*, therefore when using
the policy store / loadable modules this does not need to be used.

***getenforce**(1)*

Shows the current enforcement state.

***getsebool**(8)*

Shows the state of the booleans.

***load_policy**(8)*

Loads a new policy into the kernel. Not required when using ***semanage**(8)* /
***semodule**(8)* commands.

***matchpathcon**(8)*

Show a files path and security context.

***newrole**(1)*

Allows users to change roles - runs a new shell with the new security context.

***restorecon**(8)*

Sets the security context on one or more files.

***run_init**(8)*

Runs an *init* script under the correct context.

***runcon**(1)*

Runs a command with the specified context.

***selinuxenabled**(1)*

Shows whether SELinux is enabled or not.

***semanage**(8)*

Used to configure various areas of a policy within a policy store.

***semodule**(8)*

Used to manage the installation, upgrading etc. of policy modules.

***semodule_expand**(8)*

Manually expand a base policy package into a kernel binary policy file.

***semodule_link**(8)*

Manually link a set of module packages.

***semodule_package**(8)*

Create a module package with various configuration files (file context etc.)

***sestatus**(8)*

Show the current status of SELinux and the loaded policy.

***setenforce**(1)*

Sets / unsets enforcement mode.

***setfiles**(8)*

Initialise the extended attributes of filesystems.

***setsebool**(8)*

Sets the state of a boolean to on or off persistently across reboots or for
this session only.

<!-- %CUTHERE% -->

---
**[[ PREV ]](libselinux_functions.md)** **[[ TOP ]](#)** **[[ NEXT ]](debug_policy_hints.md)**
