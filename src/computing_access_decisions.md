# Computing Access Decisions

There are a number of ways to compute access decisions within userspace
SELinux-aware applications or object managers:

1.  Use of the ***selinux_check_access**(3)* function is the
    recommended option. This utilises the AVC services discussed in
    bullet 3 in a single call that:

-   Dynamically resolves class and permissions strings to their
    class/permission values using ***string_to_security_class**(3)*
    and ***string_to_av_perm**(3)* with
    ***security_deny_unknown**(3)* to handle unknown
    classes/permissions.
-   Uses ***avc_has_perm**(3)* to check whether the decision is cached
    before calling ***security_compute_av_flags**(3)* (and caching
    the result), checks enforcing mode (both global and per-domain
    (permissive)), and logs any denials (there is also an option to add
    supplemental auditing information that is handled as described in
    ***avc_audit**(3)*.

2.  Use functions that do not cache access decisions (i.e. they do not
    use the *libselinux* AVC services). These require a call to the
    kernel for every decision using ***security_compute_av**(3)* or
    ***security_compute_av_flags**(3)*. The ***avc_netlink_\***(3)*
    functions can be used to detect policy change events. Auditing would
    need to be implemented if required.

3.  Use functions that utilise the *libselinux* userspace AVC services
    that are initialised with ***avc_open**(3)*. These can be built in
    various configurations such as:

-   Using the default single threaded mode where ***avc_has_perm**(3)*
    will automatically cache entries, audit the decision and manage
    the handling of policy change events.

-   Implementing threads or a similar service that will handle policy
    change events and auditing in real time with
    ***avc_has_perm**(3)* or ***avc_has_perm_noaudit**(3)*
    handling decisions and caching. This has the advantage of better
    performance, which can be further increased by caching the entry
    reference.

4.  Implement custom caching services with
    ***security_compute_av**(3)* or
    ***security_compute_av_flags**(3)* for computing access
    decisions. The ***avc_netlink_\***(3)* functions can then be used to
    detect policy change events. Auditing would need to be implemented
    if required.

Where performance is important when making policy decisions, then the
***selinux_status_open**(3)*, ***selinux_status_updated**(3)*,
***selinux_status_getenforce**(3)*,
***selinux_status_policyload**(3)* and ***selinux_status_close**(3)*
functions could be used to detect policy updates etc. as these do not
require kernel system call over-heads once set up. Note that these
functions are only available from *libselinux* 2.0.99, with Linux kernel
2.6.37 and above.

<br>

<!-- %CUTHERE% -->

<table>
<tbody>
<td><center>
<p><a href="computing_security_contexts.md#computing-security-contexts" title="Computing Security Contexts"> <strong>Previous</strong></a></p>
</center></td>
<td><center>
<p><a href="README.md#the-selinux-notebook" title="The SELinux Notebook"> <strong>Home</strong></a></p>
</center></td>
<td><center>
<p><a href="domain_object_transitions.md#domain-and-object-transitions" title="Domain and Object Transitions"> <strong>Next</strong></a></p>
</center></td>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>
