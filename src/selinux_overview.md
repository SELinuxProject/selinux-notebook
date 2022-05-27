# SELinux Overview

SELinux is the primary Mandatory Access Control (MAC) mechanism built
into a number of GNU / Linux distributions. SELinux originally started
as the Flux Advanced Security Kernel (FLASK) development by the Utah
university Flux team and the US Department of Defence. The development
was enhanced by the NSA and released as open source software (see:
<https://www.nsa.gov/what-we-do/research/selinux/>).

Each of the sections that follow will describe a component of SELinux,
and hopefully they are in some form of logical order.

Note: When SELinux is installed, there are three well defined directory
locations referenced. Two of these will change with the old and new
locations as follows:

| Description | Old Location | New Location |
| :---------  | :----------- | :----------- |
The SELinux filesystem that interfaces with the kernel based security server. The new location has been available since Fedora 17. | */selinux* | */sys/fs/selinux* |
| The SELinux configuration directory that holds the sub-system configuration files and policies. | */etc/selinux* | No change |
| The SELinux policy store that holds policy modules and configuration details. The new location has been available since Fedora 23. | */etc/selinux/\<SELINUXTYPE\>/module* | */var/lib/selinux/\<SELINUXTYPE\>* |

## Is SELinux useful

There are many views on the usefulness of SELinux on Linux based
systems, this section gives a brief view of what SELinux is good at and
what it is not (because it's not designed to do it).

SELinux is not just for military or high security systems where
Multi-Level Security (MLS) is required (for functionality such as 'no
read up' and 'no write down'), as using the 'type enforcement' (TE)
functionality applications can be confined (or contained) within domains
and limited to the minimum privileges required to do their job, so in a
'nutshell':

1.  **The First Security Principle:** ***Trust nothing, trust nobody, all
    they want is your money and/or your information*** (*unless of course you
    can prove otherwise beyond all reasonable doubt*).
2.  If SELinux is enabled, the policy defines what access to resources
    and operations on them (e.g. read, write) are allowed (i.e. SELinux
    stops all access unless allowed by policy). This is why SELinux is
    called a 'mandatory access control' (MAC) system.
3.  The policy design, implementation and testing against a defined
    security policy or requirements is important, otherwise there could
    be 'a false sense of security'.
4.  SELinux can confine an application within its own 'domain' and allow
    it to have the minimum privileges required to do its job. Should
    the application require access to networks or other applications (or
    their data), then (as part of the security policy design), this
    access would need to be granted (so at least it is known what
    interactions are allowed and what are not - a good security goal).
5.  Should an application 'do something' it is not allowed by policy
    (intentional or otherwise), then SELinux would stop these actions.
6.  Should an application 'do something' it is allowed by policy, then
    SELinux may contain any damage that maybe done intentional or
    otherwise. For example if an application is allowed to delete all of
    its data files or database entries and the bug, virus or malicious
    user gains these privileges then it would be able to do the same.
    However the good news is that if the policy 'confined' the
    application and data, all your other data should still be there.
7.  User login sessions can be confined to their own domains. This
    allows clients they run to be given only the privileges they need
    (e.g. admin users, sales staff users, HR staff users etc.). This
    again will confine/limit any damage or leakage of data.
8.  Some applications (X-Windows for example) are difficult to confine
    as they are generally designed to have total access to all
    resources. SELinux can generally overcome these issues by providing
    sandboxing services.
9.  SELinux will not stop memory leaks or buffer over-runs (because its
    not designed to do this), however it may contain the damage that may
    be caused by these flaws.
10. SELinux will not stop all viruses/malware getting into the system,
    as there are many ways they could be introduced (including
    legitimate users), however it should limit the damage or leaks they
    cause.
11. SELinux will not stop kernel vulnerabilities, however it may limit
    their effects.
12. If a user has the relevant permissions it is easy to add new rules
    to a SELinux policy using tools such as ***audit2allow**(1)*.
    Nevertheless be aware that this may start opening holes, so do
    double check the necessity of a given rule.
13. Finally, SELinux cannot stop anything allowed by the security
    policy, so good design is important.

The following maybe useful in providing a practical view of SELinux:

1.  Your visual how-to guide for SELinux policy enforcement, available from:
    <https://opensource.com/business/13/11/selinux-policy-guide>
2.  A discussion regarding Apache servers and SELinux that may look
    negative at first but highlights the containment points above. This
    is the initial study:
    <http://blog.ptsecurity.com/2012/08/selinux-in-practice-dvwa-test.html>,
    and this is a response to the study:
    <http://danwalsh.livejournal.com/56760.html>.
3.  SELinux services have been added to Android. The presentation
    "Security Enhancements (SE) for Android" gives use-cases and
    types of Android exploits that SELinux could have overcome. The
    presentation and others are available at:
    <https://events.static.linuxfound.org/sites/events/files/slides/abs2014_seforandroid_smalley.pdf>
4.  Older NSA documentation at: <https://www.nsa.gov/what-we-do/research/selinux/documentation/>
    that is informative.

<!-- %CUTHERE% -->

---
**[[ PREV ]](terminology.md)** **[[ TOP ]](#)** **[[ NEXT ]](core_components.md)**
