# Policy Configuration Statements

## `policycap`

Policy version 22 introduced the `policycap` statement to allow new
capabilities to be enabled or disabled in the kernel via policy in a
backward compatible way. For example policies that are aware of a new
capability can enable the functionality, while older policies would
continue to use the original functionality.

**The statement definition is:**

`policycap capability;`

**Where:**

<table>
<tbody>
<tr>
<td><code>policycap</code></td>
<td>The <code>policycap</code> keyword.</td>
</tr>
<tr>
<td><code>capability</code></td>
<td>A single <code>capability</code> identifier that will be enabled for this policy.</td>
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
# This statement enables the network_peer_controls to be enabled
# for use by the policy.
#
policycap network_peer_controls;
```


<!-- %CUTHERE% -->

---
**[[ PREV ]](kernel_policy_language.md)** **[[ TOP ]](#)** **[[ NEXT ]](default_rules.md)**
