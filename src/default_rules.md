# Default Object Rules

- [*default_user*](#default_user)
- [*default_role*](#default_role)
- [*default_type*](#default_type)
- [*default_range*](#default_range)

These rules allow a default user, role, type and/or range to be used
when computing a context for a new object. These require policy version
27 or 28 with kernels 3.5 or greater, for *glblub* support version 32 with
kernel 5.5 is required.

## *default_user*

Allows the default user to be taken from the source or target context
when computing a new context for an object of the defined class.
Requires policy version 27.

**The statement definition is:**

```
default_user class default;
```

**Where:**

*default_user*

The *default_user* rule keyword.

*class*

One or more *class* identifiers. Multiple entries consist of a space separated
list enclosed in braces \'\{\}\'. Entries can be excluded from the list by using
the negative operator \'\-\'.

*default*

A single keyword consisting of either *source* or *target* that will state
whether the default user should be obtained from the source or target context.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

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

*default_role*

The *default_role* rule keyword.

*class*

One or more *class* identifiers. Multiple entries consist of a space
separated list enclosed in braces \'\{\}\'.
Entries can be excluded from the list by using the negative operator \'\-\'.

*default*

A single keyword consisting of either *source* or *target* that will state
whether the default role should be obtained from the source or target context.


**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

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

*default_type*

The *default_type* rule keyword.

*class*

One or more *class* identifiers. Multiple entries consist of a space
separated list enclosed in braces \'\{\}\'. Entries can be excluded from the
list by using the negative operator \'\-\'.

*default*

A single keyword consisting of either *source* or *target* that will state
whether the default type should be obtained from the source or target context.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

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

Policy version 32 with kernel 5.5 allows the use of *glblub* as a
*default_range* default and the computed transition will be the
intersection of the MLS range of the two contexts. The *glb* (greatest
lower bound) *lub* (lowest upper bound) of a range is calculated as the
greater of the low sensitivities and the lower of the high sensitivities.

**The statement definition is:**

```
default_range class [default range] | [glblub];
```

**Where:**

*default_range*

The *default_range* rule keyword.

*class*

One or more *class* identifiers. Multiple entries consist of a space
separated list enclosed in braces \'\{\}\'. Entries can be excluded from the
list by using the negative operator \'\-\'.

*default*

A single keyword consisting of either *source* or *target* that will state
whether the default level or range should be obtained from the source
or target context.

*range*

A single keyword consisting of either: *low*, *high* or *low_high* that will
state what part of the range should be used.

*glblub*

The *glblub* keyword used instead of *[default range]*.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

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
