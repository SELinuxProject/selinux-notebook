# Apache SELinux Support

Apache web servers are supported by SELinux using the Apache policy
modules from the Reference Policy (*httpd* modules), however there is no
specific Apache object manger. There is though an SELinux-aware shared
library and policy that will allow finer grained access control when
using Apache with threads. The additional Apache module is called
*mod_selinux.so* and has a supporting policy module called *mod_selinux.pp*.

```
dnf install mod_selinux
```

The *mod_selinux* policy module makes use of the *typebounds* statement that
was introduced into version 24 of the policy (requires a minimum kernel of
2.6.28). *mod_selinux* allows threads in a multi-threaded application (such
as Apache) to be bound within a defined set of permissions in that the
child domain cannot have greater permissions than the parent domain.

These components are known as 'Apache / SELinux Plus' and are described
in the sections that follow, however a full description including
configuration details is available from:

<https://code.google.com/archive/p/sepgsql/wikis/Apache_SELinux_plus.wiki>

The objective of these Apache add-on services is to achieve a fully
SELinux-aware web stack (although not there yet). For example, currently
the LAPP<a href="#fnap1" class="footnote-ref" id="fnaph1"><strong><sup>1</sup></strong></a>
(Linux, Apache, PostgreSQL, PHP / Perl / Python) stack has the following support:

<table>
<tbody>
<tr>
<td>L</td>
<td>Linux has SELinux support.</td>
</tr>
<tr>
<td>A</td>
<td>Apache has partial SELinux support using the 'Apache SELinux Plus' module.</td>
</tr>
<tr>
<td>P</td>
<td>PostgreSQL has SELinux support using the PostgreSQL <em>sepgsql</em> extension .</td>
</tr>
<tr>
<td>P</td>
<td>PHP / Perl / Python are not currently SELinux-aware, however PHP and Python do have support for libselinux functions in packages: PHP - with the <em>php-pecl-selinux</em> package, Python - with the <em>libselinux-python</em> package.</td>
</tr>
</tbody>
</table>

The [A secure web application platform powered by SELinux](http://sepgsql.googlecode.com/files/LCA20090120-lapp-selinux.pdf)
document gives a good overview of the LAPP architecture.


## *mod_selinux* Overview

What the *mod_selinux* module achieves is to allow a web application
(or a 'request handler') to be launched by Apache with a security
context based on policy rather than that of the web server process
itself, for example:

1.  A user sends an HTTP request to Apache that requires the services of
    a web application (Apache may or may not apply HTTP authentication).
2.  Apache receives the request and launches the web application
    instance to perform the task:
-   Without *mod_selinux* enabled the web applications security context
    is identical to the Apache web server process, it is therefore not
    possible to restrict it privileges.

-   With *mod_selinux* enabled, the web application is launched with
    the security context defined in the *mod_selinux.conf* file
    (*selinuxDomainVal &lt;security_context&gt;* entry). It is also
    possible to restrict its privileges as described in the
    [Bounds Overview](#bounds-overview) section.

3.  The web application exits, handing control back to the web server
    that replies with the HTTP response.


## Bounds Overview

Because multiple threads share the same memory segment, SELinux was
unable to check the information flows between these different threads
when using ***setcon**(3)* in pre 2.6.28 kernels. This meant that if a
thread (the parent) should launch another thread (a child) with a
different security context, SELinux could not enforce the different
permissions.

To resolve this issue the *typebounds* statement was introduced with
kernel support in 2.6.28 that stops a child thread (the 'bounded domain')
having greater privileges than the parent thread (the 'bounding domain')
i.e. the child thread must have equal or less permissions than the parent.

For example the following *typebounds* statement and *allow* rules:

```
#          parent  | child
#          domain  | domain
typebounds httpd_t   httpd_child_t;

allow httpd_t etc_t:file { getattr read };
allow httpd_child_t etc_t:file { read write };
```

State that the parent domain (*httpd_t*) has *file : { getattr read }*
permissions. However the child domain (*httpd_child_t*) has been given
*file : { read write }*. At run-time, this would not be allowed by the
kernel because the parent does not have *write* permission, thus
ensuring the child domain will always have equal or less privileges than
the parent.

When ***setcon**(3)* is used to set a different context on a new thread
without an associated *typebounds* policy statement, then the call will
return 'Operation not permitted' and an *SELINUX_ERR* entry will be added
to the audit log stating *op=security_bounded_transition result=denied*
with the old and new context strings.

Should there be a valid *typebounds* policy statement and the child
domain exercises a privilege greater that that of the parent domain, the
operation will be denied and an *SELINUX_ERR* entry will be added to
the audit log stating *op=security_compute_av reason=bounds* with
the context strings and the denied class and permissions.



<section class="footnotes">
<ol>
<li id="fnap1"><p>This is similar to the LAMP (Linux, Apache, MySQL, PHP/Perl/Python) stack, however MySQL is not SELinux-aware.<a href="#fnaph1" class="footnote-back">↩</a></p></li>
</ol>
</section>


<!-- %CUTHERE% -->

---
**[[ PREV ]](postgresql.md)** **[[ TOP ]](#)** **[[ NEXT ]](configuration_files.md)**
