# Access Vector Rules

The AV rules define what access control privileges are allowed for
processes and objects. There are four types of AV rule: `allow`,
`dontaudit`, `auditallow`, and `neverallow` as explained in the sections that
follow with a number of examples to cover all the scenarios.

The general format of an AV rule is that the `source_type` is the
identifier of a process that is attempting to access an object
identifier `target_type`, that has an object class of `class`, and
`perm_set` defines the access permissions `source_type` is allowed.

From Policy version 30 with the target platform '*selinux*', the AVC
rules have been extended to expand the permission sets from a fixed 32
bits to permission sets in 256 bit increments. The format of the new
`allowxperm`, `dontauditxperm`, `auditallowxperm` and `neverallowxperm`
rules are discussed in the
[**Extended Access Vector Rules**](xperm_rules.md#extended-access-vector-rules)
section.

**The common format for Access Vector Rules are:**

```
rule_name source_type target_type : class perm_set;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>rule_name</code></td>
<td>The applicable <code>allow</code>, <code>dontaudit</code>, <code>auditallow</code>, and <code>neverallow</code> rule keyword.</td>
</tr>
<tr>
<td><p><code>source_type</code></p>
<p><code>target_type</code></p></td>
<td><p>One or more source / target <code>type</code>, <code>typealias</code> or <code>attribute</code> identifiers. Multiple entries consist of a space separated list enclosed in braces '{}'. Entries can be excluded from the list by using the negative operator '-'.</p>
<p>The `target_type` can have the self keyword instead of <code>type</code>, <code>typealias</code> or <code>attribute</code> identifiers. This means that the `target_type` is the same as the `source_type`.</p>
<p>The <code>neverallow</code> rule also supports the wildcard operator '*' to specify that all types are to be included and the complement operator '~' to specify all types are to be included except those explicitly listed.</p></td>
</tr>
<tr>
<td><code>class</code></td>
<td>One or more object classes. Multiple entries consist of a space separated list enclosed in braces '{}'.</td>
</tr>
<tr>
<td>perm_set</td>
<td><p>The access permissions the source is allowed to access for the target object (also known as the Access Vector). Multiple entries consist of a space separated list enclosed in braces '{}'. </p>
<p>The optional wildcard operator '*' specifies that all permissions for the object <code>class</code> can be used. </p>
<p>The complement operator '~' is used to specify all permissions except those explicitly listed (although the compiler issues a warning if the <code>dontaudit</code> rule has '~'.</p></td>
</tr>
</tbody>
</table>

**The statements are valid in:**

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
<td><strong>Yes:</strong> <code>allow</code>, <code>dontaudit</code>, <code>auditallow</code> <strong>No:</strong> <code>neverallow</code></td>
<td><strong>Yes:</strong> <code>allow</code>, <code>dontaudit</code>, <code>auditallow</code>, <code>neverallow</code></td>
<td><strong>No:</strong> <code>allow</code>, <code>dontaudit</code>, <code>auditallow</code>, <code>neverallow</code></td>
</tr>
</tbody>
</table>


## `allow`

The allow rule checks whether the operations between the source\_type
and target_type are allowed for the class and permissions defined. It
is the most common statement that many of the **Reference Policy**
helper macros and interface definitions expand into multiple allow rules.

**Examples:**

```
# Using the allow rule to show that initrc_t is allowed access
# to files of type acct_exec_t that have the getattr, read and
# execute file permissions:

allow initrc_t acct_exec_t:file { getattr read execute };
```

```
# This rule includes an attribute filesystem_type and states
# that kernel_t is allowed mount permissions on the filesystem
# object for all types associated to the filesystem_type attribute:

allow kernel_t filesystem_type:filesystem mount;
```

```
# This rule includes the self keyword in the target_type that
# states that staff_t is allowed setgid, chown and fowner
# permissions on the capability object:

allow staff_t self:capability { setgid chown fowner };

# This would be the same as the above:
allow staff_t staff_t:capability { setgid chown fowner };
```

```
# This rule includes the wildcard operator (*) on the perm_set
# and states that bootloader_t is allowed to use all permissions
# available on the dbus object that are type system_dbusd_t:
allow bootloader_t system_dbusd_t:dbus *;

# This would be the same as the above:
allow bootloader_t system_dbusd_t:dbus { acquire_svc send_msg };
```

```
# This rule includes the complement operator (~) on the perm_set
# and two class entries file and chr_file.
#
# The allow rule states that all types associated with the
# attribute files_unconfined_type are allowed to use all
# permissions available on the file and chr_file objects except
# the execmod permission when they are associated to the types
# listed within the attribute file_type:

allow files_unconfined_type file_type:{ file chr_file } ~execmod;
```


## `dontaudit`

The `dontaudit` rule stops the auditing of denial messages as it is known
that this event always happens and does not cause any real issues. This
also helps to manage the audit log by excluding known events.

**Example:**

```
# Using the dontaudit rule to stop auditing events that are
# known to happen. The rule states that when the traceroute_t
# process is denied access to the name_bind permission on a
# tcp_socket for all types associated to the port_type
# attribute (except port_t), then do not audit the event:

dontaudit traceroute_t { port_type -port_t }:tcp_socket name_bind;
```


## `auditallow`

Audit the event as a record as it is useful for auditing purposes. Note
that this rule only audits the event, it still requires the `allow` rule
to grant permission.

**Example:**

```
# Using the auditallow rule to force an audit event to be
# logged. The rule states that when the ada_t process has
# permission to execstack, then that event must be audited:

auditallow ada_t self:process execstack;
```


## `neverallow`

This rule specifies that an `allow` rule must not be generated for the
operation, even if it has been previously allowed. The `neverallow`
statement is a compiler enforced action, where the ***checkpolicy**(8)*,
***checkmodule**(8)* <a href="#fna1" class="footnote-ref" id="fnavc1"><sup>1</sup></a>
or ***secilc**(8)* <a href="#fna2" class="footnote-ref" id="fnavc2"><sup>2</sup></a>
compiler checks if any allow rules have been generated in the policy source,
if so it will issue a warning and stop.

**Examples**:

```
# Using the neverallow rule to state that no allow rule may ever
# grant any file read access to type shadow_t except those
# associated with the can_read_shadow_passwords attribute:

neverallow ~can_read_shadow_passwords shadow_t:file read;
```

```
# Using the neverallow rule to state that no allow rule may ever
# grant mmap_zero permissions any type associated to the domain
# attribute except those associated to the mmap_low_domain_type
# attribute (as these have been excluded by the negative operator '-'):

neverallow { domain -mmap_low_domain_type } self:memprotect mmap_zero;
```


<section class="footnotes">
<ol>
<li id="fna1"><p><code>neverallow</code> statements are allowed in modules, however to detect these the <em>semanage.conf</em> file must have the 'expand-check=1' entry present.<a href="#fnavc1" class="footnote-back">↩</a></p></li>
<li id="fna2"><p>The `--disable-neverallow` option can be used with <em></strong>secilc</strong>(8)</em> to disable <code>neverallow</code> rule checking.<a href="#fnavc2" class="footnote-back">↩</a></p></li>
</ol>
</section>


<!-- %CUTHERE% -->

---
**[[ PREV ]](bounds_rules.md)** **[[ TOP ]](#)** **[[ NEXT ]](xperm_rules.md)**
