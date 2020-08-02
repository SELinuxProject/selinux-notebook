# Default Object Rules

These rules allow a default user, role, type and/or range to be used
when computing a context for a new object. These require policy version
27 or 28 with kernels 3.5 or greater.

## *default_user*

Allows the default user to be taken from the source or target context
when computing a new context for an object of the defined class.
Requires policy version 27.

**The statement definition is:**

```
default_user class default;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>default_user</code></td>
<td>The <code>default_user</code> rule keyword.</td>
</tr>
<tr>
<td><p><code>class</code></p></td>
<td><p>One or more <code>class</code> identifiers. Multiple entries consist of a space separated list enclosed in braces '{}'. </p>
<p>Entries can be excluded from the list by using the negative operator '-'.</p></td>
</tr>
<tr>
<td><code>default</code></td>
<td>A single keyword consisting of either <code>source</code> or <code>target</code> that will state whether the default user should be obtained from the source or target context.</td>
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
# When computing the context for a new file object, the user
# will be obtained from the target context.

default_user file target;
```

```
# When computing the context for a new x_selection or x_property
# object, the user will be obtained from the source context.

default_user { x_selection x_property } source;
```

## *default_role*

Allows the default role to be taken from the source or target context
when computing a new context for an object of the defined class.
Requires policy version 27.

**The statement definition is:**

```
default_role class default;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>default_role</code></td>
<td>The <code>default_role</code> rule keyword.</td>
</tr>
<tr>
<td><p><code>class</code></p></td>
<td><p>One or more <code>class</code> identifiers. Multiple entries consist of a space separated list enclosed in braces '{}'. </p>
<p>Entries can be excluded from the list by using the negative operator '-'.</p></td>
</tr>
<tr>
<td><code>default</code></td>
<td>A single keyword consisting of either <code>source</code> or <code>target</code> that will state whether the default role should be obtained from the source or target context.</td>
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
# When computing the context for a new file object, the role
# will be obtained from the target context.

default_role file target;
```

```
# When computing the context for a new x_selection or x_property
# object, the role will be obtained from the source context.

default_role { x_selection x_property } source;
```

## *default_type*

Allows the default type to be taken from the source or target context
when computing a new context for an object of the defined class.
Requires policy version 28.

**The statement definition is:**

```
default_type class default;
```

**Where:**

<table>
<tbody>
<tr>
<td><code>default_type</code></td>
<td>The <code>default_type</code> rule keyword.</td>
</tr>
<tr>
<td><p><code>class</code></p></td>
<td><p>One or more <code>class</code> identifiers. Multiple entries consist of a space separated list enclosed in braces '{}'. </p>
<p>Entries can be excluded from the list by using the negative operator '-'.</p></td>
</tr>
<tr>
<td><code>default</code></td>
<td>A single keyword consisting of either <code>source</code> or <code>target</code> that will state whether the default type should be obtained from the source or target context.</td>
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
# When computing the context for a new file object, the type
# will be obtained from the target context.

default_type file target;
```

```
# When computing the context for a new x_selection or x_property
# object, the type will be obtained from the source context.

default_type { x_selection x_property } source;
```

## *default_range*

Allows the default range or level to be taken from the source or target
context when computing a new context for an object of the defined class.
Requires policy version 27.

Policy verion 32 with kernel 5.5 allows the use of *glblub* as a
*default_range* default and the computed transition will be the
intersection of the MLS range of the two contexts. The *glb* (greatest
lower bound) *lub* (lowest upper bound) of a range is calculated as the
greater of the low sensitivities and the lower of the high sensitivities.

**The statement definition is:**

```
default_range class [default range] | [glblub];
```

**Where:**

<table>
<tbody>
<tr>
<td><code>default_range</code></td>
<td>The <code>default_range</code> rule keyword.</td>
</tr>
<tr>
<td><p><code>class</code></p></td>
<td><p>One or more <code>class</code> identifiers. Multiple entries consist of a space separated list enclosed in braces '{}'. </p>
<p>Entries can be excluded from the list by using the negative operator '-'.</p></td>
</tr>
<tr>
<td><code>default</code></td>
<td>A single keyword consisting of either <code>source</code> or <code>target</code> that will state whether the default level or range should be obtained from the source or target context.</td>
</tr>
<tr>
<td><code>range</code></td>
<td>A single keyword consisting of either: <code>low</code>, <code>high</code> or <code>low_high</code> that will state what part of the range should be used.</td>
</tr>
<tr>
<td><code>glblub</code></td>
<td>The <code>glblub</code> keyword used instead of <code>[default range]</code>.</td>
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
# When computing the context for a new file object, the lower
# level will be taken from the target context range.

default_range file target low;
```

```
# When computing the context for a new x_selection or x_property
# object, the range will be obtained from the source context.

default_type { x_selection x_property } source low_high;
```

```
# When computing the context of a new object with a level of:
#     s0-s1:c0.c12
#  and a level of:
#     s0-s1:c0.c1023
# the resulting computed level will be:
#     s0-s1:c0.c12

default_range db_table glblub;
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](policy_config_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](user_statements.md)**
