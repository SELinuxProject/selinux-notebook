# Subjects

A subject is an active entity generally in the form of a person,
process, or device that causes information to flow among objects or
changes the system state.

Within SELinux a subject is an active process and has a
[**security context**](security_context.md#security-context) associated with
it, however a process can also be referred to as an object depending on the
context in which it is being taken, for example:

1.  A running process (i.e. an active entity) is a subject because it
    causes information to flow among objects or can change the system
    state.
2.  The process can also be referred to as an object because each
    process has an associated object class<a href="#fns1" class="footnote-ref" id="fnsub1"><strong><sup>1</sup></strong></a>
    called '**process**'. This process 'object', defines what permissions the
    policy is allowed to grant or deny on the active process.

An example is given of the above scenarios in the
[**Allowing a Process Access to Resources**](objects.md#allowing-a-process-access-to-resources)
section.

In SELinux subjects can be:

**Trusted** - Generally these are commands, applications etc. that have
been written or modified to support specific SELinux functionality to
enforce the security policy (e.g. the kernel, init, pam, xinetd and
login). However, it can also cover any application that the organisation
is willing to trust as a part of the overall system. Although (depending
on your paranoia level), the best policy is to trust nothing until it
has been verified that it conforms to the security policy. Generally
these trusted applications would run in either their own domain (e.g.
the audit daemon could run under auditd\_t) or grouped together (e.g.
the ***semanage**(8)* and ***semodule**(8)* commands could be grouped
under `semanage_t`).

**Untrusted** - Everything else.

<br>

<section class="footnotes">
<ol>
<li id="fns1"><p>The object class and its associated permissions are explained in the <strong><a href="object_classes_permissions.md#process-object-class"> Appendix A - Object Classes and Permissions - Process Object Class</a></strong> section.<a href="#fnsub1" class="footnote-back">↩</a></p></li>
</ol>
</section>


<br>

<!-- Cut Here -->

<table>
<tbody>
<td><center>
<p><a href="security_context.md#security-context" title="Security Context"> <strong>Previous</strong></a></p>
</center></td>
<td><center>
<p><a href="README.md#the-selinux-notebook" title="The SELinux Notebook"> <strong>Home</strong></a></p>
</center></td>
<td><center>
<p><a href="objects.md#objects" title="Objects"> <strong>Next</strong></a></p>
</center></td>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>
