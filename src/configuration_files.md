# SELinux Configuration Files

This section explains each SELinux configuration file with its format,
example content and where applicable, any supporting SELinux commands or
**libselinux** library API functions.

Where configuration files have specific man pages, these are noted by
adding the man page section (e.g. ***semanage.config**(5)*).

This Notebook classifies the types of configuration file used in SELinux
as follows:

1.  [**Global Configuration files**](global_config_files.md#global-configuration-files) that
    affect the active policy and their supporting SELinux-aware
    applications, utilities or commands. This Notebook will only refer
    to the commonly used configuration files.
2.  [**Policy Store Configuration Files**](policy_store_config_files.md#policy-store-configuration-files)
    that are managed by the **semanage**(8) and **semodule**(8) commands. These
    are used to build the majority of the
    [Policy Configuration Files](policy_config_files.md#policy-configuration-files)
    and should NOT be edited as together they describe the overall 'policy' configuration.
3.  [**Policy Configuration Files**](policy_config_files.md) used by an active
    (run time) policy/system. Note that there can be multiple policy
    configurations on a system (e.g. */etc/selinux/targeted* and
    */etc/selinux/mls*), however only one can be the active policy.
4.  [**SELinux Filesystem files - Table 6: SELinux filesystem Information**](lsm_selinux.md#selinux-filesystem) located under the */sys/fs/selinux*
    directory and reflect the current configuration of SELinux for the active
    policy. This area is used
    extensively by the libselinux library for userspace object managers and
    other SELinux-aware applications. These files and directories should not
    be updated by users (the majority are read only anyway), however
    they can be read to check various configuration parameters and
    viewing the currently loaded policy using tools such as
    ***apol**(1)* (e.g. *apol /sys/fs/selinux/policy*).

<br>

## The Policy Store

Version 2.7 of *libsemanage*, *libsepol*, and *policycoreutils* had the
policy module store has moved from */etc/selinux/&lt;SELINUXTYPE&gt;/modules*
to */var/lib/selinux/&lt;SELINUXTYPE&gt;*.

This new infrastructure now makes it possible to build policies containing a
mixture of Reference Policy modules, kernel policy language modules and
modules written in the CIL language as shown in the following examples:

```
# Compile and install a base and two modules written in kernel language:

checkmodule -o base.mod base.conf
semodule_package -o base.pp -m base.mod -f base.fc
checkmodule -m ext_gateway.conf -o ext_gateway.mod
semodule_package -o ext_gateway.pp -m ext_gateway.mod -f gateway.fc
checkmodule -m int_gateway.conf -o int_gateway.mod
semodule_package -o int_gateway.pp -m int_gateway.mod
semodule -s modular-test --priority 100 -i base.pp ext_gateway.pp int_gateway.pp
```

```
# Compile and install an updated module written in CIL:

semodule -s modular-test --priority 400 -i custom/int_gateway.cil
```

```
# Show a full listing of modules:

semodule -s modular-test --list-modules=full
400 int_gateway cil
100 base pp
100 ext_gateway pp
100 int_gateway pp
```

```
# Show a standard listing of modules:

semodule -s modular-test --list-modules=standard
base
ext_gateway
int_gateway
```

The ***semodule**(8)* command now has a number of new options, with the
most significant being:

1.  Setting module priorities (*-X | --priority*), this is discussed in
    [The priority Option](#the-priority-option) section.
2.  Listing modules (*--list-modules=full | standard*). The 'f*ull*'
    option shows all the available modules with their priority and
    policy format. The '*standard*' option will only show the highest
    priority, enabled modules.

### The priority Option

Priorities allow multiple modules with the same name to exist in the
policy store, with the higher priority module included in the final
kernel binary, and all lower priority modules of the same name ignored.
For example:

```
semodule --priority 100 --install distribution/apache.pp

semodule --priority 400 --install custom/apache.pp
```

Both apache modules are installed in the policy store as 'apache', but
only the custom apache module is included in the final kernel binary.
The distribution apache module is ignored. The *--list-modules* options
can be used to show these:

```
# Show a full listing of modules:

semodule --list-modules=full
400 apache pp
100 base pp
100 apache pp
```

```
# Show a standard listing of modules:

semodule --list-modules=standard
base
apache
```

The main use case for this is the ability to override a distribution
provided policy, while keeping the distribution policy in the store.

This makes it easier for distributions, 3rd parties, configuration
management tools (e.g. puppet), local administrators, etc. to update
policies without erasing each others changes. This also means that if a
distribution, 3rd party etc. updates a module, providing the local
customisation is installed at a higher priority, it will override the
new distribution policy.

This does require that policy managers adopt some kind of scheme for who
uses what priority. No strict guidelines currently exist, however the
value used by the *semanage\_migrate\_store* script is *--priority 100*
as this is assumed to be migrating a distribution. If a value is not
provided, *semodule* will use a default of *--priority 400* as it is
assumed to be a locally customised policy.

When *semodule* builds a lower priority module when a higher priority is
already available, the following message will be given: "*A higher
priority &lt;name&gt; module exists at priority &lt;999&gt; and will
override the module currently being installed at priority &lt;111&gt;*".

<br>

## Converting policy packages to CIL

A component of the update is to add a facility that converts compiled
policy modules (known as policy packages or the *\*.pp* files) to CIL
format. This is achieved via a *pp* to CIL high level language
conversion utility located at */usr/libexec/selinux/hll/pp*. This
utility can be used manually as follows:

	`cat module_name.pp | /usr/libexec/selinux/hll/pp > module_name.cil`

There is no man page for '*pp*', however the help text is as follows:

```
Usage: pp [OPTIONS] [IN_FILE [OUT_FILE]]

Read an SELinux policy package (.pp) and output the equivilent CIL.
If IN_FILE is not provided or is -, read SELinux policy package from
standard input. If OUT_FILE is not provided or is -, output CIL to
standard output.

Options:
-h, --help print this message and exit
```

<br>

<!-- %CUTHERE% -->

---
**[[ PREV ]](apache_support.md)** **[[ TOP ]](#)** **[[ NEXT ]](global_config_files.md)**
