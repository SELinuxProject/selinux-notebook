# Extended Access Vector Rules

There are three extended AV rules implemented from Policy version 30
with the target platform 'selinux' that expand the permission sets from
a fixed 32 bits to permission sets in 256 bit increments: `allowxperm`,
`dontauditxperm`, `auditallowxperm` and `neverallowxperm`.

The rules for extended permissions are subject to the 'operation' they
perform with Policy version 30 and kernels from 4.3 supporting ioctl
whitelisting (if required to be declared in modular policy, then
libsepol 2.7 minimum is required).

**The common format for Extended Access Vector Rules are:**

`rule_name source_type target_type : class operation xperm_set;`

**Where:**

<table>
<tbody>
<tr>
<td><code>rule_name</code></td>
<td>The applicable <code>allowxperm</code>, <code>dontauditxperm</code>, <code>auditallowxperm</code> or <code>neverallowxperm</code> rule keyword.</td>
</tr>
<tr>
<td><p><code>source_type</code></p>
<p><code>target_type</code></p></td>
<td><p>One or more source / target <code>type</code>, <code>typealias</code> or <code>attribute</code> identifiers. Multiple entries consist of a space separated list enclosed in braces '{}'. Entries can be excluded from the list by using the negative operator '-'.</p>
<p>The target_type can have the <code>self</code> keyword instead of <code>type</code>, <code>typealias</code> or <code>attribute</code> identifiers. This means that the <code>target_type</code> is the same as the <code>source_type</code>.</p></td>
</tr>
<tr>
<td><code>class</code></td>
<td>One or more object classes. Multiple entries consist of a space separated list enclosed in braces '{}'.</td>
</tr>
<tr>
<td><code>operation<code></td>
<td>A key word defining the operation to be implemented by the rule. Currently only the <code>ioctl</code> operation is supported by the kernel policy language and kernel as described in the  <a href="#ioctl-operation-rules"><code>ioctl</code> Operation Rules</a> section.</td>
</tr>
<tr>
<td><code>xperm_set</code></td>
<td><p>One or more extended permissions represented by numeric values (i.e. <code>0x8900</code> or <code>35072</code>). The usage is dependent on the specified <em>operation</em>.</p>
<p>Multiple entries consist of a space separated list enclosed in braces '{}'.</p>
<p>The complement operator '~' is used to specify all permissions except those explicitly listed.</p>
<p>The range operator '-' is used to specify all permissions within the <code>low – high</code> range.</p>
<p>An example is shown in the <a href="#ioctl-operation-rules"><code>ioctl</code> Operation Rules</a> section.</p></td>
</tr>
</tbody>
</table>

**The statement is valid in:**

<table style="text-align:center">
<tbody>
<tr style="background-color:#D3D3D3;">
<td><strong>Monolithic Policy</strong></td>
<td><strong>Base Policy</strong></td>
<td><strong>Module Policy</strong></td>
</tr>
<tr>
<td>Yes</td>
<td>Yes</td>
<td>Yes</td>
</tr>
<tr style="background-color:#D3D3D3;">
<td><strong>Conditional Policy <code>if</code> Statement</strong></td>
<td><strong><code>optional</code> Statement</strong></td>
<td><strong><code>require</code> Statement</strong></td>
</tr>
<tr>
<td>No</td>
<td>No</td>
<td>No</td>
</tr>
</tbody>
</table>
<br>

### `ioctl` Operation Rules

Use cases and implementation details for ioctl command whitelisting are
described in detail at
<http://marc.info/?l=selinux&m=143336061925628&w=2>, with the final
policy format changes shown in the example below with a brief overview
(also see <http://marc.info/?l=selinux&m=143412575302369&w=2>) that is
the final upstream kernel patch).

Ioctl calls are generally used to get or set device options. Policy
versions &lt; 30 only controls whether an `ioctl` permission is allowed
or not, for example this rule allows the object class `tcp_socket` the
`ioctl` permission:

`allow src_t tgt_t : tcp_socket ioctl;`

From Policy version 30 it is possible to control ***ioctl**(2)*
'*request*' parameters provided the `ioctl` permission is also allowed,
for example:

```
allow src_t tgt_t : tcp_socket ioctl;

allowxperm src_t tgt_t : tcp_socket ioctl ~0x8927;
```

The `allowxperm` rule states that all ioctl request parameters are
allowed for the source/target/class with the exception of the value
`0x8927` that (using *include/linux/sockios.h*) is **SIOCGIFHWADDR**, or
'get hardware address'.

An example audit log entry denying an ioctl request to add a routing
table entry (**SIOCADDRT** - `ioctlcmd=890b`) for *goldfish_setup* on a
`udp_socket` is:

```
type=1400 audit(1437408413.860:6): avc: denied { ioctl } for pid=81
comm="route" path="socket:[1954]" dev="sockfs" ino=1954 ioctlcmd=890b
scontext=u:r:goldfish_setup:s0 tcontext=u:r:goldfish_setup:s0
tclass=udp_socket permissive=0
```

Notes:

1.  Important: The ioctl operation is not 'deny all' ioctl requests
    (hence whitelisting). It is targeted at the specific
    source/target/class set of ioctl commands. As no other `allowxperm`
    rules have been defined in the example, all other ioctl calls may
    continue to use any valid request parameters (provided there are
    `allow` rules for the `ioctl` permission).
2.  As the ***ioctl**(2)* function requires a file descriptor, its
    context must match the process context otherwise the `fd { use }`
    class/permission is required.
3.  To deny all ioctl requests for a specific source/target/class the
    `xperm_set` should be set to `0` or `0x0`.


<br>

<!-- %CUTHERE% -->

<table>
<tbody>
<td><center>
<p><a href="avc_rules.md#access-vector-rules" title="Access Vector Rules"> <strong>Previous</strong></a></p>
</center></td>
<td><center>
<p><a href="README.md#the-selinux-notebook" title="The SELinux Notebook"> <strong>Home</strong></a></p>
</center></td>
<td><center>
<p><a href="class_permission_statements.md#object-class-and-permission-statements" title="Object Class and Permission Statements"> <strong>Next</strong></a></p>
</center></td>
</tbody>
</table>

<head>
    <style>table { border-collapse: collapse; }
    table, td, th { border: 1px solid black; }
    </style>
</head>
