# Appendix C - SELinux Commands

This section gives a brief summary of the SELinux specific commands.
Some of these have been used within this Notebook, however the
appropriate man pages do give more detail and the SELinux project site
has a page that details all the available tools and commands at:

<https://github.com/SELinuxProject/selinux/wiki/Tools>

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Command</strong></td>
<td><strong>Man Page</strong></td>
<td><strong>Purpose</strong></td>
</tr>
<tr>
<td>audit2allow</td>
<td>1</td>
<td>Generates policy allow rules from the audit.log file.</td>
</tr>
<tr>
<td>audit2why</td>
<td>8</td>
<td>Describes audit.log messages and why access was denied.</td>
</tr>
<tr>
<td>avcstat</td>
<td>8</td>
<td>Displays the AVC statistics.</td>
</tr>
<tr>
<td>chcat</td>
<td>8</td>
<td>Change or remove a catergory from a file or user. </td>
</tr>
<tr>
<td>chcon</td>
<td>1</td>
<td>Changes the security context of a file.</td>
</tr>
<tr>
<td>checkmodule</td>
<td>8</td>
<td>Compiles base and loadable modules from source.</td>
</tr>
<tr>
<td>checkpolicy</td>
<td>8</td>
<td>Compiles a monolithic policy from source.</td>
</tr>
<tr>
<td>fixfiles</td>
<td>8</td>
<td>Update / correct the security context of for filesystems that use extended attributes.</td>
</tr>
<tr>
<td>genhomedircon</td>
<td>8</td>
<td>Generates file configuration entries for users home directories. This command has also been built into <em><strong>semanage</strong>(8)</em>, therefore when using the policy store / loadable modules this does not need to be used.</td>
</tr>
<tr>
<td>getenforce</td>
<td>1</td>
<td>Shows the current enforcement state.</td>
</tr>
<tr>
<td>getsebool</td>
<td>8</td>
<td>Shows the state of the booleans.</td>
</tr>
<tr>
<td>load_policy</td>
<td>8</td>
<td>Loads a new policy into the kernel. Not required when using <em><strong>semanage</strong>(8)</em> / <em><strong>semodule</strong>(8)</em> commands.</td>
</tr>
<tr>
<td>matchpathcon</td>
<td>8</td>
<td>Show a files path and security context.</td>
</tr>
<tr>
<td>newrole</td>
<td>1</td>
<td>Allows users to change roles - runs a new shell with the new security context.</td>
</tr>
<tr>
<td>restorecon</td>
<td>8</td>
<td>Sets the security context on one or more files.</td>
</tr>
<tr>
<td>run_init</td>
<td>8</td>
<td>Runs an <em>init</em> script under the correct context.</td>
</tr>
<tr>
<td>runcon</td>
<td>1</td>
<td>Runs a command with the specified context.</td>
</tr>
<tr>
<td>selinuxenabled </td>
<td>1</td>
<td>Shows whether SELinux is enabled or not.</td>
</tr>
<tr>
<td>semanage</td>
<td>8</td>
<td>Used to configure various areas of a policy within a policy store.</td>
</tr>
<tr>
<td>semodule</td>
<td>8</td>
<td>Used to manage the installation, upgrading etc. of policy modules.</td>
</tr>
<tr>
<td>semodule_expand</td>
<td>8</td>
<td>Manually expand a base policy package into a kernel binary policy file.</td>
</tr>
<tr>
<td>semodule_link </td>
<td>8</td>
<td>Manually link a set of module packages.</td>
</tr>
<tr>
<td>semodule_package</td>
<td>8</td>
<td>Create a module package with various configuration files (file context etc.)</td>
</tr>
<tr>
<td>sestatus</td>
<td>8</td>
<td>Show the current status of SELinux and the loaded policy.</td>
</tr>
<tr>
<td>setenforce</td>
<td>1</td>
<td>Sets / unsets enforcement mode.</td>
</tr>
<tr>
<td>setfiles</td>
<td>8</td>
<td>Initialise the extended attributes of filesystems.</td>
</tr>
<tr>
<td>setsebool</td>
<td>8</td>
<td>Sets the state of a boolean to on or off persistently across reboots or for this session only. </td>
</tr>
</tbody>
</table>


<br>

<!-- %CUTHERE% -->

<table>
<tbody>
<td><center>
<p><a href="libselinux_functions.md#appendix-b---libselinux-api-summary" title="Appendix B - `libselinux` API Summary"> <strong>Previous</strong></a></p>
</center></td>
<td><center>
<p><a href="README.md#the-selinux-notebook" title="The SELinux Notebook"> <strong>Home</strong></a></p>
</center></td>
<td><center>
<p><a href="debug_policy_hints.md#appendix-d---debugging-policy---hints-and-tips" title="Appendix D - Debugging Policy - Hints and Tips"> <strong>Next</strong></a></p>
</center></td>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>

