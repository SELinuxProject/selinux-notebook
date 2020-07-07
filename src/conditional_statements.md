# Conditional Policy Statements

Conditional policies consist of a bool statement that defines a
condition as `true` or `false`, with a supporting `if` / `else` construct that
specifies what rules are valid under the condition as shown in the
example below:

```
bool allow_daemons_use_tty true;

if (allow_daemons_use_tty) {
    # Rules if condition is true;
} else {
    # Rules if condition is false;
}
```

[**Table 3** in the 'Kernel Policy Language'](kernel_policy_language.md#kernel-policy-language)
section shows what policy statements or rules are valid within the
`if` / `else` construct under the "Conditional Statements" column.

The `bool` statement default value can be changed when a policy is active
by using the ***setsebool**(3)* command as follows:

```
# This command will set the allow_daemons_use_tty bool to false,
# however it will only remain false until the next system
# re-boot where it will then revert back to its default state
# (in the above case, this would be true).

setsebool allow_daemons_use_tty false
```

```
# This command will set the allow_daemons_use_tty bool to false,
# and because the -P option is used (for persistent), the value
# will remain across system re-boots. Note however that all
# other pending bool values will become persistent across
# re-boots as well (see setsebool(8) man page).

setsebool -P allow_daemons_use_tty false
```

The ***getsebool**(3)* command can be used to query the current `bool` statement
value as follows:

```
# This command will list all bool values in the active policy:
getsebool -a
```

```
# This command will show the current allow_daemons_use_tty bool
# value in the active policy:

getsebool allow_daemons_use_tty
```

<br>

## bool

The `bool` statement is used to specify a boolean identifier and its
initial state (`true` or `false`) that can then be used with the
`if` statement to form a 'conditional policy' as described in the
[Types of SELinux Policy](types_of_policy.md#conditional-policy) section.

**The statement definition is:**

`bool bool_id default_value;`

**Where:**

<table>
<tbody>
<tr>
<td><code>bool</code></td>
<td>The <code>bool</code> keyword.</td>
</tr>
<tr>
<td><code>bool_id</code></td>
<td>The boolean identifier.</td>
</tr>
<tr>
<td><code>default_value</code></td>
<td>Either true or false.</td>
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
<td>Yes</td>
</tr>
</tbody>
</table>

**Examples:**

```
# Using the bool statement to allow unconfined executables to
# make their memory heap executable or not. As the value is
# false, then by default they cannot make their heap executable.

bool allow_execheap false;
```

```
# Using the bool statement to allow unconfined executables to
# make their stack executable or not. As the value is true,
# then by default their stacks are executable.

bool allow_execstack true;
```

<br>

### if

The if statement is used to form a 'conditional block' of statements and
rules that are enforced depending on whether one or more boolean
identifiers evaluate to `TRUE` or `FALSE`. An `if` / `else`
construct is also supported.

The only statements and rules allowed within the `if` / `else` construct
are:

`allow`, `auditallow`, `auditdeny`, `dontaudit`, `type_member`, `type_transition`
(except `file_name_transition`), `type_change` and `require`.

**The statement definition is:**

`if (conditional_expression) { true_list } [ else { false_list } ]`

**Where:**

<table>
<tbody>
<tr>
<td><code>if</code></td>
<td>The <code>if</code> keyword.</td>
</tr>
<tr>
<td>conditional_expression</td>
<td><p>One or more <code>bool_name<code> identifiers that have been previously defined by the <code>bool</code> Statement. Multiple identifiers must be separated by the following logical operators: &amp;&amp;, ¦¦, ^, !, ==, !=. </p>
<p>The conditional_expression is enclosed in brackets ().</p></td>
</tr>
<tr>
<td><code>true_list</code></td>
<td><p>A list of rules enclosed within braces '{}' that will be executed when the <code>conditional_expression</code> is 'true'.</p>
<p>Valid statements and rules are highlighted within each language definition statement.</p></td>
</tr>
<tr>
<td><code>else</code></td>
<td>Optional <code>else</code> keyword.</td>
</tr>
<tr>
<td><code>false_list</code></td>
<td><p>A list of rules enclosed within braces '{}' that will be executed when the optional <code>else</code> keyword is present and the conditional_expression is <code>false</code>.</p>
<p>Valid statements and rules are highlighted within each language definition statement.</p></td>
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
# An example showing a boolean and supporting if statement.
bool allow_execmem false;
```

```
# The bool allow_execmem is FALSE therefore the allow statement is not executed:

if (allow_execmem) {
    allow sysadm_t self:process execmem;

}
```

```
# An example showing two booleans and a supporting if statement.

bool allow_execmem false;
bool allow_execstack true;

# The bool allow_execmem is FALSE and allow_execstack is TRUE
# therefore the allow statement is not executed:

if (allow_execmem && allow_execstack) {
    allow sysadm_t self:process execstack;

}
```

```
# An example of an IF - ELSE statement where the bool statement
# is FALSE, therefore the ELSE statements will be executed.
#

bool read_untrusted_content false;

if (read_untrusted_content) {
    allow sysadm_t { sysadm_untrusted_content_t sysadm_untrusted_content_tmp_t }:dir { getattr search read lock ioctl };
.....

} else {
    dontaudit sysadm_t { sysadm_untrusted_content_t
    sysadm_untrusted_content_tmp_t }:dir { getattr search read lock ioctl };
    ...
}
```

<br>

<!-- %CUTHERE% -->

---
**[[ PREV ]](class_permission_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](constraint_statements.md)**
