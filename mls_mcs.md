# Multi-Level and Multi-Category Security

As stated in the
[**Mandatory Access Control (MAC)**](mac.md#mandatory-access-control)
section as well as supporting Type Enforcement (TE), SELinux also supports
MLS and MCS by adding an optional *level* or *range* entry to the security
context. This section gives a brief introduction to MLS and MCS.

**Figure 8: Security Levels and Data Flows** shows a simple diagram where
security levels represent the classification of files within a file server.
The security levels are strictly hierarchical and conform to the
[*Bell-La & Padula model*](http://en.wikipedia.org/wiki/Bell-LaPadula_model)
(BLP) in that (in the case of SELinux) a process (running at the
'Confidential' level) can read / write at their current level but only read
down levels or write up levels (the assumption here is that the process is
authorised).

This ensures confidentiality as the process can copy a file up to the
secret level, but can never re-read that content unless the process
'steps up to that level', also the process cannot write files to the
lower levels as confidential information would then drift downwards.

![](./images/8-security-levels.png)

**Figure 8: Security Levels and Data Flows** - *This shows how the process
can only 'Read Down' and 'Write Up' within an MLS enabled system.*

To achieve this level of control, the MLS extensions to SELinux make use
of constraints similar to those described in the type enforcement
[**Type Enforcement - Constraints**](type_enforcement.md#constraints) section,
except that the statement is called `mlsconstrain`.

However, as always life is not so simple as:

1.  Processes and objects can be given a range that represents the low
    and high security levels.
2.  The security level can be more complex, in that it is a hierarchical
    sensitivity and zero or more non-hierarchical categories.
3.  Allowing a process access to an object is managed by 'dominance'
    rules applied to the security levels.
4.  Trusted processes can be given privileges that will allow them to
    bypass the BLP rules and basically do anything (that the security
    policy allowed of course).
5.  Some objects do not support separate read / write functions as they
    need to read / respond in cases such as networks.

The sections that follow discuss the format of a security level and
range, and how these are managed by the constraints mechanism within
SELinux using dominance rules.

## Security Levels

**Table 1: Level, Label, Category or Compartment** shows the components that
make up a security level and how two security levels form a range for the
fourth and optional *\[:range\]* of the
[**Security Context**](security_context.md#security-context)
within an MLS / MCS environment.

The table also adds terminology in general use as other terms can be
used that have the same meanings.

<table>
<tbody>
<tr>
<td><center><p><strong>Security Level (or Level)</strong></p></center>
<p><center>Consisting of a sensitivity and zero or more category entries:</center></p></td>
<td colspan="2"; rowspan="2";><center>Note that SELinux uses <code>level</code>, <code>sensitivity</code> and <code>category</code><br>in the language statements (see the <a href="mls_statements.md#mls-statements"> MLS Language Statements</a> section),<br>however when discussing these the following terms can also be used:<br> labels, classifications, and compartments.</center></td>
</tr>
<tr>
<td><center><p><code>sensitivity [: category, ... ]</code><br>also known as:</p>
<p><strong>Sensitivity Label</strong></p>
<p>Consisting of a classification and compartment.</p></center></td>
</tr>
<tr>
<td colspan="3"><center><strong>&lt;-------------- Range --------------&gt;</strong></center></td>
</tr>
<tr>
<td><center><strong>Low</strong></center></td>
<td rowspan="6"><center><strong>-</strong></center></td>
<td><center><strong>High</strong></center></td>
</tr>
<tr>
<td><center><code>sensitivity [: category, ... ]</code></center></td>
<td><center><code>sensitivity [: category, ... ]</code></center></td>
</tr>
<tr>
<td><center>For a process or subject this is the current level or sensitivity</center></td>
<td><center>For a process or subject this is the Clearance</center></td>
</tr>
<tr>
<td><center>For an object this is the current level or sensitivity</center></td>
<td><center>For an object this is the maximum range</center></td>
</tr>
<tr>
<td><center><strong>SystemLow</strong></center></td>

<td><center><strong>SystemHigh</strong></center></td>
</tr>
<tr>
<td><center>This is the lowest level or classification for the system<br>(for SELinux this is generally 's0', note that there are no categories).</center></td>

<td><center>This is the highest level or classification for the system<br>(for SELinux this is generally 's15:c0,c255',<br>although note that they will be the highest set by the policy).</center></td>
</tr>
</tbody>
</table>

**Table 1: Level, Label, Category or Compartment** - *this table shows the meanings depending on the context
being discussed.*

The format used in the policy language statements is fully described in
the [MLS Statements](mls_statements.md#mls-statements) section, however
a brief overview follows.

<br>

#### MLS / MCS Range Format

The following components (shown in bold) are used to define the MLS /
MCS security levels within the security context:

```
user:role:type:sensitivity[:category,...]  -  sensitivity [:category,...]
---------------▼------------------------▼-----▼-------------------------▼
               |        level           |  -  |          level          |
               |                         range                          |
```

**Where:**

<table>
<tbody>
<tr>
<td>sensitivity</td>
<td><p>Sensitivity levels are hierarchical with (traditionally) <code>s0</code> being the lowest. These values are defined using the <em><em>sensitivity</em></em> statement. To define their hierarchy, the <em>dominance</em> statement is used.</p>
<p>For MLS systems the highest sensitivity is the last one defined in the dominance statement (low to high). Traditionally the maximum for MLS systems is <code>s15</code> (although the maximum value for the <em><em>Reference Policy</em></em> is a build time option). </p>
<p>For MCS systems there is only one sensitivity defined, and that is <code>s0</code>.</p></td>
</tr>
<tr>
<td>category</td>
<td>Categories are optional (i.e. there can be zero or more categories) and they form unordered and unrelated lists of 'compartments'. These values are defined using the <code>category</code> statement, where for example <code>c0.c3</code> represents a <code>range (c0 c1 c3)</code> and <code>c0, c3, c7</code> represent an unordered list. Traditionally the values are between <code>c0</code> and <code>c255</code> (although the maximum value for the Reference Policy is a build time option).</td>
</tr>
<tr>
<td>level</td>
<td>The level is a combination of the <code>sensitivity</code> and <code>category</code> values that form the actual security level. These values are defined using the <code>level</code> statement.</td>
</tr>
</tbody>
</table>

<br>

#### Translating Levels

When writing policy for MLS / MCS security level components it is usual
to use an abbreviated form such as `s0`, `s1` etc. to represent
sensitivities and `c0`, `c1` etc. to represent categories. This is done
simply to conserve space as they are held on files as extended
attributes and also in memory. So that these labels can be represented
in human readable form, a translation service is provided via the
[**setrans.conf**](policy_config_files.md#setrans.conf) configuration file that
is used by the ***mcstransd**(8)* daemon. For example `s0` = Unclassified, `s15`
= Top Secret and `c0` = Finance, `c100` = Spy Stories. The ***semanage**(8)*
command can be used to set up this translation and is shown in the
[**setrans.conf**](policy_config_files.md#setrans.conf) configuration file
section.

<br>

### Managing Security Levels via Dominance Rules

As stated earlier, allowing a process access to an object is managed by
[**`dominance`**](mls_statements.md#dominance) rules applied to the security
levels. These rules are as follows:

**Security Level 1 dominates Security Level 2** - If the sensitivity of
Security Level 1 is equal to or higher than the sensitivity of Security
Level 2 and the categories of Security Level 1 are the same or a
superset of the categories of Security Level 2.

**Security Level 1 is dominated by Security Level 2** - If the
sensitivity of Security Level 1 is equal to or lower than the
sensitivity of Security Level 2 and the categories of Security Level 1
are a subset of the categories of Security Level 2.

**Security Level 1 equals Security Level 2** - If the sensitivity of
Security Level 1 is equal to Security Level 2 and the categories of
Security Level 1 and Security Level 2 are the same set (sometimes
expressed as: both Security Levels dominate each other).

**Security Level 1 is incomparable to Security Level 2** - If the
categories of Security Level 1 and Security Level 2 cannot be compared
(i.e. neither Security Level dominates the other).

To illustrate the usage of these rules, **Table 2: MLS Security Levels** lists
the security level attributes in a table to show example files (or
documents) that have been allocated labels such as `s3:c0`. The process
that accesses these files (e.g. an editor) is running with a range of
`s0 - s3:c1.c5` and has access to the files highlighted within the grey box
area.

As the MLS `dominance` statement is used to enforce the
sensitivity hierarchy, the security levels now follow that sequence
(lowest = `s0` to highest = `s3`) with the categories being unordered lists
of 'compartments'. To allow the process access to files within its scope
and within the dominance rules, the process will be constrained by using
the `mlsconstrain` statement as illustrated in
**Figure 9: `mlsconstrain` Statements controlling Read Down & Write Up**.

<table>
<tbody>
<tr>
<td></td>
<td><center><strong>Category -&gt;</strong></center></td>
<td>c0</td>
<td>c1</td>
<td>c2</td>
<td>c3</td>
<td>c4</td>
<td>c5</td>
<td>c6</td>
<td>c7</td>
</tr>
<tr>
<td>s3</td>
<td>Secret</td>
<td>s3:c0</td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;">s3:c5</td>
<td>s3:c6</td>
<td></td>
</tr>
<tr>
<td>s2</td>
<td>Confidential</td>
<td></td>
<td style="background-color:#D3D3D3;">s2:c1</td>
<td style="background-color:#D3D3D3;">s2:c2</td>
<td style="background-color:#D3D3D3;">s2:c3</td>
<td style="background-color:#D3D3D3;">s2:c4</td>
<td style="background-color:#D3D3D3;"></td>
<td></td>
<td>s2:c7</td>
</tr>
<tr>
<td>s1</td>
<td>Restricted</td>
<td>s1:c0</td>
<td style="background-color:#D3D3D3;">s1:c1</td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;"></td>
<td></td>
<td>s1:c7</td>
</tr>
<tr>
<td>s0</td>
<td>Unclassified</td>
<td>s0:c0</td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;">s0:c3</td>
<td style="background-color:#D3D3D3;"></td>
<td style="background-color:#D3D3D3;"></td>
<td></td>
<td>s0:c7</td>
</tr>
<tr>
<td><p><center><strong>^<br><br>Sensitivity</strong></center></p>
</td>
<td><p><center><strong>^<br>Security Level</strong></p>
<p>(sensitivity:category)<br>aka: classification</center></p>
</td>
<td colspan="8"><p><center><strong>^-------- File Labels --------^</strong></center></p>
<p><center>A process running with a range of <code>s0 - s3:c1.c5</code> has access to the files within the grey boxed area.</center></p></td>
</tr>
</tbody>
</table>

**Table 2: MLS Security Levels** - *Showing the scope of a process running
at a security range of `s0 - s3:c1.c5`.*

<br>

![](./images/9-mls-constrain.png)

**Figure 9: Showing the mlsconstrain Statements controlling Read Down & Write Up** - *This ties in with* **Table 2: MLS Security Levels** *that shows a process running with a security range of s0 - s3:c1.c5.*

<br>

Using **Figure 9: `mlsconstrain` Statements controlling Read Down & Write Up**:

1.  To allow write-up, the source level (l1) must be **dominated by**
    the target level (l2):
-   Source level = s0:c3 or s1:c1
-   Target level = s2:c1.c4

As can be seen, either of the source levels are **dominated by** the
target level.

2.  To allow read-down, the source level (l1) must **dominate** the
    target level (l2):
-   Source level = s2:c1.c4
-   Target level = s0:c3

As can be seen, the source level does **dominate** the target level.

However in the real world the SELinux MLS Reference Policy does not
allow the write-up unless the process has a special privilege (by having
the domain type added to an attribute), although it does allow the
read-down. The default is to use l1 eq l2 (i.e. the levels are equal).
The reference policy MLS source file (policy/mls) shows these
`mlsconstrain` statements.


### MLS Labeled Network and Database Support

Networking for MLS is supported via the NetLabel CIPSO (commercial IP
security option) and CALIPSO (Common Architecture Label
IPv6 Security Option) services as discussed in the
[**SELinux Networking Support**](network_support.md#selinux-networking-support)
section.

PostgreSQL supports labeling for MLS database services as discussed in
the [**SE-PostgreSQL Support**](postgresql.md#postgresql-selinux-support)
section.


### Common Criteria Certification

While the [*Common Criteria*](http://www.commoncriteriaportal.org/)
certification process is beyond the scope of this Notebook, it is worth
highlighting that specific Red Hat GNU / Linux versions of software,
running on specific hardware platforms with SELinux / MLS policy
enabled, have passed the Common Criteria evaluation process. Note, for
the evaluation (and deployment) the software and hardware are tied
together, therefore whenever an update is carried out, an updated
certificate should be obtained.

The Red Hat evaluation process cover the:

-   Labeled Security Protection Profile
    ([*LSPP*](http://www.commoncriteriaportal.org/files/ppfiles/lspp.pdf)
    ) - This describes how systems that implement security labels (i.e.
    MLS) should function.
-   Controlled Access Protection Profile
    ([*CAPP*](http://www.commoncriteriaportal.org/files/ppfiles/capp.pdf)) -
    This describes how systems that implement DAC should function.

An interesting point:

-   Both Red Hat Linux 5.1 and Microsoft Server 2003 (with XP) have both
    been certified to EAL4+ , however while the evaluation levels may be
    the same the Protection Profiles that they were evaluated under
    were: Microsoft CAPP only, Red Hat CAPP and LSPP. Therefore always
    look at the protection profiles as they define what was actually
    evaluated.


<br>

<!-- Cut Here -->

<table>
<tbody>
<td><center>
<p><a href="domain_object_transitions.md#domain-and-object-transitions" title="Domain and Object Transitions"> <strong>Previous</strong></a></p>
</center></td>
<td><center>
<p><a href="README.md#the-selinux-notebook" title="The SELinux Notebook"> <strong>Home</strong></a></p>
</center></td>
<td><center>
<p><a href="types_of_policy.md#types-of-selinux-policy" title="Types of SELinux Policy"> <strong>Next</strong></a></p>
</center></td>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>
