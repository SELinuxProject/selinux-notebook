# MLS Statements

The optional MLS policy extension adds an additional security context
component that consists of the following highlighted entries:

```
user:role:type:sensitivity[:category,...]- sensitivity [:category,...]
```

These consist of a mandatory hierarchical
[**sensitivity**](#sensitivity) and optional
non-hierarchical [**category**](#category)'s. The
combination of the two comprise a [**level**](#level) or security level as
shown in **Table 1: Sensitivity and Category = Security Level**. Depending on
the circumstances, there can be one level defined or a
[**range**](#mls-range-definition) as shown in **Table 1**.

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

**Table 1: Sensitivity and Category = Security Level** - *this table shows
the meanings depending on the context being discussed.*


To make the security levels more meaningful, it is possible to use the
setransd daemon to translate these to human readable formats. The
**semanage**(8) command will allow this mapping to be defined as discussed
in the [**setrans.conf**](policy_config_files.md#setrans.conf) section.


#### MLS range Definition

The MLS range is appended to a number of statements and defines the lowest and
highest security levels. The range can also consist of a single level as
discussed at the start of the [**MLS section**](#mls-statements).

**The definition is:**

```
low_level [ - high_level ]
```

**Where:**

<table>
<tbody>
<tr>
<td><code>low_level</code></td>
<td><p>The processes lowest level identifier that has been previously declared by a <a href="#level"><code>level</code></a> statement.</p>
<p>If a <code>high_level</code> is not defined, then it is taken as the same as the <code>low_level</code>.</p></td>
</tr>
<tr>
<td>-</td>
<td>The optional hyphen '-' separator if a <code>high_level</code> is also being defined.</td>
</tr>
<tr>
<td><code>high_level</code></td>
<td>The processes highest level identifier that has been previously declared by a <a href="#level"><code>level</code></a> statement. </td>
</tr>
</tbody>
</table>


## `sensitivity`

The sensitivity statement defines the MLS policy sensitivity identifies
and optional alias identifiers.

**The statement definition is:**

```
sensitivity sens_id [alias sensitivityalias_id ...];
```

**Where:**

<table>
<tbody>
<tr>
<td><code>sensitivity</code></td>
<td>The <code>sensitivity</code> keyword.</td>
</tr>
<tr>
<td><code>sens_id</code></td>
<td>The <code>sensitivity</code> identifier.</td>
</tr>
<tr>
<td><code>alias</code></td>
<td>The optional <code>alias</code> keyword.</td>
</tr>
<tr>
<td><code>sensitivityalias_id</code></td>
<td>One or more sensitivity alias identifiers in a space separated list.</td>
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
<td>Yes</td>
</tr>
</tbody>
</table>

**Examples:**

```
# The MLS Reference Policy default is to assign 16 sensitivity
# identifiers (s0 to s15):

sensitivity s0;
....
sensitivity s15;
```

```
# The policy does not specify any alias entries, however a valid
# example would be:

sensitivity s0 alias secret wellmaybe ornot;
```


## `dominance`

When more than one [`sensitivity`](#sensitivity)
statemement is defined within a policy, then a `dominance` statement is
required to define the actual hierarchy between all sensitivities.

**The statement definition is:**

```
dominance { sensitivity_id ... }
```

**Where:**

<table>
<tbody>
<tr>
<td><code>dominance</code></td>
<td>The <code>dominance</code> keyword.</td>
</tr>
<tr>
<td><code>sensitivity_id</code></td>
<td>A space separated list of previously declared <code>sensitivity</code> or <code>sensitivityalias</code> identifiers in the order lowest to highest. They are enclosed in braces '{}', and note that there is no terminating semi-colon ';'.</td>
</tr>
</tbody>
</table>

The statement is valid in:

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
# The MLS Reference Policy dominance statement defines s0 as the
# lowest and s15 as the highest sensitivity level:

dominance { s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 }
```


## `category`

The `category` statement defines the MLS policy category
identifiers and optional alias identifiers.

**The statement definition is:**

```
category category_id [alias categoryalias_id ...];
```

**Where:**

<table>
<tbody>
<tr>
<td><code>category</code></td>
<td>The <code>category</code> keyword.</td>
</tr>
<tr>
<td><code>category_id</code></td>
<td>The <code>category</code> identifier.</td>
</tr>
<tr>
<td><code>alias</code></td>
<td>The optional <code>alias</code> keyword.</td>
</tr>
<tr>
<td><code>categoryalias_id</code></td>
<td>One or more <code>alias</code> identifiers in a space separated list.</td>
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
<td>Yes</td>
</tr>
</tbody>
</table>

**Examples:**

```
# The MLS Reference Policy default is to assign 256 category
# identifiers (c0 to c255):

category c0;
...
category c255;
```

```
# The policy does not specify any alias entries, however a valid
# example would be:

category c0 alias planning development benefits;
```


## `level`

The `level` statement enables the previously declared sensitivity and
category identifiers to be combined into a Security Level.

Note there must only be one `level` statement for each
[`sensitivity`](#sensitivity) statemement.

**The statement definition is:**

```
level sensitivity_id [ :category_id ];
```

**Where:**

<table>
<tbody>
<tr>
<td><code>level</code></td>
<td>The <code>level</code> keyword.</td>
</tr>
<tr>
<td><code>sensitivity_id</code></td>
<td>A previously declared <code>sensitivity</code> or <code>sensitivityalias</code> identifier.</td>
</tr>
<tr>
<td><code>category_id</code></td>
<td>An optional set of zero or more previously declared <code>category</code> or <code>categoryalias</code> identifiers that are preceded by a colon ':', that can be written as follows:
<p>The period '.' separating two <code>category</code> identifiers means an inclusive set (e.g. <code>c0.c16</code>).</p>
<p>The comma ',' separating two <code>category</code> identifiers means a non-contiguous list (e.g. <code>c21,c36,c45</code>).</p>
<p>Both separators may be used (e.g. <code>c0.c16,c21,c36,c45</code>).</p></td>
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
# The MLS Reference Policy default is to assign each Security Level with
# the complete set of categories (i.e. the inclusive set from c0 to c255):

level s0:c0.c255;
...
level s15:c0.c255;
```


## `range_transition`

The `range_transition` statement is primarily used by the init process or
administration commands to ensure processes run with their correct MLS
range (for example *init* would run at **SystemHigh** and needs to initialise
/ run other processes at their correct MLS range). The statement was
enhanced in Policy version 21 to accept other object classes.

**The statement definition is (for pre-policy version 21):**

```
range_transition source_type target_type new_range;
```

**or (for policy version 21 and greater):**

```
range_transition source_type target_type : class new_range;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>range_transition</code></td>
<td>The <code>range_transition</code> keyword.</td>
</tr>
<tr>
<td><p><code>source_type</code></p>
<p><code>target_type</code></p></td>
<td><p>One or more source / target <code>type</code> or <code>attribute</code> identifiers. Multiple entries consist of a space separated list enclosed in braces'{}'.</p>
<p>Entries can be excluded from the list by using the negative operator '-'.</p></td>
</tr>
<tr>
<td><code>class</code></td>
<td>The optional object <code>class</code> keyword (this allows policy versions 21 and greater to specify a class other than the default of <code>process</code>).</td>
</tr>
<tr>
<td><code>new_range</code></td>
<td>The new MLS range for the object class. The format of this field is described in the <a href="#mls-range-definition">"MLS range Definition"</a> section.</td>
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
<td>Yes</td>
<td>No</td>
</tr>
</tbody>
</table>

**Examples:**

```
# A range_transition statement from the MLS Reference Policy
# showing that a process anaconda_t can transition between
# systemLow and systemHigh depending on calling applications level.

range_transition anaconda_t init_script_file_type:process s0-s15:c0.c255;
```

```
# Two range_transition statements from the MLS Reference Policy
# showing that init will transition the audit and cups daemon
# to systemHigh (that is the lowest level they can run at).

range_transition initrc_t auditd_exec_t:process s15:c0.c255;
range_transition initrc_t cupsd_exec_t:process s15:c0.c255;
```


## `mlsconstrain`

This is decribed in the
[**Constraint Statements - `mlsconstrain`**](constraint_statements.md#mlsconstrain)
section.


## `mlsvalidatetrans`

This is decribed in the
[**Constraint Statements - `mlsvalidatetrans`**](constraint_statements.md#mlsvalidatetrans)
section.


<!-- %CUTHERE% -->

---
**[[ PREV ]](constraint_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](sid_statement.md)**
