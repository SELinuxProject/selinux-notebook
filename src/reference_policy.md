# The Reference Policy

## Introduction

The Reference Policy is now the standard policy source used to build
Linux SELinux policies. This provides a single source tree with
supporting documentation that can be used to build policies for
different purposes such as: confining important daemons, supporting MLS
/ MCS type policies and locking down systems so that all processes are
under SELinux control.

This section details how the Reference Policy is:

1.  Constructed and types of policy builds supported.
2.  Adding new modules to the build.
3.  Installation as a full Reference Policy source or as Header files.
4.  Impact of the migration process being used to convert compiled
    module files (*\*.pp*) to CIL.
5.  Modifying the configuration files to build new policies.
6.  Explain the support macros.

Note that the Reference Policy uses **NAME** to define the policy name. This
then becomes part of the policy location (i.e. */etc/selinux/&lt;NAME&gt;*).
In most documentation the policy name is defined using the
*&lt;SELINUXTYPE&gt;* convention, as that is from the
*/etc/selinux/config* file entry **SELINUXTYPE=**. This part of the Notebook
uses both forms.

<br>

### Reference Policy Overview

Strictly speaking the 'Reference Policy' should refer to the policy
taken from the master repository or the latest released version. This is
because most Linux distributors take a released version and then tailor it to
their specific requirements.

All examples in this section are based on the master Reference Policy
repository that can be checked out using the following:

```
# Check out the core policy:
git clone https://github.com/SELinuxProject/refpolicy.git

cd refpolicy
# Add the contibuted modules (policy/modules/contrib)
git submodule init
git submodule update
```

A list of releases can be found at <https://github.com/SELinuxProject/refpolicy/releases>

The Fedora distribution is built from a specific standard Reference Policy
build, modified and distributed by Red Hat as a source RPM. These RPMs can be
obtained from <http://koji.fedoraproject.org>. The master Fedora policy source
can be found at: <https://github.com/fedora-selinux/selinux-policy>

**Figure 26: The Reference Policy Source Tree** shows the layout of the
reference policy source tree, that once installed would be located at
`/etc/selinux/<SELINUXTYPE>/src/policy`

Where the **&lt;SELINUXTYPE&gt;** entry is taken from the *build.conf* file
as discussed in the
[**Reference Policy Build Options** - *build.conf*](#reference-policy-build-options---build.conf)
section. The
[**Installing and Building the Reference Policy Source**](#installing-and-building-the-reference-policy-source)
section explains a simple build from source.

![](./images/26-ref-policy.png)

**Figure 26: The Reference Policy Source Tree** - *When building a modular policy, files are added to the policy store. For monolithic builds the policy store is not used.*

<br>

The Reference Policy can be used to build two policy types:

1.  **Loadable Module Policy** - A policy that has a
    base module for core services and has the ability to load / unload
    modules to support applications as required. This is now the
    standard used by Linux distributions.
2.  **Monolithic Policy** - A policy that has all the
    required policy information in a single base policy and does not
    require the services of the module infrastructure (***semanage**(8)*
    or ***semodule**(8)*). These are more suitable for embedded or
    minimal systems.

Each of the policy types are built using module files that define the
specific rules required by the policy as detailed in the
[**Reference Policy Module Files**](#reference-policy-module-files) section.
Note that the monolithic policy is built using the the same module files by
forming a single 'base' source file.

The Reference Policy relies heavily on the ***m4**(1)* macro processor
as the majority of supporting services are m4 macros.

<br>

### Distributing Policies

It is possible to distribute the Reference Policy in two forms:

1.  As source code that is then used to build policies. This is not the
    general way policies are distributed as it contains the complete
    source that most administrators do not need. The
    [**Reference Policy Source**](#reference-policy-source) section describes
    the source and the
    [**Installing and Building the Reference Policy Source**](#installing-and-building-the-reference-policy-source)
    section describes how to install the source and build a policy.
2.  As 'Policy Headers'. This is the most common way to distribute the
    Reference Policy. Basically, the modules that make up 'the
    distribution' are pre-built and then linked to form a base and
    optional modules. The 'headers' that make-up the policy are then
    distributed along with makefiles and documentation. A policy writer
    can then build policy using the core modules supported by the
    distribution, and using development tools they can add their own
    policy modules. The
    [**Reference Policy Headers**](#reference-policy-headers) section describes
    how these are installed and used to build modules.

The policy header files and documentation for Fedora are distributed in:
-   **selinux-policy** - Contains the SELinux */etc/selinux/config* file and rpm macros
-   **selinux-policy-devel** - Contains the 'Policy Header' development
    environment that is located at */usr/share/selinux/devel*
-   **selinux-policy-doc** - Contains man pages and the html policy
    documentation that is located at */usr/share/doc/selinux-policy/html*

These rpms contain a specific policy type containing configuration files and
packaged policy modules (*\*.pp*). The policy will be installed in the
*/etc/selinux/&lt;SELINUXTYPE&gt;* directory, along with its configuration files.
-   **selinux-policy-targeted** - This is the default Fedora policy.
-   selinux-policy-minimum
-   selinux-policy-mls

The selinux-policy-sandbox rpm contains the sandbox module for use by the
*policycoreutils-sandbox* package. This will be installed as a module for
one of the three main policies described above.

<br>

### Policy Functionality

As can be seen from the policies distributed with Fedora above, they can
be classified by the name of the functionality they support (taken from
the *SELINUXTYPE* entry of the *build.conf* as shown in
**Table 2:** *build.conf* **Entries**), for example the Fedora policies support:

-   minimum - MCS policy that supports a minimal set of confined daemons
    within their own domains. The remainder run in the `unconfined_t` space.
-   targeted - MCS policy that supports a greater number of confined daemons
    and can also confine other areas and users.
-   mls - MLS policy for server based systems.

<br>

### Reference Policy Module Files

The reference policy modules are constructed using a mixture of
[**support macros**](#reference-policy-support-macros),
[**interface calls**](#interface-macro) and
[**Kernel Policy Language Statements**](kernel_policy_language.md#kernel-policy-language),
using three principle types of source file:

1.  A private policy file that contains statements required to enforce
    policy on the specific GNU / Linux service being defined within the
    module. These files are named *&lt;module_name&gt;.te*.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For example the *ada.te* file shown below has two statements:
-   one to state that the `ada_t` process has permission to write to
    the stack and memory allocated to a file.
-   one that states that if the *unconfined_domain* module is loaded, then
    allow the `ada_t` domain unconfined access. Note that if the
    flow of this statement is followed it will be seen that many
    more interfaces and macros are called to build the final raw
    SELinux language statements. An expanded module source isshown in the
    [**Module Expansion Process**](#module-expansion-process) section.

2.  An external interface file that defines the services available to
    other modules. These files are named *&lt;module_name&gt;.if*.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For example the *ada.if* file shown below
has two interfaces defined for other modules to call:
-   `ada_domtrans` - that allows another module (running in domain `$1`) to
    run the ada application in the `ada_t` domain.
-   `ada_run` - that allows another module to run the ada application in
    the `ada_t` domain (via the `ada_domtrans` interface), then
    associate the `ada_t` domain to the caller defined role (`$2`) and
    terminal (`$3`).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Provided of course that the caller domain has permission.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Note that there are two types of interface specification:
-   **Access Interfaces** - These are the most
    common and define interfaces that *.te* modules can call as described in
    the ada examples. They are generated by the *interface* macro as
    detailed in the the [*interface*](#interface-macro) section.
-   **Template Interfaces** - These are required whenever a module is
    required in different domains and allows the type(s) to be redefined by
    adding a prefix supplied by the calling module. The basic idea is to set
    up an application in a domain that is suitable for the defined SELinux
    user and role to access but not others. These are generated by the
    *template* macro as detailed in the [*template*](#template-macro) section.

3.  A file labeling file that defines the labels to be added to files
    for the specified module. These files are named
    *&lt;module_name&gt;.fc*. The build process will amalgamate all the
    *\*.fc* files and finally form the
    [***file_contexts***](policy_config_files.md#contextsfilesfile_contexts)
    file that will be used to label the filesystem.

For example the *ada.fc* file shown below requires that the specified
files are labeled `system_u:object_r:ada_exec_t:s0`.

The &lt;module_name&gt; must be unique within the reference policy
source tree and should reflect the specific Linux service being
enforced by the policy.

The following examples from the ada module files show how they are
made from the Policy Macros, Interface calls and kernel policy statements
and rules:

**ada.te file contents:**

```
policy_module(ada, 1.5.0)

########################################
#
# Declarations
#

attribute_role ada_roles;			# Kernel policy statement
roleattribute system_r ada_roles;

type ada_t;
type ada_exec_t;
application_domain(ada_t, ada_exec_t)		# call into 'application.if'
role ada_roles types ada_t;

########################################
#
# Local policy
#

allow ada_t self:process { execstack execmem };

userdom_use_inherited_user_terminals(ada_t)	# call into 'userdomain.if'

optional_policy(`				# Macro in loadable_module.spt
	unconfined_domain(ada_t)
')

```

**ada.if 'interface calls' file contents:**

```
## <summary>GNAT Ada95 compiler.</summary>

########################################
## <summary>
##	Execute the ada program in the ada domain.
## </summary>
## <param name="domain">
##	<summary>
##	Domain allowed to transition.
##	</summary>
## </param>
#
interface(`ada_domtrans',`			# Defining an interface
	gen_require(`				# Macro in loadable_module.spt
		type ada_t, ada_exec_t;
	')

	corecmd_search_bin($1)
	domtrans_pattern($1, ada_exec_t, ada_t)	# Macro in misc_patterns.spt
')

########################################
## <summary>
##	Execute ada in the ada domain, and
##	allow the specified role the ada domain.
## </summary>
## <param name="domain">
##	<summary>
##	Domain allowed to transition.
##	</summary>
## </param>
## <param name="role">
##	<summary>
##	Role allowed access.
##	</summary>
## </param>
#
interface(`ada_run',`
	gen_require(`
		attribute_role ada_roles;
	')

	ada_domtrans($1)
	roleattribute $2 ada_roles;		# Kernel policy statement
')

```

**ada.fc file contents:**

```
				# gen_context is a macro in misc_macros.spt
/usr/bin/gnatbind	--	gen_context(system_u:object_r:ada_exec_t,s0)
/usr/bin/gnatls	--	gen_context(system_u:object_r:ada_exec_t,s0)
/usr/bin/gnatmake	--	gen_context(system_u:object_r:ada_exec_t,s0)

/usr/libexec/gcc(/.*)?/gnat1	--	gen_context(system_u:object_r:ada_exec_t,s0)
```

<br>

### Reference Policy Documentation

One of the advantages of the reference policy is that it is possible to
automatically generate documentation as a part of the build process.
This documentation is defined in XML and generated as HTML files
suitable for viewing via a browser.

The documentation for Fedora can be viewed in a browser using
[*/usr/share/doc/selinux-policy/html/index.html*](/usr/share/doc/selinux-policy/html/index.html)
once the *selinux-policy-doc* rpm has been installed.
The documentation for the Reference Policy source will be available at
*&lt;location&gt;/src/policy/doc/html* once *make html* has been executed
(the &lt;location&gt; is the location of the installed source after
*make install-src* has been executed as described in the
[**Installing and Building the Reference Policy Source**](#installing-and-building-the-reference-policy-source)
section). The Reference Policy documentation may also be available at a
default location of */usr/share/doc/refpolicy-VERSION/html* if
*make install-doc* has been executed (where *VERSION* is the entry from the
source *VERSION* file.

**Figure 27** shows an example screen shot of the documentation produced for
the ada module interfaces.

![](./images/27-ref-doc.png)

**Figure 27: Example Documentation Screen Shot**

<br>

## Reference Policy Source

This section explains the source layout and configuration files, with
the actual installation and building covered in the
[**Installing and Building the Reference Policy Source**](#installing-and-building-the-reference-policy-source) section.

The source has a README file containing information on the configuration
and installation processes that has been used within this section (and
updated with the authors comments as necessary). There is also a VERSION
file that contains the Reference Policy release date, this can then be used to
obtain a change list <https://github.com/SELinuxProject/refpolicy/releases>.

<br>

### Source Layout

**Figure 26: The Reference Policy Source Tree** shows the layout of the
reference policy source tree, that once installed would be located at:

/etc/selinux/&lt;SELINUXTYPE&gt;/src/policy

The following sections detail the source contents:

-   [**Reference Policy Files and Directories**](#reference-policy-files-and-directories) - Describes the
    files and their location.
-   [**Source Configuration Files**](#source-configuration-files) -
    Details the contents of the *build.conf* and *modules.conf*
    configuration files.
-   [**Source Installation and Build Make Options**](#source-installation-and-build-make-options) - Describes the *make* targets.
-   [**Modular Policy Build Structure**](#modular-policy-build-structure) -
    Describes how the various source files are linked together to form a
    base policy module *base.conf* during the build process.

The
[**Installing and Building the Reference Policy Source**](#installing-and-building-the-reference-policy-source)
section then describes how the initial source is installed and
configured to allow a policy to be built.

<br>

### Reference Policy Files and Directories

**Table 1: The Reference Policy Files and Directories** shows the major
files and their directories with a description of each taken from the
README file. All directories are relative to the root of the Reference
Policy source directory *./policy*.

The *build.conf* and *modules.conf* configuration files are further detailed
in the [**Source Configuration Files**](#source-configuration-files)
section as they define how the policy will be built.

During the build process, a file is generated in the *./policy* directory
called either *policy.conf* or *base.conf* depending whether a monolithic or
modular policy is being built. This file is explained in the
[**Modular Policy Build Structure**](#modular-policy-build-structure) section.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>File / Directory Name</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>Makefile</td>
<td>General rules for building the policy.</td>
</tr>
<tr>
<td>Rules.modular</td>
<td>Makefile rules specific to building loadable module policies.</td>
</tr>
<tr>
<td>Rules.monolithic</td>
<td>Makefile rules specific to building monolithic policies.</td>
</tr>
<tr>
<td>build.conf</td>
<td>Options which influence the building of the policy, such as the policy type and distribution. This file is described in the <a href="#reference-policy-build-options---build.conf">Reference Policy Build Options - build.conf</a> section.</td>
</tr>
<tr>
<td>config/appconfig-&lt;type&gt;</td>
<td>Application configuration files for all configurations of the Reference Policy where &lt;type&gt; is taken from the <em>build.conf</em> <em>TYPE</em> entry that are currently: standard, MLS and MCS). These files are used by SELinux-aware programs and described in the <a href="policy_config_files.md">SELinux Configuration Files</a> section.</td>
</tr>
<tr>
<td>config/file_contexts.subs_dist</td>
<td>Used to configure file context aliases (see the <a  href="policy_config_files.md#contextsfilesfile_contexts.subs">contexts/files/file_contexts.subs and file_contexts.subs_dist File</a> section).</td>
</tr>
<tr>
<td>config/local.users</td>
<td><p>The file read by load policy for adding SELinux users to the policy on the fly. </p>
<p>Note that this file is not used in the modular policy build.</p></td>
</tr>
<tr>
<td>doc/html/*</td>
<td>When <em>make html</em> has been executed, contains the in-policy XML documentation, presented in web page form.</td>
</tr>
<tr>
<td>doc/policy.dtd</td>
<td>The doc/policy.xml file is validated against this DTD.</td>
</tr>
<tr>
<td>doc/policy.xml</td>
<td>This file is generated/updated by the conf and html make targets. It contains the complete XML documentation included in the policy.</td>
</tr>
<tr>
<td>doc/templates/*</td>
<td>Templates used for documentation web pages.</td>
</tr>
<tr>
<td>man/*</td>
<td>Various man pages for modules (ftp, http etc.)</td>
</tr>
<tr>
<td>support/*</td>
<td>Tools used in the build process.</td>
</tr>
<tr>
<td>policy/flask/initial_sids</td>
<td><p>This file has declarations for each initial SID.</p>
<p>The file usage in policy generation is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</p></td>
</tr>
<tr>
<td>policy/flask/security_classes</td>
<td><p>This file has declarations for each security class.</p>
<p>The file usage in policy generation is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</p></td>
</tr>
<tr>
<td>policy/flask/access_vectors</td>
<td>This file defines the common permissions and class specific permissions. The file is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</td>
</tr>
<tr>
<td>policy/modules/*</td>
<td><p>Each directory represents a layer in Reference Policy. All of the modules are contained in one of these layers. The <em>contrib</em> modules are supplied externally to the Reference Policy, then linked into the build.</p>
<p>The files present in each directory are:</p>
<p>metadata.xml - describes the layer.</p>
<p>&lt;module_name&gt;.te, .if &amp; .fc - contains policy source as described in the <a href="#reference-policy-module-files">Reference Policy Module Files</a> section.</p>
<p>The file usage in policy generation is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</p></td>
</tr>
<tr>
<td>policy/support/*</td>
<td><p>Reference Policy support macros are described in the <a href="#reference-policy-support-macros">Reference Policy support Macros</a> section.</p></td>
</tr>
<tr>
<td>policy/booleans.conf</td>
<td>This file is generated/updated by the conf make target. It contains the booleans in the policy, and their default values. If tunables are implemented as booleans, tunables will also be included. This file will be installed as the /etc/selinux/NAME/booleans file (note that this is not true for any system that implements the modular policy - see the <a href="#booleans-global-booleans-and-tunable-booleans">Booleans, Global Booleans and Tunable Booleans section).</a></td>
</tr>
<tr>
<td>policy/constraints</td>
<td><p>This file defines constraints on permissions in the form of boolean expressions that must be satisfied in order for specified permissions to be granted. These constraints are used to further refine the type enforcement rules and the role allow rules. Typically, these constraints are used to restrict changes in user identity or role to certain domains.</p>
<p>(Note that this file does not contain the MLS / MCS constraints as they are in the <em>mls</em> and <em>mcs</em> files described below).</p>
<p>The file usage in policy generation is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</p></td>
</tr>
<tr>
<td>policy/context_defaults</td>
<td>This would contain any specific <em>default_user</em>, <em>default_role</em>, <em>default_type</em> and/or <em>default_range</em> rules required by the policy.</td>
</tr>
<tr>
<td>policy/global_booleans</td>
<td>This file defines all booleans that have a global scope, their default value, and documentation. See the <a href="#booleans-global-booleans-and-tunable-booleans">Booleans, Global Booleans and Tunable Booleans section.</a></td>
</tr>
<tr>
<td>policy/global_tunables</td>
<td>This file defines all tunables that have a global scope, their default value, and documentation. See the <a href="#booleans-global-booleans-and-tunable-booleans">Booleans, Global Booleans and Tunable Booleans section.</a></td>
</tr>
<tr>
<td>policy/mcs</td>
<td><p>This contains information used to generate the <em>sensitivity</em>, <em>category</em>, <em>level</em> and <em>mlsconstraint</em> statements used to define the MCS configuration.</p>
<p>The file usage in policy generation is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</p></td>
</tr>
<tr>
<td>policy/mls</td>
<td><p>This contains information used to generate the <em>sensitivity</em>, <em>category</em>, <em>level</em> and <em>mlsconstraint</em> statements used to define the MLS configuration.</p>
<p>The file usage in policy generation is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</p></td>
</tr>
<tr>
<td>policy/modules.conf</td>
<td><p>This file contains a listing of available modules, and how they will be used when building Reference Policy.</p>
<p>To prevent a module from being used, set the module to "off". For monolithic policies, modules set to "base" and "module" will be included in the policy. For modular policies, modules set to "base" will be included in the base module; those set to "module" will be compiled as individual loadable modules.</p>
<p>This file is described in the <a href="#reference-policy-build-options---policymodules.conf">Reference Policy Build Options - policy/modules.conf</a> section.</p></td>
</tr>
<tr>
<td>policy/policy_capabilities</td>
<td><p>This file defines the policy capabilities that can be enabled in the policy.</p>
<p>The file usage in policy generation is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</p></td>
</tr>
<tr>
<td>policy/users</td>
<td><p>This file defines the users included in the policy.</p>
<p>The file usage in policy generation is described in the <a href="#modular-policy-build-structure">Modular Policy Build Structure</a> section.</p></td>
</tr>
<tr>
<td>securetty_types<br>setrans.conf</td>
<td>These files are not part of the standard Reference Policy distribution but are added by Fedora source updates.</td>
</tr>
</tbody>
</table>

**Table 1: The Reference Policy Files and Directories**

<br>

### Source Configuration Files

There are two major configuration files (build.conf and modules.conf)
that define the policy to be built and are detailed in this section.

<br>

#### Reference Policy Build Options - build.conf

This file defines the policy type to be built that will influence its
name and where the source will be located once it is finally installed.
An example file content is shown in the
[**Installing and Building the Reference Policy Source**](#installing-and-building-the-reference-policy-source)
section where it is used to install and then build the policy.


**Table 2:** *build.conf* **Entries** explains the fields that can be defined within this file, however
there are a number of *m4* macro parameters that are set up when this file is
read by the build process makefiles. These macro definitions are shown
in and are also used within the module source files to control how the
policy is built with examples shown in the
[**`ifdef`**](#ifdef-ifndef-parameters) section.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Option</strong></td>
<td><strong>Type</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>OUTPUT_POLICY</td>
<td>Integer</td>
<td>Set the version of the policy created when building a monolithic policy. This option has no effect on modular policy.</td>
</tr>
<tr>
<td>TYPE</td>
<td>String</td>
<td><p>Available options are standard (uses RBAC/TE), mcs (uses RBAC/TE/MCS) and mls (uses RBAC/TE/MLS).</p>
<p>The <em>mls</em> and <em>mcs</em> options control the enable_mls, and enable_mcs policy blocks.</p></td>
</tr>
<tr>
<td>NAME</td>
<td>String</td>
<td>Sets the name of the policy; the NAME is used when installing files to e.g., /etc/selinux/NAME and /usr/share/selinux/NAME. If not set, the policy type field (TYPE) is used.</td>
</tr>
<tr>
<td>DISTRO</td>
<td>String (optional)</td>
<td>Enable distribution-specific policy. Available options are redhat, rhel4, gentoo, debian, and suse. This option controls distro_redhat, distro_rhel4, distro_suse policy blocks.</td>
</tr>
<tr>
<td>UNK_PERMS</td>
<td>String</td>
<td>Set the kernel behaviour for handling of permissions defined in the kernel but missing from the policy. The permissions can either be allowed, denied, or the policy loading can be rejected. See the <a href="lsm_selinux.md#selinux-filesystem">SELinux Filesystem</a> for more details. If not set, then it will be taken from the <em>semanage.conf</em> file.</td>
</tr>
<tr>
<td>DIRECT_INITRC</td>
<td>Boolean (<em>y|n</em>)</td>
<td>If '<em>y</em>' sysadm will be allowed to directly run init scripts, instead of requiring the run_init tool. This is a build option instead of a tunable since role transitions do not work in conditional policy. This option controls direct_sysadm_daemon policy blocks.</td>
</tr>
<tr>
<td>SYSTEMD</td>
<td>Boolean (<em>y|n</em>)</td>
<td>If '<em>y</em>' will configure systemd as the init system.</td>
</tr>
<tr>
<td>MONOLITHIC</td>
<td>Boolean (<em>y|n</em>)</td>
<td>If '<em>y</em>' a monolithic policy is built, otherwise a modular policy is built.</td>
</tr>
<tr>
<td>UBAC</td>
<td>Boolean (<em>y|n</em>)</td>
<td><p>If '<em>y</em>' User Based Access Control policy is built. The default for Red Hat is '<em>n</em>'. These are defined as constraints in the <em>policy/constraints</em> file. Note Version 1 of the Reference Policy did not have this entry and defaulted to Role Based Access Control.</p>
<p>The UBAC option is described at <a href="http://blog.siphos.be/2011/05/selinux-user-based-access-control/">http://blog.siphos.be/2011/05/selinux-user-based-access-control/</a>.</p></td>
</tr>
<tr>
<td>CUSTOM_BUILDOPT</td>
<td>String</td>
<td>Space separated list of custom build options.</td>
</tr>
<tr>
<td>MLS_SENS</td>
<td>Integer</td>
<td>Set the number of sensitivities in the MLS policy. Ignored on standard and MCS policies.</td>
</tr>
<tr>
<td>MLS_CATS</td>
<td>Integer</td>
<td>Set the number of categories in the MLS policy. Ignored on standard and MCS policies.</td>
</tr>
<tr>
<td>MCS_CATS</td>
<td>Integer</td>
<td>Set the number of categories in the MCS policy. Ignored on standard and MLS policies.</td>
</tr>
<tr>
<td>QUIET</td>
<td>Boolean (<em>y|n</em>)</td>
<td>If '<em>y</em>' the build system will only display status messages and error messages. This option has no effect on policy.</td>
</tr>
<tr>
<td>WERROR</td>
<td>Boolean (<em>y|n</em>)</td>
<td>If '<em>y</em>' treat warnings as errors.</td>
</tr>
</tbody>
</table>

**Table 2:** *build.conf* **Entries**

<br>

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>m4 Parameter Name in Makefile</strong></td>
<td><strong>From build.conf</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>enable_mls</td>
<td>TYPE</td>
<td>Set if MLS policy build enabled.</td>
</tr>
<tr>
<td>enable_mcs</td>
<td>TYPE</td>
<td>Set if MCS policy build enabled.</td>
</tr>
<tr>
<td>enable_ubac</td>
<td>UBAC</td>
<td>Set if UBAC set to '<em>y</em>'.</td>
</tr>
<tr>
<td>mls_num_sens</td>
<td>MLS_SENS</td>
<td>The number of MLS sensitivities configured.</td>
</tr>
<tr>
<td>mls_num_cats</td>
<td>MLS_CATS</td>
<td>The number of MLS categories configured.</td>
</tr>
<tr>
<td>mcs_num_cats</td>
<td>MCS_CATS</td>
<td>The number of MCS categories configured.</td>
</tr>
<tr>
<td>distro_$(DISTRO)</td>
<td>DISTRO</td>
<td>The distro name or blank.</td>
</tr>
<tr>
<td>direct_sysadm_daemon</td>
<td>DIRECT_INITRC</td>
<td>If <em>DIRECT_INITRC</em> entry set to '<em>y</em>'.</td>
</tr>
<tr>
<td>hide_broken_symtoms</td>
<td></td>
<td>This is set up in the <em>Makefile</em> and can be used in modules to hide errors with <em>dontaudit</em> rules (or even <em>allow</em> rules).</td>
</tr>
</tbody>
</table>

**Table 3: m4 parameters set at build time** - *These have been extracted from the Reference Policy Makefile.*

<br>

#### Reference Policy Build Options - policy/modules.conf

This file will not be present until *make conf* is run and controls
what modules are built within the policy, see the
[**Building the modules.conf File**](#building-the-modules.conf-file) section.

**Example entries:**

```
# Layer: kernel
# Module: kernel
# Required in base
#
# Policy for kernel threads, proc filesystem,and unlabeled processes and
# objects.
#
kernel = base

# Layer: admin
# Module: amanda
#
# Advanced Maryland Automatic Network Disk Archiver.
#
amanda = module

# Layer: admin
# Module: ddcprobe
#
# ddcprobe retrieves monitor and graphics card information
#

ddcprobe = off
```

The only active lines (those without comments) contain:

`<module_name> = base | module | off`

However note that the comments are important as they form part of the
documentation when it is generated by the *make html* target.

**Where:**

<table>
<tbody>
<tr>
<td>module_name</td>
<td>The name of the module to be included within the build.</td>
</tr>
<tr>
<td>base</td>
<td>The module will be in the base module for a modular policy build (build.conf entry MONOLITHIC = n).</td>
</tr>
<tr>
<td>module</td>
<td>The module will be built as a loadable module for a modular policy build. If a monolithic policy is being built (build.conf entry MONOLITHIC = y), then this module will be built into the base module.</td>
</tr>
<tr>
<td>off</td>
<td>The module will not be included in any build.</td>
</tr>
</tbody>
</table>

Generally it is up to the policy distributor to decide which modules are
in the base and those that are loadable, however there are some modules
that MUST be in the base module. To highlight this there is a special
entry at the start of the modules interface file (.if) that has the
entry `<required val="true">` as shown below (taken from the
*kernel.if* file):

```
## <summary>
##	Policy for kernel threads, proc filesystem,
##	and unlabeled processes and objects.
## </summary>
## <required val="true">
##	This module has initial SIDs.
## </required>
```

The *modules.conf* file will also reflect that a module is required in
the base by adding a comment 'Required in base' when the make conf
target is executed (as all the *.if* files are checked during this
process and the *modules.conf* file updated).

```
# Layer: kernel
# Module: kernel
# Required in base
#
# Policy for kernel threads, proc filesystem,
# and unlabeled processes and objects.
#
kernel = base
```

Those marked as `Required in base` are shown in
**Table 4: Mandatory modules.conf Entries** (note that Fedora and the standard
reference policy are different)

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Layer</strong></td>
<td><strong>Module Name</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>kernel</td>
<td>corecommands</td>
<td><p>Core policy for shells, and generic programs in:</p>
<p>/bin, /sbin, /usr/bin, and /usr/sbin. </p>
<p>The .fc file sets up the labels for these items. </p>
<p>All the interface calls start with 'corecmd_'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>corenetwork</td>
<td><p>Policy controlling access to network objects and also contains the initial SIDs for these.</p>
<p>The <em>.if</em> file is large and automatically generated. All the interface calls start with '<em>corenet_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>devices</td>
<td><p>This module creates the device node concept and provides the policy for many of the device files. Notable exceptions are the mass storage and terminal devices that are covered by other modules (that is a char or block device file, usually in /dev). All types that are used to label device nodes should use the dev_node macro.</p>
<p>Additionally this module controls access to three things:</p>
<p>All the interface calls start with '<em>dev_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>domain</td>
<td><p>Contains the core policy for forming and managing domains.</p>
<p>All the interface calls start with '<em>domain_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>files</td>
<td><p>This module contains basic filesystem types and interfaces and includes:</p>
<p>All the interface calls start with '<em>files_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>filesystem</td>
<td><p>Contains the policy for filesystems and the initial SID.</p>
<p>All the interface calls start with '<em>fs_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>kernel</td>
<td><p>Contains the policy for kernel threads, proc filesystem, and unlabeled processes and objects. This module has initial SIDs.</p>
<p>All the interface calls start with '<em>kernel_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>mcs</td>
<td><p>Policy for Multicategory security. The .te file only contains attributes used in MCS policy.</p>
<p>All the interface calls start with '<em>mcs_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>mls</td>
<td><p>Policy for Multilevel security. The .te file only contains attributes used in MLS policy.</p>
<p>All the interface calls start with '<em>mls_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>selinux</td>
<td><p>Contains the policy for the kernel SELinux security interface (selinuxfs).</p>
<p>All the interface calls start with '<em>selinux_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>terminal</td>
<td><p>Contains the policy for terminals.</p>
<p>All the interface calls start with '<em>term_</em>'.</p></td>
</tr>
<tr>
<td>kernel</td>
<td>ubac</td>
<td><p>Disabled by Fedora but enabled on standard Ref Policy.</p>
<p>Support user-based access control.</p></td>
</tr>
<tr>
<td>system</td>
<td>application</td>
<td><p>Enabled by Fedora but not standard Ref Policy.</p>
<p>Defines attributes and interfaces for all user apps.</p></td>
</tr>
<tr>
<td>system</td>
<td>setrans</td>
<td><p>Enabled by Fedora but not standard Ref Policy.</p>
<p>Support for <em><strong>mcstransd</strong>(8)</em>.</p></td>
</tr>
</tbody>
</table>

**Table 4: Mandatory modules.conf Entries**

<br>

##### Building the modules.conf File

The file can be created by an editor, however it is generally built
initially by *make conf* that will add any additional modules to the file.
The file can then be edited to configure the required modules as base,
module or off.

As will be seen in the
[**Installing and Building the Reference Policy Source**](#installing-and-building-the-reference-policy-source) section, the Fedora reference policy source comes with a number of
pre-configured files that are used to produce the required policy including
multiple versions of the *modules.conf* file.

<br>

### Source Installation and Build Make Options

This section explains the various make options available that have been
taken from the *README* file.

-   **Table 5** describes the general make targets
-   **Table 6** describes the modular policy make targets
-   **Table 7** describes the monolithic policy make targets.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Make Target</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>install-src</td>
<td>Install the policy sources into /etc/selinux/NAME/src/policy, where NAME is defined in the build.conf file. If it is not defined, then TYPE is used instead. If a build.conf does not have the information, then the Makefile will default to the current entry in the /etc/selinux/config file or default to refpolicy. A pre-existing source policy will be moved to /etc/selinux/NAME/src/policy.bak.</td>
</tr>
<tr>
<td>conf</td>
<td><p>Regenerate policy.xml, and update/create modules.conf and booleans.conf. This should be done after adding or removing modules, or after running the bare target. If the configuration files exist, their settings will be preserved. This must be run on policy sources that are checked out from the CVS repository before they can be used.</p>
<p>Note that if <em>make bare</em> has been executed before this make target, or it is a first build, then the <em>modules/kernel/corenetwork.??.in</em> files will be used to generate the <em>corenetwork.te</em> and <em>corenetwork.if</em> module files. These <em>*.in</em> files may be edited to configure network ports etc. (see the <em># network_node examples</em> entries in <em>corenetwork.te</em>).</p></td>
</tr>
<tr>
<td>clean</td>
<td>Delete all temporary files, compiled policy, and file_contexts. Configuration files are left intact.</td>
</tr>
<tr>
<td>bare</td>
<td>Do the clean make target and also delete configuration files, web page documentation, and policy.xml.</td>
</tr>
<tr>
<td>html</td>
<td>Regenerate policy.xml and create web page documentation in the doc/html directory.</td>
</tr>
<tr>
<td>install-appconfig</td>
<td>Installs the appropriate SELinux-aware configuration files.</td>
</tr>
</tbody>
</table>

**Table 5: General Build Make Targets**


<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Make Target</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>base</td>
<td>Compile and package the base module. This is the default target for modular policies.</td>
</tr>
<tr>
<td>modules</td>
<td>Compile and package all Reference Policy modules configured to be built as loadable modules.</td>
</tr>
<tr>
<td>MODULENAME.pp</td>
<td>Compile and package the <em>MODULENAME</em> Reference Policy module.</td>
</tr>
<tr>
<td>all</td>
<td>Compile and package the base module and all Reference Policy modules configured to be built as loadable modules.</td>
</tr>
<tr>
<td>install</td>
<td>Compile, package, and install the base module and Reference Policy modules configured to be built as loadable modules.</td>
</tr>
<tr>
<td>load</td>
<td>Compile, package, and install the base module and Reference Policy modules configured to be built as loadable modules, then insert them into the module store.</td>
</tr>
<tr>
<td>validate</td>
<td>Validate if the configured modules can successfully link and expand.</td>
</tr>
<tr>
<td>install-headers</td>
<td>Install the policy headers into /usr/share/selinux/NAME. The headers are sufficient for building a policy module locally, without requiring the complete Reference Policy sources. The build.conf settings for this policy configuration should be set before using this target.</td>
</tr>
<tr>
<td>install-docs</td>
<td>Build and install the documentation and example module source with Makefile. The default location is <em>/usr/share/doc/refpolicy-VERSION</em>, where the version is the value in the <em>VERSION</em> file.</td>
</tr>
</tbody>
</table>

**Table 6: Modular Policy Build Make Targets**

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Make Target</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>policy</td>
<td>Compile a policy locally for development and testing. This is the default target for monolithic policies.</td>
</tr>
<tr>
<td>install</td>
<td>Compile and install the policy and file contexts.</td>
</tr>
<tr>
<td>load</td>
<td>Compile and install the policy and file contexts, then load the policy.</td>
</tr>
<tr>
<td>enableaudit</td>
<td>Remove all dontaudit rules from policy.conf.</td>
</tr>
<tr>
<td>relabel</td>
<td>Relabel the filesystem.</td>
</tr>
<tr>
<td>checklabels</td>
<td>Check the labels on the filesystem, and report when a file would be relabeled, but do not change its label.</td>
</tr>
<tr>
<td>restorelabels</td>
<td>Relabel the filesystem and report each file that is relabeled.</td>
</tr>
</tbody>
</table>

**Table 7: Monolithic Policy Build Make Targets**

<br>

### Booleans, Global Booleans and Tunable Booleans

The three files *booleans.conf*, *global_booleans* and *global_tunables* are
built and used as follows:

<table>
<tbody>
<tr>
<td>booleans.conf</td>
<td><p>This file is generated / updated by <em>make conf</em>, and contains all the booleans in the policy with their default values. If tunable and global booleans are implemented then these are also included. </p>
<p>This file can also be delivered as a part of the Fedora reference policy source as shown in the <a href="#installing-and-building-the-reference-policy-source">Installing and Building the Reference Policy Source</a> section. This is generally because other default values are used for booleans and not those defined within the modules themselves (i.e. distribution specific booleans). When the <em>make install</em> is executed, this file will be used to set the default values. </p>
<p>Note that if booleans are updated locally the policy store will contain a <a href="policy_store_config_files.md#activebooleans.local"><em>booleans.local</em></a> file.</p>
<p>In SELinux enabled systems that support the policy store features (modular policies) this file is not installed as <em>/etc/selinux/&lt;SELINUXTYPE&gt;/booleans</em>.</p></td>
</tr>
<tr>
<td>global_booleans</td>
<td><p>These are booleans that have been defined in the <em>global_tunables</em> file using the <a href="#gen_bool-macro"><em>gen_bool</em></a> macro. They are normally booleans for managing the overall policy and currently consist of the following (where the default values are <em>false</em>):</p>
<p>secure_mode</p></td>
</tr>
<tr>
<td>global_tunables</td>
<td>These are booleans that have been defined in module files using the <a href="#gen_tunable-macro"><em>gen_tunable</em></a> macro and added to the <em>global_tunables</em> file by <em>make conf</em>. The <a href="#tunable_policy-macro"><em>tunable_policy</em></a> macros are defined in each module where policy statements or interface calls are required. They are booleans for managing specific areas of policy that are global in scope. An example is <em>allow_execstack</em> that will allow all processes running in <em>unconfined_t</em> to make their stacks executable.</td>
</tr>
</tbody>
</table>

<br>

### Modular Policy Build Structure

This section explains the way a modular policy is constructed, this does
not really need to be known but is used to show the files used that can
then be investigated if required.

When *make all* or *make load* or *make install* are executed the *build.conf*
and *modules.conf* files are used to define the policy name and what
modules will be built in the base and those as individual loadable
modules.

Basically the source modules (*.te*, *.if* and *.fc*) and core flask
files are rebuilt in the *tmp* directory where the reference policy
macros in the source modules will be expanded to form
actual policy language statements as described in the
[**Kernel Policy Language**](kernel_policy_language.md#kernel-policy-language)
section. **Table 8: Base Module Build** shows these temporary files that are
used to form the *base.conf* (for modular policies) or the *policy.conf*
(for a monolithic policy) file during policy generation.

The *base.conf* file will consist of language statements taken from the
module defined as *base* in the *modules.conf* file along with the
constraints, users etc. that are required to build a complete policy.

The individual loadable modules are built in much the same way as shown
in **Table 9: Module Build**.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Base Policy Component Description</strong></td>
<td><strong>Policy Source File Name (relative to ./policy/policy)</strong></td>
<td><strong>./policy/tmp File Name</strong></td>
</tr>
<tr>
<td>The object classes supported by the kernel.</td>
<td>flask/security_classes</td>
<td>pre_te_files.conf</td>
</tr>
<tr>
<td>The initial SIDs supported by the kernel.</td>
<td>flask/initial_sids</td>
<td></td>
</tr>
<tr>
<td>The object class permissions supported by the kernel.</td>
<td>flask/access_vectors</td>
<td></td>
</tr>
<tr>
<td>This is either the expanded mls or mcs file depending on the type of policy being built.</td>
<td>mls or mcs</td>
<td></td>
</tr>
<tr>
<td>These are the policy capabilities that can be configured / enabled to support the policy.</td>
<td>policy_capabilities</td>
<td></td>
</tr>
<tr>
<td>This area contains all the attribute, bool, type and typealias statements extracted from the *.te and *.if files that form the base module.</td>
<td><p>modules/*/*.te</p>
<p>modules/*/*.if</p></td>
<td>all_attrs_types.conf</td>
</tr>
<tr>
<td>Contains the global and tunable bools extracted from the conf files. </td>
<td><p>global_bools.conf</p>
<p>global_tunables.conf</p></td>
<td>global_bools.conf</td>
</tr>
<tr>
<td>Contains the rules extracted from each of the modules .te and .if files defined in the modules.conf file as 'base'.</td>
<td>base modules</td>
<td>only_te_rules.conf</td>
</tr>
<tr>
<td>Contains the expanded users from the users file.</td>
<td>users</td>
<td>all_post.conf</td>
</tr>
<tr>
<td>Contains the expanded constraints from the constraints file.</td>
<td>constraints</td>
<td></td>
</tr>
<tr>
<td>Contains the default SID labeling extracted from the *.te files.</td>
<td>modules/*/*.te</td>
<td></td>
</tr>
<tr>
<td>Contains the fs_use_xattr, fs_use_task, fs_use_trans and genfscon statements extracted from each of the modules .te and .if files defined in the modules.conf file as 'base'.</td>
<td><p>modules/*/*.te</p>
<p>modules/*/*.if</p></td>
<td></td>
</tr>
<tr>
<td>Contains the netifcon, nodecon and portcon statements extracted from each of the modules .te and .if files defined in the modules.conf file as 'base'.</td>
<td><p>modules/*/*.te</p>
<p>modules/*/*.if</p></td>
<td></td>
</tr>
<tr>
<td>Contains the expanded file context file entries extracted from the *.fc files defined in the modules.conf file as 'base'.</td>
<td>modules/*/*.fc</td>
<td>base.fc.tmp</td>
</tr>
<tr>
<td>Expanded seusers file.</td>
<td>seusers</td>
<td>seusers</td>
</tr>
<tr>
<td><p>These are the commands used to compile, link and load the base policy module:</p>
<p>checkmodule base.conf -o tmp/base.mod</p>
<p>semodule_package -o base.conf -m base_mod -f base_fc -u users_extra -s tmp/seusers</p>
<p>semodule -s $(NAME) -b base.pp) -i and each module .pp file</p>
<p>The 'NAME' is that defined in the build.conf file.</p></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

**Table 8: Base Module Build** - *This shows the temporary build files used to build the base module 'base.conf' as a part of the 'make' process. Note that the modules marked as base in modules.conf are built here.*

<br>

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Base Policy Component Description</strong></td>
<td><strong>Policy Source File Name (relative to ./policy/policy)</strong></td>
<td><strong>./policy/tmp File Name</strong></td>
</tr>
<tr>
<td>For each module defined as 'module' in the modules.conf configuration file, a source module is produced that has been extracted from the *.te and *.if file for that module.</td>
<td><p>modules/*/&lt;module_name&gt;.te</p>
<p>modules/*/&lt;module_name&gt;.if</p></td>
<td><p>&lt;module_name&gt;.tmp</p></td>
</tr>
<tr>
<td>For each module defined as 'module' in the modules.conf configuration file, an object module is produced from executing the checkmodule command shown below.</td>
<td>tmp/&lt;module_name&gt;.tmp</td>
<td>&lt;module_name&gt;.mod</td>
</tr>
<tr>
<td>For each module defined as 'module' in the modules.conf configuration file, an expanded file context file is built from the &lt;module_name&gt;.fc file.</td>
<td>modules/*/&lt;module_name&gt;.fc</td>
<td>base.fc.tmp</td>
</tr>
<tr>
<td colspan="3"><p>This command is used to compile each module:</p>
<p>checkmodule tmp/&lt;module_name&gt;.tmp -o tmp/&lt;module_name&gt;.mod</p>
<p>Each module is packaged and loaded with the base module using the following commands:</p>
<p>a) semodule_package -o base.conf -m base_mod -f base_fc -u users_extra -s tmp/seusers</p>
<p>b) semodule -s $(NAME) -b base.pp) -i and each module .pp file</p>
<p>The 'NAME' is that defined in the build.conf file.</p></td>
</tr>
</tbody>
</table>

**Table 9: Module Build** - *This shows the module files and the temporary build files used to build each module as a part of the 'make' process (i.e. those modules marked as module in modules.conf).*

<br>

### Creating Additional Layers

One objective of the reference policy is to separate the modules into
different layers reflecting their 'service' (e.g. kernel, system, app
etc.). While it can sometimes be difficult to determine where a
particular module should reside, it does help separation, however
because the way the build process works, each module must have a unique
name.

If a new layer is required, then the following will need to be
completed:

1.  Create a new layer directory *./policy/modules/LAYERNAME* that
    reflects the layer's purpose.
2.  In the *./policy/modules/LAYERNAME* directory create a metadata.xml
    file. This is an XML file with a summary tag and optional desc (long
    description) tag that should describe the purpose of the layer and
    will be used as a part of the documentation. An example is as
    follows:

`<summary>ABC modules for the XYZ components.</summary>`

<br>

## Installing and Building the Reference Policy Source

This section will give a brief overview of how to build the Reference
Policy for an MCS modular build that is similar (but not the same) as
the Fedora targeted policy. The Fedora version of the targeted
policy build is discussed but building without using the rpm spec file
is more complex.

<br>

### Building Standard Reference Policy

This will run through a simple configuration process and build of a
reference policy similar to the Fedora targeted policy. By convention
the source is installed in a central location and then for each type of
policy a copy of the source is installed at
*/etc/selinux/&lt;SELINUXTYPE&gt;/src/policy*.

The basic steps are:

1.  Install master Reference Policy Source and add the contributed
    modules:

```
# Check out the core policy:
git clone https://github.com/SELinuxProject/refpolicy.git

cd refpolicy
# Add the contibuted modules (policy/modules/contrib)
git submodule init
git submodule update
```

2.  Edit the *build.conf* file to reflect the policy to be built, the
    minimum required is setting the *NAME =* entry. An example file with
    *NAME = refpolicy-test* is as follows:

```
########################################
#
# Policy build options
#

# Policy version
# By default, checkpolicy will create the highest
# version policy it supports.  Setting this will
# override the version.  This only has an
# effect for monolithic policies.
#OUTPUT_POLICY = 18

# Policy Type
# standard, mls, mcs
# Note Red Hat always build the MCS Policy Type for their 'targeted' version.
TYPE = mcs

# Policy Name
# If set, this will be used as the policy
# name.  Otherwise the policy type will be
# used for the name.
# This entry is also used by the 'make install-src' process to copy the
# source to the /etc/selinux/<NAME>/src/policy directory.
NAME = refpolicy-test

# Distribution
# Some distributions have portions of policy
# for programs or configurations specific to the
# distribution.  Setting this will enable options
# for the distribution.
# redhat, gentoo, debian, suse, and rhel4 are current options.
# Fedora users should enable redhat.
DISTRO = redhat

# Unknown Permissions Handling
# The behavior for handling permissions defined in the
# kernel but missing from the policy.  The permissions
# can either be allowed, denied, or the policy loading
# can be rejected.
# allow, deny, and reject are current options.
# Fedora use allow for all policies except MLS that uses 'deny'.
UNK_PERMS = deny

# Direct admin init
# Setting this will allow sysadm to directly
# run init scripts, instead of requring run_init.
# This is a build option, as role transitions do
# not work in conditional policy.
DIRECT_INITRC = n

# Systemd
# Setting this will configure systemd as the init system.
SYSTEMD = y

# Build monolithic policy.  Putting y here
# will build a monolithic policy.
MONOLITHIC = n

# User-based access control (UBAC)
# Enable UBAC for role separations.
# Note Fedora disables UBAC.
UBAC = n

# Custom build options.  This field enables custom
# build options.  Putting foo here will enable
# build option blocks named foo.  Options should be
# separated by spaces.
CUSTOM_BUILDOPT =

# Number of MLS Sensitivities
# The sensitivities will be s0 to s(MLS_SENS-1).
# Dominance will be in increasing numerical order
# with s0 being lowest.
MLS_SENS = 16

# Number of MLS Categories
# The categories will be c0 to c(MLS_CATS-1).
MLS_CATS = 1024

# Number of MCS Categories
# The categories will be c0 to c(MLS_CATS-1).
MCS_CATS = 1024

# Set this to y to only display status messages
# during build.
QUIET = n

# Set this to treat warnings as errors.
WERROR = n
```

3.  Run *make install-src* to install source at policy build location.
4.  Change to the */etc/selinux/&lt;SELINUXTYPE&gt;/src/policy* directory where
    an unconfigured basic policy has been installed.
5.  Run *make conf* to build an initial *policy/booleans.conf* and
    *policy/modules.conf* files. For this simple configuration these
    files will not be edited.
-   This process will also build the *policy/modules/kernel/corenetwork.te*
    / *corenetwork.if* files if not already present. These would be based on
    the contents of *corenetwork.te.in* and *corenetwork.if.in*
    configuration files (for this simple configuration these files will not
    be edited).
6.  Run *make load* to build the policy, add the modules to the store
    and install the binary kernel policy plus its supporting
    configuration files.
7.  As the Reference Policy has NOT been tailored specifically for Fedora,
    it MUST be run in permissive mode.
8.  The policy should now be built and can be checked using tools such
    as ***apol**(8)* or loaded by editing the */etc/selinux/config*
    file, running '*touch /.autorelabel*' and rebooting the system.

<br>

### Building the Fedora Policy

Note, the Fedora [**selinux-policy**](https://github.com/fedora-selinux)
started life as **Reference Policy Version: 2.20130424** and, is now basically
a large patch on top of the original Reference Policy.

Building Fedora policies by hand is complex as they use the
*rpmbuild/SPECS/selinux-policy.spec* file, therefore this section will
give an overview of how this can be achieved, the reader can then
experiment (the spec file gives an insight). The build process assumes
that an equivelent '*targeted*' policy will be built named
'*targeted-FEDORA*'.

Note: The following steps were tested on Fedora 31 with no problems.

Install the source as follows:

`rpm -Uvh selinux-policy-<version>.src.rpm`

The *rpmbuild/SOURCES* directory contents that will be used to build a copy
of the **targeted** policy are as follows (there are other files, however
they are not required for this exercise):

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>File Name</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>selinux-policy-&lt;commit_num&gt;.tar.gz</td>
<td><p>The Reference Policy version 2.20130424 with Fedora specific updates that should be unpacked into:</p>
<p>rpmbuild/SOURCES/selinux-policy-&lt;commit_num&gt;</p></td>
</tr>
<tr>
<td>selinux-policy-contrib-&lt;commit_num&gt;.tar.gz</td>
<td><p>The Reference Policy contribution modules. Unpack the files and install them into:</p>
<p>./selinux-policy-&lt;commit_num&gt;/policy/modules/contrib</p></td>
</tr>
<td>container-selinux.tgz</td>
<td><p>Fedora Containers module. Unpack and then install into:</p>
<p>./selinux-policy-&lt;commit_num&gt;/policy/modules/contrib</p></td>
</tr>
<tr>
<td>permissivedomains.cil</td>
<td>Badly named file – just adds <em>system_r</em> to <em>roleattributeset</em>. Copy this to ./selinux-policy-&lt;commit_num&gt; as it will be installed by <em>semodule</em> once the policy has been built.</td>
</tr>
<tr>
<td>modules-targeted-base.conf<p>modules-targeted-contrib.conf</p></td>
<td><p>Concatenate both files and copy this to become:</p>
<p><em>./selinux-policy-&lt;commit_num&gt;/policy/modules.conf</em></p></td>
</tr>
<tr>
<td>booleans-targeted.conf</td>
<td>Replace the <em>./selinux-policy-&lt;commit_num&gt;/policy/booleans.conf</em> file with this version. </td>
</tr>
<tr>
<td>securetty_types-targeted</td>
<td>Replace the <em>./selinux-policy-&lt;commit_num&gt;/config/appconfig-mcs/securetty_types</em> file with this version.</td>
</tr>
<tr>
<td>users-targeted</td>
<td>Replace the <em>./selinux-policy-&lt;commit_num&gt;/policy/users</em> file with this version.</td>
</tr>
</tbody>
</table>

The basic steps are:

1.  Edit the *build.conf* file to reflect the policy to be built (as
    this is an earlier version of the Reference Policy it has less
    options than the current Reference Policy):
```
############################################
# Policy build options
#
# Policy version
# By default, checkpolicy will create the highest version policy it supports.
# Setting this will override the version. This only has an effect for
# monolithic policies.
#OUTPUT_POLICY = 18

# Policy Type
# standard, mls, mcs. Note Red Hat builds the MCS Policy Type
# for their 'targeted' version.
TYPE = mcs

# Policy Name
# If set, this will be used as the policy name. Otherwise the policy type
# will be used for the name. This entry is also used by the 'make install-src'
# process to copy the source to the:
#    /etc/selinux/<SELINUXTYPE>/src/policy directory.
NAME = targeted-FEDORA

# Distribution
# Some distributions have portions of policy for programs or configurations
# specific to the distribution. Setting this will enable options for the
# distribution. redhat, gentoo, debian, suse, and rhel4 are current options.
# Fedora users should enable redhat.
DISTRO = redhat

# Unknown Permissions Handling
# The behaviour for handling permissions defined in the kernel but missing
# from the policy. The permissions can either be allowed, denied, or
# the policy loading can be rejected.
# allow, deny, and reject are current options. Fedora use allow for all
# policies except MLS that uses 'deny'.
UNK_PERMS = allow

# Direct admin init
# Setting this will allow sysadm to directly run init scripts, instead of
# requiring run_init. This is a build option, as role transitions do not
# work in conditional policy.
DIRECT_INITRC = n

# Build monolithic policy. Putting y here will build a monolithic
policy.
MONOLITHIC = n

# User-based access control (UBAC)
# Enable UBAC for role separations. Note Fedora disables UBAC.
UBAC = n

# Custom build options. This field enables custom build options. Putting
# foo here will enable build option blocks foo. Options should be
separated by spaces.
CUSTOM_BUILDOPT =

# Number of MLS Sensitivities
# The sensitivities will be s0 to s(MLS_SENS-1). Dominance will be in
# increasing numerical order with s0 being lowest.
MLS_SENS = 16

# Number of MLS Categories.
# The categories will be c0 to c(MLS_CATS-1).
MLS_CATS = 1024

# Number of MCS Categories
# The categories will be c0 to c(MLC_CATS-1).
MCS_CATS = 1024

# Set this to y to only display status messages during build.
QUIET = n
```

2. From *rpmbuild/SOURCES/./selinux-policy-&lt;commit_num&gt;* run *make conf*
   to initialise the build (it creates two important files in
   *./selinux-policy-&lt;commit_num&gt;/policy/modules/kernel* called
   *corenetwork.te* and *corenetwork.if*).
3.  From *rpmbuild/SOURCES/./selinux-policy-&lt;commit_num&gt;* run
    *make install-src* to install source at policy build location.
4.  Change to the */etc/selinux/targeted-FEDORA/src/policy* directory where
    the policy has been installed.
5.  Run *make load* to build the policy, add the modules to the store
    and install the binary kernel policy plus its supporting
    configuration files.
-   Note that the policy store will default to
    */var/lib/selinux/targeted-FEDORA*, with the modules in
    *active/modules/400/&lt;module_name&gt;*, there will also be CIL
    versions of the modules.
6.  Install the *permissivedomains.cil* module as follows:
-   `semodule -s targeted-FEDORA -i permissivedomains.cil`
7.  The policy should now be built and can be checked using tools such
    as ***apol**(8)* or loaded by editing the */etc/selinux/config*
    file (setting to **permissive** mode for safety), running
    '*touch /.autorelabel*' and rebooting the system. It should have the
    same number of rules, types, classes etc. as the original release.

<br>

## Reference Policy Headers

This method of building policy and adding new modules is used for
distributions that do not require access to the source code.

Note that the Reference Policy header and the Fedora policy header
installations are slightly different as described below.

### Building and Installing the Header Files

To be able to fully build the policy headers from the reference policy
source two steps are required:

1.  Ensure the source is installed and configured as described in the
    [**Installing and Building the Reference Policy Source**](#installing-and-building-the-reference-policy-source)
    section. This is because the *make load* (or *make install*) command
    will package all the modules as defined in the *modules.conf* file,
    producing a *base.pp* and the relevant *.pp* packages. The build
    process will then install these in the
    */usr/share/selinux/&lt;SELINUXTYPE&gt;* directory.
2.  Execute the *make install-headers* that will:
-   Produce a *build.conf* file that represents the contents of the
    master *build.conf* file and place it in the
    */usr/share/selinux/&lt;SELINUXTYPE&gt;/include* directory.
-   Produce the XML documentation set that reflects the source and place
    it in the */usr/share/selinux/&lt;SELINUXTYPE&gt;/include* directory.
-   Copy a development *Makefile* for building from policy headers to
    the */usr/share/selinux/&lt;SELINUXTYPE&gt;/include* directory.
-   Copy the support macros *.spt* files to the
    */usr/share/selinux/&lt;SELINUXTYPE&gt;/include/support* directory. This
    will also include an *all_perms.spt* file that will contain
    macros to allow all classes and permissions to be resolved.
-   Copy the module interface files (*.if*) to the relevant module
    directories at: */usr/share/selinux/&lt;SELINUXTYPE&gt;/include/modules*.

<br>

### Using the Reference Policy Headers

Note that this section describes the standard Reference Policy headers,
the Fedora installation is slightly different and described in the
[**Using Fedora Supplied Headers**](#using-fedora-supplied-headers) section.

Once the headers are installed as defined above, new modules can be
built in any local directory. An example set of module files are located
in the reference policy source at
*/etc/selinux/&lt;SELINUXTYPE&gt;/src/policy/doc* and are called *example.te*,
*example.if*, and *example.fc*.

During the header build process a *Makefile* was included in the headers
directory. This *Makefile* can be used to build the example modules by
using makes *-f* option as follows (assuming that the example module
files are in the local directory):

`make -f /usr/share/selinux/<NAME>/include/Makefile`

However there is another *Makefile* (*./policy/doc Makefile.example*)that can
be installed in the users home directory (*$HOME*) that will call the master
*Makefile*:

```
AWK ?= gawk

NAME ?= $(shell $(AWK) -F= '/^SELINUXTYPE/{ print $$2 }' /etc/selinux/config)
SHAREDIR ?= /usr/share/selinux
HEADERDIR := $(SHAREDIR)/$(NAME)/include

include $(HEADERDIR)/Makefile
```

**Table 10: Header Policy Build Make Targets** shows the make targets for
modules built from headers.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Make Target</strong></td>
<td><strong>Comments</strong></td>
</tr>
<tr>
<td>MODULENAME.pp</td>
<td>Compile and package the MODULENAME local module.</td>
</tr>
<tr>
<td>all</td>
<td>Compile and package the modules in the current directory.</td>
</tr>
<tr>
<td>load</td>
<td>Compile and package the modules in the current directory, then insert them into the module store.</td>
</tr>
<tr>
<td>refresh</td>
<td>Attempts to reinsert all modules that are currently in the module store from the local and system module packages.</td>
</tr>
<tr>
<td>xml</td>
<td>Build a policy.xml from the XML included with the base policy headers and any XML in the modules in the current directory.</td>
</tr>
</tbody>
</table>

**Table 10: Header Policy Build Make Targets**

<br>

### Using Fedora Supplied Headers

The Fedora distribution installs the headers in a slightly different
manner as Fedora installs:

-   A *modules-base.lst* and *modules-contrib.lst* containing a list of
    installed modules under */usr/share/selinux/&lt;*NAME*&gt;*.
-   The development header files are installed in the
    */usr/share/selinux/devel* directory. The example modules are also in
    this directory and the *Makefile* is also slightly different to that
    used by the Reference Policy source.
-   The documentation is installed in the
    */usr/share/doc/selinux-policy/html* directory.

<br>

## Reference Policy Support Macros

This section explains some of the support macros used to build reference
policy source modules (see **Table 11** for the list). These macros are
located at:
-   *./policy/support* for the reference policy source.
-   */usr/share/selinux/&lt;*NAME*&gt;/include/support* for Reference
    Policy installed header files.
-   */usr/share/selinux/devel/support* for Fedora installed header files.

The following support macro file contents are explained:
-   *loadable_module.spt* - Loadable module support.
-   *misc_macros.spt* - Generate users, bools and security contexts.
-   *mls_mcs_macros.spt* - MLS / MCS support.
-   *file_patterns.spt* - Sets up allow rules via parameters for files and
directories.
-   *ipc_patterns.spt* - Sets up allow rules via parameters for Unix domain
sockets.
-   *misc_patterns.spt* - Domain and process transitions.
-   *obj_perm_sets.spt* - Object classes and permissions.

When the header files are installed the *all_perms.spt* support macro
file is also installed that describes all classes and permissions
configured in the original source policy.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Macro Name</strong></td>
<td><strong>Function</strong></td>
<td><strong>Macro file name</strong></td>
</tr>
<tr>
<td>policy_module</td>
<td>For adding the module statement and mandatory <em>require</em> block entries.</td>
<td rowspan="7">loadable_module.spt</td>
</tr>
<td>gen_require</td>
<td>For use in interfaces to optionally insert a <em>require</em> block</td>
</tr>
<tr>
<td>template</td>
<td>Generate <em>template</em> interface block</td>
</tr>
<tr>
<td>interface</td>
<td>Generate the access <em>interface</em> block</td>
</tr>
<tr>
<td>optional_policy</td>
<td>Optional policy handling </td>
</tr>
<tr>
<td>gen_tunable</td>
<td>Tunable declaration</td>
</tr>
<tr>
<td>tunable_policy</td>
<td>Tunable policy handling</td>
</tr>
<tr>
<td>gen_user</td>
<td>Generate an SELinux user</td>
<td rowspan="3"><p>misc_macros.spt</p></td>
</tr>
<tr>
<td>gen_context</td>
<td>Generate a security context</td>
</tr>
<tr>
<td>gen_bool</td>
<td>Generate a boolean</td>
</tr>
<tr>
<td>gen_cats</td>
<td>Declares categories <em>c0</em> to <em>c(N-1)</em></td>
<td rowspan="8"><p>mls_mcs_macros.spt</p></td>
</tr>
<tr>
<td>gen_sens</td>
<td>Declares sensitivities <em>s0</em> to <em>s(N-1)</em> with dominance in increasing numeric order with <em>s0</em> lowest, <em>s(N-1)</em> highest.</td>
</tr>
<tr>
<td>gen_levels</td>
<td>Generate levels from <em>s0</em> to <em>(N-1)</em> with categories <em>c0</em> to <em>(M-1)</em></td>
</tr>
<tr>
<td>mls_systemlow</td>
<td rowspan="4">Basic level names for system low and high</td>
</tr>
<tr>
<td>mls_systemhigh</td>
</tr>
<tr>
<td>mcs_systemlow</td>
</tr>
<tr>
<td>mcs_systemhigh</td>
</tr>
<tr>
<td>mcs_allcats</td>
<td>Allocates all categories</td>
</tr>
</tbody>
</table>

**Table 11: Support Macros described in this section**

Notes:

1.  The macro calls can be in any configuration file read by the build
    process and can be found in (for example) the *users*, *mls*, *mcs*
    and *constraints* files.
2.  There are four main m4 *ifdef* parameters used within modules:
-   *enable_mcs* - this is used to test if the MCS policy is being
    built.
-   *enable_mls* - this is used to test if the MLS policy is being
    built.
-   *enable_ubac* - this enables the user based access control within
    the *constraints* file.
-   *hide_broken_symptoms* - this is used to hide errors in modules
    with *dontaudit* rules.

These are also mentioned as they are set by the initial build process
with examples shown in the [*ifdef*](#ifdef-ifndef-parameters) section.

1.  The macro examples in this section have been taken from the
    reference policy module files and shown in each relevant "**Example
    Macro**" section. The macros are then expanded by the build process
    to form modules containing the policy language statements and rules
    in the *tmp* directory. These files have been extracted and modified
    for readability, then shown in each relevant "**Expanded Macro**"
    section.
2.  An example policy that has had macros expanded is shown in the
    [**Module Expansion Process**](#module-expansion-process)
    section.
3.  Be aware that spaces between macro names and their parameters are
    not allowed:

Correct:

`policy_module(ftp, 1.7.0)`

Incorrect:

`policy_module (ftp, 1.7.0)`

<br>

### Loadable Policy Macros

The loadable policy module support macros are located in the
*loadable_module.spt* file.

#### `policy_module` Macro

This macro will add the [**`module`**](modular_policy_statements.md#module)
to a loadable module, and automatically add a
[**`require`**](modular_policy_statements.md#require) with pre-defined
information for all loadable modules such as the `system_r` role, kernel
classes and permissions, and optionally MCS / MLS information
(`sensitivity` and `category` statements).

****The macro definition is:****

`policy_module(module_name,version)`

**Where:**

<table>
<tbody>
<tr>
<td><code>policy_module</code></td>
<td>The <code>policy_module</code> macro keyword.</td>
</tr>
<tr>
<td><code>module_name</code></td>
<td>The module identifier that must be unique in the module layers.</td>
</tr>
<tr>
<td><code>version_number</code></td>
<td>The module version number in M.m.m format (where M = major version number and m = minor version numbers).</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the modules/services/ftp.te module:
#

policy_module(ftp, 1.23.0)
```

**Expanded Macro:**

```
# This is the expanded macro from the tmp/ftp.tmp file:
#
module ftp 1.23.0;

require {
	role system_r;
	class security {compute_av compute_create .... };
	....
	class capability2 (mac_override mac_admin };
	# If MLS or MCS configured then the:
	sensitivity s0;
	....
	category c0;
	....
}
```

<br>

#### `gen_require` Macro

For use within module files to insert a `require` block.

**The macro definition is:**

```
gen_require(`require_statements`)
```

**Where:**

<table>
<tbody>
<tr>
<td><code>gen_require</code></td>
<td>The <code>gen_require</code> macro keyword.</td>
</tr>
<tr>
<td><code>require_statements</code></td>
<td>These statements consist of those allowed in the policy language <a href="modular_policy_statements.md#require"><code>require</code> Statement</a>.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the modules/services/cron.te module:
#

gen_require(`class passwd rootok;')
```

**Expanded Macro:**

```
# This is the expanded macro from the tmp/cron.tmp file:
#

require {
	class passwd rootok;
}
```

<br>

#### `optional_policy` Macro

For use within module files to insert an `optional` block that will be
expanded by the build process only if the modules containing the access
or template interface calls that follow are present. If one module is
present and the other is not, then the optional statements are not
included.

**The macro definition is:**

```
optional_policy(`optional_statements`)
```

**Where:**

<table>
<tbody>
<tr>
<td><code>optional_policy</code></td>
<td>The <code>optional_policy</code> macro keyword.</td>
</tr>
<tr>
<td><code>optional_statements</code></td>
<td>These statements consist of those allowed in the policy language <a href="modular_policy_statements.md#optional"><code>optional</code></a> Statement</a>. However they can also be <a href="#interface-macro"><code>interface</code> template</a> or support macro calls.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the modules/services/ftp.te module and
# shows the optional_policy macro with two levels.
#

optional_policy(`
	corecmd_exec_shell(ftpd_t)

	files_read_usr_files(ftpd_t)

	cron_system_entry(ftpd_t, ftpd_exec_t)

	optional_policy(`
		logrotate_exec(ftpd_t)
	')
')
```

**Expanded Macro:**

```
# This is the expanded macro from the tmp/ftp.tmp file showing
# the policy language statements with both optional levels expanded.
#

optional {
	##### begin corecmd_exec_shell(ftpd_t) depth: 1
	require {
		type shell_exec_t;
		} # end require

		##### begin corecmd_list_bin(ftpd_t) depth: 2
		require {
			type bin_t;
			} # end require

			##### begin corecmd_search_bin(ftpd_t) depth: 3
			require {
				type bin_t;
			} # end require
			allow ftpd_t bin_t:dir { getattr search open };
			allow ftpd_t bin_t:lnk_file { getattr read };

				##### begin files_search_usr(ftpd_t) depth: 4
				require {
					type usr_t;
				} # end require
				allow ftpd_t usr_t:dir { getattr search open };
			##### end files_search_usr(ftpd_t) depth: 3
		##### end corecmd_search_bin(ftpd_t) depth: 2
		allow ftpd_t bin_t:dir { getattr search open };
		allow ftpd_t bin_t:dir { getattr search open read lock ioctl };
	##### end corecmd_list_bin(ftpd_t) depth: 1
	allow ftpd_t shell_exec_t:file { { getattr open map read execute ioctl } ioctl lock execute_no_trans };
	##### end corecmd_exec_shell(ftpd_t) depth: 0

	##### begin files_read_usr_files(ftpd_t) depth: 1
	require {
		type usr_t;
	} # end require
	allow ftpd_t usr_t:dir { getattr search open read lock ioctl };
	allow ftpd_t usr_t:dir { getattr search open };
	allow ftpd_t usr_t:file { getattr open read lock ioctl };
	allow ftpd_t usr_t:dir { getattr search open };
	allow ftpd_t usr_t:lnk_file { getattr read };
	##### end files_read_usr_files(ftpd_t) depth: 0

	##### begin cron_system_entry(ftpd_t,ftpd_exec_t) depth: 1
	require {
		type crond_t, system_cronjob_t;
		type user_cron_spool_log_t;
	} # end require
	allow ftpd_t user_cron_spool_log_t:dir { getattr search open };
	allow ftpd_t user_cron_spool_log_t:file { open { getattr read write append ioctl lock } };
	allow system_cronjob_t ftpd_exec_t:file { getattr open map read execute ioctl };
	allow system_cronjob_t ftpd_t:process transition;
	dontaudit system_cronjob_t ftpd_t:process { noatsecure siginh rlimitinh };
	type_transition system_cronjob_t ftpd_exec_t:process ftpd_t;
	allow ftpd_t system_cronjob_t:fd use;
	allow ftpd_t system_cronjob_t:fifo_file { getattr read write append ioctl lock };
	allow ftpd_t system_cronjob_t:process sigchld;
	allow crond_t ftpd_exec_t:file { getattr open map read execute ioctl };
	allow crond_t ftpd_t:process transition;
	dontaudit crond_t ftpd_t:process { noatsecure siginh rlimitinh };
	type_transition crond_t ftpd_exec_t:process ftpd_t;
	allow ftpd_t crond_t:fd use;
	allow ftpd_t crond_t:fifo_file { getattr read write append ioctl lock };
	allow ftpd_t crond_t:process sigchld;
	role system_r types ftpd_t;
	##### end cron_system_entry(ftpd_t,ftpd_exec_t) depth: 0
	optional {
		##### begin logrotate_exec(ftpd_t) depth: 1
		require {
			type logrotate_exec_t;
		} # end require

			##### begin corecmd_search_bin(ftpd_t) depth: 2
			require {
				type bin_t;
			} # end require
			allow ftpd_t bin_t:dir { getattr search open };
			allow ftpd_t bin_t:lnk_file { getattr read };

				##### begin files_search_usr(ftpd_t) depth: 3
				require {
					type usr_t;
				} # end require
				allow ftpd_t usr_t:dir { getattr search open };
			##### end files_search_usr(ftpd_t) depth: 2
		##### end corecmd_search_bin(ftpd_t) depth: 1

		allow ftpd_t logrotate_exec_t:file { { getattr open map read execute ioctl } ioctl lock execute_no_trans };

	##### end logrotate_exec(ftpd_t) depth: 0
	}
} # end optional
```

<br>

#### `gen_tunable` Macro

This macro defines booleans that are global in scope. The corresponding
[**`tunable_policy`**](#tunable_policy-macro) macro
contains the supporting statements allowed or not depending on the value
of the boolean. These entries are extracted as a part of the build
process (by the *make conf* target) and added to the *global_tunables*
file where they can then be used to alter the default values for the
*make load* or *make install* targets.

Note that the comments shown in the example MUST be present as they are
used to describe the function and are extracted for the
[**documentation**](#reference-policy-documentation).

**The macro definition is:**

`gen_tunable(boolean_name,boolean_value)`

**Where:**

<table>
<tbody>
<tr>
<td><code>gen_tunable</code></td>
<td>The <code>gen_tunable</code> macro keyword.</td>
</tr>
<tr>
<td>boolean_name</td>
<td>The <code>boolean</code> identifier.</td>
</tr>
<tr>
<td><code>boolean_value</code></td>
<td>The <code>boolean</code> value that can be either <em>true</em> or <em>false</em>.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the modules/services/ftp.te module:

## <desc>
##	<p>
##	Determine whether ftpd can use NFS
##	used for public file transfer services.
##	</p>
## </desc>
gen_tunable(allow_ftpd_use_nfs, false)
```

**Expanded Macro:**

```
# This is the expanded macro from the tmp/ftp.tmp file:
#

bool allow_ftpd_use_nfs false;
```
<br>

#### `tunable_policy` Macro

This macro contains the statements allowed or not depending on the value
of the boolean defined by the
[**`gen_tunable`**](#gen_tunable-macro) macro.

**The macro definition is:**

```
tunable_policy(`gen_tunable_id',`tunable_policy_rules`)
```

**Where:**

<table>
<tbody>
<tr>
<td><code>tunable_policy</code></td>
<td>The <code>tunable_policy</code> macro keyword.</td>
</tr>
<tr>
<td><code>gen_tunable_id</code></td>
<td>This is the boolean identifier defined by the <code>gen_tunable</code> macro. It is possible to have multiple entries separated by <em>&amp;&amp;</em> or <em>||</em> as shown in the example.</td>
</tr>
<tr>
<td><code>tunable_policy_rules</code></td>
<td>These are the policy rules and statements as defined in the <a href="conditional_statements.md#if"><code>if</code> statement</a> policy language section.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the modules/services/ftp.te module
# showing the use of the boolean with the && operator.
#

tunable_policy(`allow_ftpd_use_nfs && allow_ftpd_anon_write',`
	fs_manage_nfs_files(ftpd_t)
')
```

**Expanded Macro:**

```
# This is the expanded macro from the tmp/ftp.tmp file.
#

if (allow_ftpd_use_nfs && allow_ftpd_anon_write) {
	##### begin fs_manage_nfs_files(ftpd_t)
	require {
		type nfs_t;
	} # end require
	allow ftpd_t nfs_t:dir { read getattr lock search ioctl add_name remove_name write };
	allow ftpd_t nfs_t:file { create open getattr setattr read write append rename link unlink ioctl lock };
} # end allow_ftpd_use_nfs && allow_ftpd_anon_write
```

<br>

#### `interface` Macro

Access `interface` macros are defined in the interface module file (*.if*)
and form the interface through which other modules can call on the
modules services (as shown in and described in the
[**Module Expansion Process**](#module-expansion-process) section.

**The macro definition is:**

```
interface(`name`,`interface_rules`)
```

**Where:**

<table>
<tbody>
<tr>
<td><code>interface</code></td>
<td>The <code>interface</code> macro keyword.</td>
</tr>
<tr>
<td>name</td>
<td>The <code>interface</code> identifier that should be named to reflect the module identifier and its purpose.</td>
</tr>
<tr>
<td><code>interface_rules</code></td>
<td>This can consist of the support macros, policy language statements or other <code>interface</code> calls as required to provide the service.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Interface Definition:**

Note that the comments shown in the example MUST be present as they are
used to describe the function and are extracted for the
[**documentation**](#reference-policy-documentation).

```
# This example is from the modules/services/ftp.if module
# showing the 'ftp_read_config' interface.
#

########################################
## <summary>
##	Read ftpd configuration files.
## </summary>
## <param name="domain">
##	<summary>
##	Domain allowed access.
##	</summary>
## </param>
#
interface(`ftp_read_config',`
	gen_require(`
		type ftpd_etc_t;
	')

	files_search_etc($1)
	allow $1 ftpd_etc_t:file read_file_perms;
')
```

**Expanded Macro:** (taken from the *base.conf* file):
```
# Access Interfaces are only expanded at policy compile time
# if they are called by a module that requires their services.
#

# In this example the ftp_read_config interface is called from
# the init.te module via the optional_policy macro as shown
# below with the expanded code shown afterwards.

#
######## From ./policy/policy/modules/system/init.te ########
#

# optional_policy(`
# 	ftp_read_config(initrc_t)
# ')

#
############ Expanded policy statements taken from init.tmp ##############
#
optional {
	##### begin ftp_read_config(initrc_t) depth: 1
	require {
		type ftpd_etc_t;
	} # end require

	##### begin files_search_etc(initrc_t) depth: 2
	require {
		type etc_t;
	} # end require

	allow initrc_t etc_t:dir { getattr search open };
	##### end files_search_etc(initrc_t) depth: 1
	allow initrc_t ftpd_etc_t:file { getattr open read lock ioctl };
	##### end ftp_read_config(initrc_t) depth: 0
} # end optional
```

<br>

#### `template` Macro

A template interface is used to help create a domain and set up the
appropriate rules and statements to run an application / process. The
basic idea is to set up an application in a domain that is suitable for
the defined SELinux user and role to access but not others. Should a
different user / role need to access the same application, another
domain would be allocated (these are known as 'derived domains' as the
domain name is derived from caller information).

The main differences between an application interface and a template
interface are:

-   An access interface is called by other modules to perform a service.
-   A template interface allows an application to be run in a domain
    based on user / role information to isolate different instances.

Note that the comments shown in the example MUST be present as they are
used to describe the function and are extracted for the
[**documentation**](#reference-policy-documentation).

**The macro definition is:**

template(`name`,`template_rules`)

**Where:**

<table>
<tbody>
<tr>
<td>template</td>
<td>The <em>template</em> macro keyword.</td>
</tr>
<tr>
<td>name</td>
<td>The <em>template</em> identifier that should be named to reflect the module identifier and its purpose. By convention the last component is <em>_template</em> (e.g. <em>ftp_per_role_template</em>).</td>
</tr>
<tr>
<td><em>template</em>_rules</td>
<td>This can consist of the support macros, policy language statements or <em>interface</em> calls as required to provide the service.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>No</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the modules/services/djbdns.if module
# showing the 'djbdns_daemontools_domain_template' template interface.
#

#######################################
## <summary>
##	The template to define a djbdns domain.
## </summary>
## <param name="domain_prefix">
##	<summary>
##	Domain prefix to be used.
##	</summary>
## </param>
#
template(`djbdns_daemontools_domain_template',`
	gen_require(`
		attribute djbdns_domain;
	')

	########################################
	#
	# Declarations
	#

	type djbdns_$1_t, djbdns_domain;
	type djbdns_$1_exec_t;
	domain_type(djbdns_$1_t)
	domain_entry_file(djbdns_$1_t, djbdns_$1_exec_t)
	role system_r types djbdns_$1_t;

	type djbdns_$1_conf_t;
	files_config_file(djbdns_$1_conf_t)

	########################################
	#
	# Local policy
	#

	daemontools_service_domain(djbdns_$1_t, djbdns_$1_exec_t)
	daemontools_read_svc(djbdns_$1_t)

	allow djbdns_$1_t djbdns_$1_conf_t:dir list_dir_perms;
	allow djbdns_$1_t djbdns_$1_conf_t:file read_file_perms;
')
```

**Expanded Macro:**

```
# Template Interfaces are only expanded at policy compile time
# if they are called by a module that requires their services.
# This has been called from services/djbdns.te via:
#    djbdns_daemontools_domain_template(dnscache)
# and expanded in tmp/djbdns.tmp.
#

# Note these are very long, so only start / end shown. To trace these:
# 1) Note the line number where djbdns_daemontools_domain_template(dnscache)
#    is called in djbdns.te. In this case it is line 13.
# 2) In the appropriate tmp file where the macro has been expanded, in this
#    case tmp/djbdns.tmp, search for '#line 13'. These entries are all the
#    expanded components to build djbdns_daemontools_domain_template(dnscache).

##### begin djbdns_daemontools_domain_template(dnscache) depth: 1
	require {
		attribute djbdns_domain;
	} # end require

	########################################
	#
	# Declarations
	#
	type djbdns_dnscache_t, djbdns_domain;
	type djbdns_dnscache_exec_t;
##### begin domain_type(djbdns_dnscache_t) depth: 2
	# start with basic domain
......
......
......
##### end files_search_var(djbdns_dnscache_t) depth: 2
	allow djbdns_dnscache_t svc_svc_t:dir { getattr search open read lock ioctl };
	allow djbdns_dnscache_t svc_svc_t:file { getattr open read lock ioctl };
##### end daemontools_read_svc(djbdns_dnscache_t) depth: 1
	allow djbdns_dnscache_t djbdns_dnscache_conf_t:dir { getattr search open read lock ioctl };
	allow djbdns_dnscache_t djbdns_dnscache_conf_t:file { getattr open read lock ioctl };
##### end djbdns_daemontools_domain_template(dnscache) depth: 0
```

<br>

### Miscellaneous Macros

These macros are in the *misc_macros.spt* file.

#### `gen_context` Macro

This macro is used to generate a valid security context and can be used
in any of the module files. Its most general use is in the *.fc* file
where it is used to set the files security context.

**The macro definition is:**

`gen_context(context[,mls | mcs])`

**Where:**

<table>
<tbody>
<tr>
<td><code>gen_context</code></td>
<td>The <code>gen_context</code> macro keyword.</td>
</tr>
<tr>
<td><code>context</code></td>
<td>The security context to be generated. This can include macros that are relevant to a context as shown in the example below.</td>
</tr>
<tr>
<td><code>mls | mcs</code></td>
<td>MLS or MCS labels if enabled in the policy.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example shows gen_context being used to generate a
# security context in the kernel/storage.fc module:

/dev/\.tmp-block-.* -c gen_context(system_u:object_r:fixed_disk_device_t,mls_systemhigh)
```

**Expanded Macro:**

```
# This is the expanded entry built into contexts/files/file_contexts:

/dev/\.tmp-block-.*  -c  system_u:object_r:fixed_disk_device_t:s15:c0.c1023
```

<br>

#### `gen_user` Macro

This macro is used to generate a valid [**`user`**](user_statements.md#user)
Statement and add an entry in the
[**`users_extra`**](policy_store_config_files.md#activeusers_extra)
configuration file if it exists.

**The macro definition is:**

`gen_user(username, prefix, role_set, mls_defaultlevel, mls_range, [mcs_categories])`

**Where:**

<table>
<tbody>
<tr>
<td><code>gen_user</code></td>
<td>The <code>gen_user</code> macro keyword.</td>
</tr>
<tr>
<td><code>username</code></td>
<td>The SELinux user id.</td>
</tr>
<tr>
<td><code>prefix</code></td>
<td>SELinux users without the prefix will not be in the <em>users_extra</em> file. This is added to user directories by <em>genhomedircon</em> as discussed in the <a href="policy_store_config_files.md#building-the-file-labeling-support-files"></a> section.</td>
</tr>
<tr>
<td><code>role_set</code></td>
<td>The user roles.</td>
</tr>
<tr>
<td><code>mls_defaultlevel</code></td>
<td>The default level if MLS / MCS policy.</td>
</tr>
<tr>
<td><code>mls_range</code></td>
<td>The range if MLS / MCS policy.</td>
</tr>
<tr>
<td><code>mcs_categories</code></td>
<td>The categories if MLS / MCS policy.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example has been taken from the policy/policy/users file:
#

ifdef(`direct_sysadm_daemon',`
	gen_user(root, sysadm, sysadm_r staff_r ifdef(`enable_mls',`secadm_r auditadm_r') system_r, s0, s0 - mls_systemhigh, mcs_allcats)
',`
	gen_user(root, sysadm, sysadm_r staff_r ifdef(`enable_mls',`secadm_r auditadm_r'), s0, s0 - mls_systemhigh, mcs_allcats)
')
```


**Expanded Macro:**

```
# The expanded gen_user macro from the base.conf for an MLS
# build. Note that the prefix is not present. This is added to
# the users_extra file as shown below.
#

user root roles { sysadm_r staff_r secadm_r auditadm_r } level s0 range s0 - s15:c0.c1023;
```

```
# policy/tmp/users_extra file entry:
#

user root prefix sysadm;
```

<br>

#### `gen_bool` Macro

This macro defines a boolean and requires the following steps:

1.  Declare the [**`boolean`**](conditional_statements.md#bool) in the
    [***global_booleans***](#booleans-global-booleans-and-tunable-booleans)
    file.
2.  Use the boolean in a module fileswith an
    [**`if / else`**](conditional_statements.md#if) Statement as shown in the example.

Note that the comments shown in the example MUST be present as they are
used to describe the function and are extracted for the
[**documentation**](#reference-policy-documentation).

**The macro definition is:**

`gen_bool(name,default_value)`

**Where:**

<table>
<tbody>
<tr>
<td><code>gen_bool</code></td>
<td>The <em>gen_bool</em> macro keyword.</td>
</tr>
<tr>
<td><code>name</code></td>
<td>The <code>boolean</code> identifier.</td>
</tr>
<tr>
<td><code>default_value</code></td>
<td>The value <em>true</em> or <em>false</em>.</td>
</tr>
</tbody>
</table>

The macro is only valid in the *global_booleans* file but the `boolean`
declared can be used in the following module types:

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from kernel/kernel.te  where the bool is declared.
# The comments must be present as it is used to generate the documentation.
#

## <desc>
## <p>
## Disable kernel module loading.
## </p>
## </desc>
gen_bool(secure_mode_insmod, false)
```

```
# Example usage from the kernel/kernel.te module:
#

if( ! secure_mode_insmod ) {
	allow can_load_kernmodule self:capability sys_module;
	allow can_load_kernmodule self:system module_load;

	files_load_kernel_modules(can_load_kernmodule)

	# load_module() calls stop_machine() which
	# calls sched_setscheduler()
	# gt: there seems to be no trace of the above, at
	# least in kernel versions greater than 2.6.37...
	allow can_load_kernmodule self:capability sys_nice;
	kernel_setsched(can_load_kernmodule)
}
```

```
# This example is from policy/booleans.conf where the bool set for policy.
#
# Disable kernel module loading.
#
secure_mode_insmod = false
```

**Expanded Macro:**

```
# This has been taken from the base.conf source file after
# expansion by the build process of the kernel.te module.
#

########################################
#
# Kernel module loading policy
#

if( ! secure_mode_insmod ) {
	allow can_load_kernmodule self:capability sys_module;
	allow can_load_kernmodule self:system module_load;
##### begin files_load_kernel_modules(can_load_kernmodule) depth: 1
##### begin files_read_kernel_modules(can_load_kernmodule) depth: 2
	allow can_load_kernmodule modules_object_t:dir { getattr search open read lock ioctl };
	allow can_load_kernmodule modules_object_t:dir { getattr search open };
	allow can_load_kernmodule modules_object_t:file { getattr open read lock ioctl };
	allow can_load_kernmodule modules_object_t:dir { getattr search open };
	allow can_load_kernmodule modules_object_t:lnk_file { getattr read };
##### end files_read_kernel_modules(can_load_kernmodule) depth: 1
	allow can_load_kernmodule modules_object_t:system module_load;
##### end files_load_kernel_modules(can_load_kernmodule) depth: 0
	# load_module() calls stop_machine() which
	# calls sched_setscheduler()
	# gt: there seems to be no trace of the above, at
	# least in kernel versions greater than 2.6.37...
	allow can_load_kernmodule self:capability sys_nice;
	allow can_load_kernmodule kernel_t:process setsched;
##### end kernel_setsched(can_load_kernmodule) depth: 0
}
```

<br>

### MLS and MCS Macros

These macros are in the *mls_mcs_macros.spt* file.

#### `gen_cats` Macro

This macro will generate a
[**`category`**](mls_statements.md#category) statement for each category
defined. These are then used in the *base.conf* / *policy.conf* source
file and also inserted into each module by the
[**`policy_module`**](#policy_module-macro). The *policy/policy/mcs*
and *mls* configuration files are the only files that contain this macro
in the current reference policy.

**The macro definition is:**

`gen_cats(mcs_num_cats | mls_num_cats)`

**Where:**

<table>
<tbody>
<tr>
<td><code>gen_cats</code></td>
<td>The <code>gen_cats</code> macro keyword.</td>
</tr>
<tr>
<td><p><code>mcs_num_cats</code></p>
<p><code>mls_num_cats</code></p></td>
<td>These are the maximum number of categories that have been extracted from the <em>build.conf</em> file <em>MCS_CATS</em> or <em>MLS_CATS</em> entries and set as m4 parameters.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>na</td>
<td>na</td>
<td>na</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the policy/policy/mls configuration file.
#

gen_cats(mls_num_cats)
```

**Expanded Macro:**

```
# This example has been extracted from the base.conf source file.

category c0;
category c1;
...
category c1023;
```

<br>

#### `gen_sens` Macro

This macro will generate a
[**`sensitivity`**](mls_statements.md#sensitivity) for each sensitivity
defined. These are then used in the *base.conf* / *policy.conf* source
file and also inserted into each module by the
[**`policy_module`**](#policy_module-macro). The *policy/policy/mcs*
and *mls* configuration files are the only files that contain this macro
in the current reference policy (note that the *mcs* file has
`gen_sens(1)` as only one sensitivity is required).

**The macro definition is:**

`gen_sens(mls_num_sens)`

**Where:**

<table>
<tbody>
<tr>
<td><code>gen_sens</code></td>
<td>The <code>gen_sens</code> macro keyword.</td>
</tr>
<tr>
<td><code>mls_num_sens</code></td>
<td>These are the maximum number of sensitivities that have been extracted from the <em>build.conf</em> file <em>MLS_SENS</em> entries and set as an m4 parameter.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>na</td>
<td>na</td>
<td>na</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the policy/policy/mls configuration file.
#

gen_cats(mls_num_sens)
```

**Expanded Macro:**

```
# This example has been extracted from the base.conf source file.

sensitivity s0;
sensitivity s1;
...
sensitivity s15;
```

<br>

#### `gen_levels` Macro

This macro will generate a [*level*](mls_statements.md#level) for each level
defined. These are then used in the *base.conf* / *policy.conf* source file.
The *policy/policy/mcs* and *mls* configuration files are the only files
that contain this macro in the current reference policy.

**The macro definition is:**

`gen_levels(mls_num_sens,mls_num_cats)`

**Where:**

<table>
<tbody>
<tr>
<td><code>gen_levels</code></td>
<td>The <code>gen_levels</code> macro keyword.</td>
</tr>
<tr>
<td><code>mls_num_sens</code></td>
<td>This is the parameter that defines the number of sensitivities to generate. The MCS policy is set to '<em>1</em>'.</td>
</tr>
<tr>
<td><p><code>mls_num_cats</code></p>
<p><code>mcs_num_cats</code></p></td>
<td>This is the parameter that defines the number of categories to generate.</td>
</tr>
</tbody>
</table>

**The macro is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Private Policy File (<em>.te</em>)</strong></td>
<td><strong>External Interface File (<em>.if</em>)</strong></td>
<td><strong>File Labeling Policy File (<em>.fc</em>)</strong></td>
</tr>
<tr>
<td>na</td>
<td>na</td>
<td>na</td>
</tr>
</tbody>
</table>

**Example Macro:**

```
# This example is from the policy/policy/mls configuration file.
#

gen_levels(mls_num_sens,mls_num_cats)
```

**Expanded Macro:**

```
# This example has been extracted from the base.conf source file.
# Note that the all categories are allocated to each sensitivity.

level s0:c0.c1023;
level s1:c0.c1023;
...
level s15:c0.c1023;
```

<br>

#### System High/Low Parameters

These macros define system high etc. as shown.

`mls_systemlow`

```
# gives:

s0
```

`mls_systemhigh`

```
# gives:

s15:c0.c1023
```

`mcs_systemlow`

```
# gives:

s0
```

`mcs_systemhigh`

```
# gives:

s0:c0.c1023
```

`mcs_allcats`

```
# gives:

c0.c1023
```

<br>

### `ifdef` / `ifndef` Parameters

This section contains examples of the common `ifdef` / `ifndef`
parameters that can be used in module source files.

<br>

#### `hide_broken_symptoms`

This is used within modules as shown in the example. The parameter is
set up by the *Makefile* at the start of the build process.

**Example Macro:**

```
# This example is from the modules/kernel/domain.te module.
#

ifdef(`hide_broken_symptoms',`
	# This check is in the general socket
	# listen code, before protocol-specific
	# listen function is called, so bad calls
	# to listen on UDP sockets should be silenced
	dontaudit domain self:udp_socket listen;
')
```

<br>

#### `enable_mls` and `enable_mcs`

These are used within modules as shown in the example. The parameters
are set up by the *Makefile* with information taken from the
*build.conf* file at the start of the build process.

**Example Macros:**

```
# This example is from the modules/kernel/kernel.te module.
#

ifdef(`enable_mls',`
	role secadm_r;
	role auditadm_r;
')
```

```
# This example is from the modules/services/ftp.te module.
#

ifdef(`enable_mcs',`
	init_ranged_daemon_domain(ftpd_t, ftpd_exec_t, s0 - mcs_systemhigh)
')
```

<br>

#### `enable_ubac`

This is used within the *./policy/constraints* configuration file to set
up various attributes to support user based access control (UBAC). These
attributes are then used within the various modules that want to support
UBAC. This support was added in version 2 of the Reference Policy.

The parameter is set up by the *Makefile* with information taken from
the *build.conf* file at the start of the build process (*ubac = y |
ubac = n*).

**Example Macro:**

```
# This example is from the policy/constraints file.
# Note that the ubac_constrained_type attribute is defined in
# modules/kernel/ubac.te module.

define(`basic_ubac_conditions',`
	ifdef(`enable_ubac',`
		u1 == u2
		or u1 == system_u
		or u2 == system_u
		or t1 != ubac_constrained_type
		or t2 != ubac_constrained_type
	')
')
```

<br>

#### `direct_sysadm_daemon`

This is used within modules as shown in the example. The parameter is
set up by the *Makefile* with information taken from the *build.conf*
file at the start of the build process (if *DIRECT_INITRC = y*).

Example Macros:

```
# This example is from the modules/system/selinuxutil.te module.
#

ifndef(`direct_sysadm_daemon',`
	ifdef(`distro_gentoo',`
		# Gentoo integrated run_init:
		init_script_file_entry_type(run_init_t)

		init_exec_rc(run_init_t)
	')
')
```

<br>

## Module Expansion Process

The objective of this section is to show how the modules are expanded by
the reference policy build process to form files that can then be
compiled and then loaded into the policy store by using the *make
MODULENAME.pp* target.

The files shown are those produced by the build process using the ada
policy modules from the Reference Policy source tree (*ada.te*, *ada.if*
and *ada.fc*) that are shown in the
[**Reference Policy Module Files**](#reference-policy-module-files) section.

The initial build process will build the source text files in the
*policy/tmp* directory as *ada.tmp* and *ada.mod.fc* (that are basically
build equivalent *ada.conf* and *ada.fc* formatted files). The basic
steps are shown in , and the resulting expanded code shown in and then
described in the [**Module Expansion Process**](#module-expansion-process)
section.

![](./images/28-mod-expand-1.png)

**Figure 28: The *make ada* sequence of events**

![](./images/29-mod-expand-2.png)

**Figure 29: The expansion process**


<br>

<!-- Cut Here -->

<table>
<tbody>
<td><center>
<p><a href="modular_policy_statements.md#modular-policy-support-statements" title="Modular Policy Support Statements"> <strong>Previous</strong></a></p>
</center></td>
<td><center>
<p><a href="README.md#the-selinux-notebook" title="The SELinux Notebook"> <strong>Home</strong></a></p>
</center></td>
<td><center>
<p><a href="implementing_seaware_apps.md#implementing-selinux-aware-applications" title="Implementing SELinux-aware Applications"> <strong>Next</strong></a></p>
</center></td>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>
