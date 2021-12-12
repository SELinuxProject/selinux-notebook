# Hardening SELinux

- [Tuning Booleans](#tuning-booleans)
- [Disabling Modules](#disabling-modules)
- [Users and Roles](#users-and-roles)
- [Network Controls](#network-controls)
- [Custom Policy Modules](#custom-policy-modules)
- [Fine Grained Network Controls](#fine-grained-network-controls)
- [Fully Custom Policy](#fully-custom-policy)

The Reference Policy sets a good basis for learning how to operate a
system with SELinux. The policy allows system administrators and users
to continue using working methods that they learned before becoming
familiar with SELinux, because of its "targeted" model and reasonable
defaults.

However, it's possible to tighten the policy considerably. The
Reference Policy gives several options for hardening but for maximum
control over the policy, it's possible to write custom modules or even
replace the Reference Policy entirely.

The hardening suggestions are listed in the rough order of difficulty.

## Tuning Booleans

The Reference Policy uses booleans to control optional aspects of the
policy. Changing the booleans is a very easy way to tune the SELinux
policy. The booleans can be also changed temporarily, without
committing them yet to the on-disk policy, so changes are
automatically reverted on next boot.

For example, recent Firefox browsers can work with policy boolean
`mozilla_execstack` set to `off`. This can reduce the surface to
vulnerabilities which could use an executable stack. The boolean can
be changed using ***setsebool**(8)*:

```
# Check current status:
getsebool mozilla_execstack
mozilla_execstack --> on

# Change temporarily:
setsebool mozilla_execstack=off

# Write to persistent policy on disk:
setsebool -P mozilla_execstack=off

```

## Disabling Modules

By default, the Reference Policy enables most policy modules to
support any system. But when the system is known well by the
administrator, it's possible to disable modules which aren't used.

As an example, if Firefox isn't installed, the module `mozilla` can be
disabled in the policy. The hardening effect comes from reducing the
allow rules, some of which may apply to paths which aren't actively
monitored because the corresponding application isn't installed.

Care should be taken to never disable modules which actually are used,
since this may weaken the policy instead, because the disabled module
could have contained an application more strictly than what the policy
allows without the module. Disabling critical modules can also result
in system breakage. It's also possible to remove modules, but on
package upgrade they are typically reinstalled.

Examples:
```
# Disable Firefox module
semodule --disable=mozilla
# Remove the module entirely
semodule --remove=mozilla
```

## Users and Roles

In the "targeted" model, both unprivileged users and the system
administrator (`root`) are unconfined and the TE rules are very
relaxed. However, it's possible to change the SELinux user for these
accounts to more confined variants.

For the unprivileged users, the confined user in the Reference Policy
is `user_u` with corresponding role `user_r`. There's also `staff_u`
and `staff_r` to allow transitioning to system administrative roles by
logging in as `staff_u:staff_r` and escalating to `staff_u:sysadm_r`
or another role for administrative tasks with ***newrole**(1)*.

For the system administrator there are several options: `root` SELinux
user, which is mostly unconfined and `sysadm_u`, which is more
confined. The role for both is `sysadm_r`.

It's also possible to divide the powers of the system administrator to
several roles, `sysadm_r`, `auditadm_r`, `logadm_r`, `dbadm_r` and
`secadm_r`. This can be useful when an organization wants to ensure
that even the system administrators can be held accountable for their
actions. The roles can be also useful for management of labor, for
example having dedicated persons for managing databases or SELinux
policies.

It should be noted that since this isn't the default way of operating
SELinux, the Reference Policy may need to be supplemented and the
administrators, even users, may need to be more aware of SELinux in
order to be able to operate the system.

Example:
```
# User `test` has been added earlier with `adduser` or `useradd`.
semanage login --add --seuser user_u --range 's0' test
```

## Network Controls

With network controls of SELinux, it's possible to enhance firewall
rules with knowledge of SELinux types. Traditional firewall rules only
affect the whole system by allowing certain ports and protocols but
blocking others. With `nftables` and `iptables` it's also possible to
make this more fine grained: certain users can access the network but
others may not. By also using SELinux controls it's possible to fine
tune this to the application level: `mozilla_t` can connect to the
Internet but some other applications can't. SELinux packet controls
can be also used to combine Deep Packet Inspection with SELinux TE
rules.

Chapter [Networking Support](network_support.md#selinux-networking-support)
presents the controls with examples.

## Custom Policy Modules

Further hardening can be achieved by replacing policy modules from the
Reference Policy with custom modules. Typically the modules in the
Reference Policy are written to allow all possible modes of operation
for an application or its users, since the writers of the policy don't
know the specifics of each installation. Thus the SELinux rules may be
more relaxed than what could be optimal for a specific case. When the
exact environment and usage patterns are known, it's possible to write
replacement policy modules to remove excess rules and hence reduce
attack surface.

As a minimum, it should be ensured that all continuously running
services and main user applications have a dedicated policy module or
rules, instead of running in for example `init_t`, `initrc_t` or
`unconfined_t` types which may offer low level of protection.

## Fine Grained Network Controls

In an internal network of an organization, where all entities can
agree on the same SELinux policy, using IPSec, CIPSO and CALIPSO may
allow further policy controls. In addition to SELinux domain of the
source application, even the SELinux domain (or at least MCS/MLS
category/sensitivity) of the target server can be used in TE rules.

## Fully Custom Policy

It's also possible to write custom SELinux policies for an entire
system with non-trivial effort.

The rules can also be analyzed with various SELinux tools, such as
`apol`, `sedta`, `seinfo`, `sepolicy`, `sesearch` and many more. With
the tools it may be possible to find hardening opportunities or errors
in the policy.

```
# Find out which domains can transition to custom domain
# `my_thunderbird_t` and what are the rules affecting the transition:
sedta --source my_thunderbird_t --reverse
Transition 1: user_t -> my_thunderbird_t

Domain transition rule(s):
allow user_t my_app_ta:process { sigkill signal signull transition };

Entrypoint my_thunderbird_exec_t:
        Domain entrypoint rule(s):
        allow my_thunderbird_t my_thunderbird_exec_t:file { entrypoint execute getattr map read };

        File execute rule(s):
        allow user_t my_app_exec_ta:file { execute getattr open read };

        Type transition rule(s):
        type_transition user_t my_thunderbird_exec_t:process my_thunderbird_t;


1 domain transition(s) found.
```

```
# Check ports to which domain `mozilla_t` can connect:
sepolicy network -d mozilla_t

mozilla_t: tcp name_connect
        443, 80 (my_http_port_t)
        1080 (my_socks_port_t)
```

The downside of making the SELinux rules as tight as possible is that
when the applications (or hardware components or network
configuration) are updated, there's a possibility that the rules may
also need updating because of the changes. Less generic rules are also
less generally useful for different configurations, so the rules may
need tuning for each installation.

<!-- %CUTHERE% -->

---
**[[ PREV ]](reference_policy.md)** **[[ TOP ]](#)** **[[ NEXT ]](implementing_seaware_apps.md)**
