# Xen Statements

Xen policy supports additional policy language statements: `iomemcon`,
`ioportcon`, `pcidevicecon`, `pirqcon` and `devicetreecon` that are
discussed in the sections that follow, also the
[**XSM/FLASK Configuration**](http://xenbits.xen.org/docs/4.2-testing/misc/xsm-flask.txt)
document contains further information.

Policy version 30 introduced the `devicetreecon` statement and also
expanded the existing I/O memory range to 64 bits in order to support
hardware with more than 44 bits of physical address space (32-bit count
of 4K pages).

To compile these additional statements using ***semodule**(8)*, ensure
that the ***semanage.conf**(5)* file has the *policy-target=xen* entry.

<br>

## `iomemcon`

Label i/o memory. This may be a single memory location or a range.

**The statement definition is:**

`iomemcon addr context`

**Where:**

<table>
<tbody>
<tr>
<td><code>iomemcon</code></td>
<td>The <code>iomemcon</code> keyword.</td>
</tr>
<tr>
<td><code>addr</code></td>
<td>The memory address to apply the context. This may also be a range that consists of a start and end address separated by a hypen '-'.</td>
</tr>
<tr>
<td><code>context</code></td>
<td>The security context to be applied.</td>
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
iomemcon 0xfebd9 system_u:object_r:nicP_t
iomemcon 0xfebe0-0xfebff system_u:object_r:nicP_t
```

<br>

## `ioportcon`

Label i/o ports. This may be a single port or a range.

**The statement definition is:**

`ioportcon port context`

**Where:**

<table>
<tbody>
<tr>
<td><code>ioportcon</code></td>
<td>The <code>ioportcon</code> keyword.</td>
</tr>
<tr>
<td><code>port</code></td>
<td>The <code>port</code> to apply the context. This may also be a range that consists of a start and end port number separated by a hypen '-'.</td>
</tr>
<tr>
<td><code>context</code></td>
<td>The security context to be applied.</td>
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
ioportcon 0xeac0 system_u:object_r:nicP_t
ioportcon 0xecc0-0xecdf system_u:object_r:nicP_t
```

<br>

## `pcidevicecon`

Label a PCI device.

**The statement definition is:**

`pcidevicecon pci_id context`

**Where:**

<table>
<tbody>
<tr>
<td><code>pcidevicecon</code></td>
<td>The <code>pcidevicecon</code> keyword.</td>
</tr>
<tr>
<td><code>pci_id</code></td>
<td>The PCI indentifer.</td>
</tr>
<tr>
<td><code>context</code></td>
<td>The security context to be applied.</td>
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

`pcidevicecon 0xc800 system_u:object_r:nicP_t`

<br>

## `pirqcon`

Label an interrupt level.

**The statement definition is:**

`pirqcon irq context`

**Where:**

<table>
<tbody>
<tr>
<td><code>pirqcon</code></td>
<td>The <code>pirqcon</code> keyword.</td>
</tr>
<tr>
<td><code>irq</code></td>
<td>The interrupt request number.</td>
</tr>
<tr>
<td><code>context</code></td>
<td>The security context to be applied.</td>
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

`pirqcon 33 system_u:object_r:nicP_t`

<br>

## `devicetreecon`

Label device tree nodes.

**The statement definition is:**

`devicetreecon path context`

**Where:**

<table>
<tbody>
<tr>
<td><code>devicetreecon</code></td>
<td>The <code>devicetreecon</code> keyword.</td>
</tr>
<tr>
<td><code>path</code></td>
<td>The device tree path. If this contains spaces enclose within <em>""</em> as shown in the example.</td>
</tr>
<tr>
<td><code>context</code></td>
<td>The security context to be applied.</td>
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

`devicetreecon "/this is/a/path" system_u:object_r:arm_path`


<br>

<!-- %CUTHERE% -->

---
**[[ PREV ]](infiniband_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](modular_policy_statements.md)**
