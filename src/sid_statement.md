# Security ID (SID) Statement

There are two *sid* statements, the first one declares the actual *sid*
identifier and is defined at the start of a policy source file. The
second statement is used to associate an initial security context to the
*sid*, this is used when SELinux initialises but the policy has not yet
been activated or as a default context should an object have an invalid
label.

## *sid*

The *sid* statement declares the actual SID identifier and is defined at
the start of a policy source file.

**The statement definition is:**

```
sid sid_id
```

**Where:**

<table>
<tbody>
<tr>
<td><code>sid</code></td>
<td>The <code>sid</code> keyword.</td>
</tr>
<tr>
<td><code>sid_id</code></td>
<td>The <code>sid</code> identifier.</td>
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
<td>No</td>
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

**Example:**

```
# This example has been taken from the Reference Policy source
# policy/flask/initial_sids file and declares some of the initial SIDs:
#

sid kernel
sid security
sid unlabeled
sid fs
```

## *sid context*

The *sid context* statement is used to associate an initial security
context to the SID.

**The statement definition is:**

```
sid sid_id context
```

**Where:**

<table>
<tbody>
<tr>
<td><code>sid</code></td>
<td>The <code>sid<code> keyword.</td>
</tr>
<tr>
<td><code>sid_id</code></td>
<td>The previously declared sid identifier. </td>
</tr>
<tr>
<td><code>context</code></td>
<td>The initial security context.</td>
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
<td>No</td>
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

**Examples:**

```
# This is from a targeted policy:

sid unlabeled
...
sid unlabeled system_u:object_r:unlabeled_t
```

```
# This is from an MLS policy. Note that the security level
# is set to SystemHigh as it may need to label any object in
# the system.

sid unlabeled
...
sid unlabeled system_u:object_r:unlabeled_t:s15:c0.c255
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](mls_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](file_labeling_statements.md)**
