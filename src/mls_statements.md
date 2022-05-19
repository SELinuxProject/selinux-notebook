# MLS Statements

- [MLS range Definition](#mls-range-definition)
- [*sensitivity*](#sensitivity)
- [*dominance*](#dominance)
- [*category*](#category)
- [*level*](#level)
- [*range_transition*](#range_transition)
- [*mlsconstrain*](#mlsconstrain)
- [*mlsvalidatetrans*](#mlsvalidatetrans)

The optional MLS policy extension adds an additional security context
component that consists of the following highlighted entries:

*user:role:type:* ***sensitivity[:category,...] - sensitivity [:category,...]***

These consist of a mandatory hierarchical [**sensitivity**](#sensitivity) and
optional non-hierarchical [**category**](#category)'s. The combination of the
two comprise a [**level**](#level) or security level. Depending on the
circumstances, there can be one level or a [**range**](#mls-range-definition).

To make the security levels more meaningful, it is possible to use the
***mcstransd**(8)* daemon to translate these to human readable formats. The
***semanage**(8)* command will allow this mapping to be defined as discussed
in the [**setrans.conf**](policy_config_files.md#setrans.conf) section.

## MLS range Definition

The MLS range is appended to a number of statements and defines the lowest and
highest security levels. The range can also consist of a single level as
discussed at the start of the [**MLS section**](#mls-statements).

**The definition is:**

```
low_level [ - high_level ]
```

**Where:**

*low_level*

The processes lowest level identifier that has been previously declared by a
[*level*](#level) statement. If a *high_level* is not defined, then it is taken
as the same as the *low_level*.

*\-*

The optional hyphen '-' separator if a *high_level* is also being defined.

*high_level*

The processes highest level identifier that has been previously declared by
a [*level*](#level) statement.

## *sensitivity*

The sensitivity statement defines the MLS policy sensitivity identifies
and optional alias identifiers.

**The statement definition is:**

```
sensitivity sens_id [alias sensitivityalias_id ...];
```

**Where:**

*sensitivity*

The *sensitivity* keyword.

*sens_id*

The *sensitivity* identifier.

*alias*

The optional *alias* keyword.

*sensitivityalias_id*

One or more sensitivity alias identifiers in a space separated list.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | Yes                     |

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

## *dominance*

When more than one [*sensitivity*](#sensitivity)
statemement is defined within a policy, then a *dominance* statement is
required to define the actual hierarchy between all sensitivities.

**The statement definition is:**

```
dominance { sensitivity_id ... }
```

**Where:**

*dominance*

The *dominance* keyword.

*sensitivity_id*

A space separated list of previously declared *sensitivity* or
*sensitivityalias* identifiers in the order lowest to highest. They are
enclosed in braces '{}', and note that there is no terminating semi-colon ';'.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Example:**

```
# The MLS Reference Policy dominance statement defines s0 as the
# lowest and s15 as the highest sensitivity level:

dominance { s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 }
```

## *category*

The *category* statement defines the MLS policy category
identifiers and optional alias identifiers.

**The statement definition is:**

```
category category_id [alias categoryalias_id ...];
```

**Where:**

*category*

The *category* keyword.

*category_id*

The *category* identifier.

*alias*

The optional *alias* keyword.

*categoryalias_id*

One or more *alias* identifiers in a space separated list.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | Yes                     |

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

## *level*

The *level* statement enables the previously declared sensitivity and
category identifiers to be combined into a Security Level.

Note there must only be one *level* statement for each
[*sensitivity*](#sensitivity) statemement.

**The statement definition is:**

```
level sensitivity_id [ :category_id ];
```

**Where:**

*level*

The *level* keyword.

*sensitivity_id*

A previously declared *sensitivity* or *sensitivityalias* identifier.

*category_id*

An optional set of zero or more previously declared *category* or
*categoryalias* identifiers that are preceded by a colon ':', that can be
written as follows:

- The period '.' separating two *category* identifiers means an inclusive
  set (e.g. *c0.c16*).
- The comma ',' separating two *category* identifiers means a non-contiguous
  list (e.g. *c21,c36,c45*).

Both separators may be used (e.g. *c0.c16,c21,c36,c45*).

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | No                      |

**Example:**

```
# The MLS Reference Policy default is to assign each Security Level with
# the complete set of categories (i.e. the inclusive set from c0 to c255):

level s0:c0.c255;
...
level s15:c0.c255;
```

## *range_transition*

The *range_transition* statement is primarily used by the init process or
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

*range_transition*

The *range_transition* keyword.

*source_type*, *target_type*

One or more source / target *type* or *attribute* identifiers. Multiple entries
consist of a space separated list enclosed in braces'{}'.
Entries can be excluded from the list by using the negative operator '-'.

*class*

The optional object *class* keyword (this allows policy versions 21 and greater
to specify a class other than the default of *process*).

*new_range*

The new MLS range for the object class. The format of this field is described
in the [MLS range Definition](#mls-range-definition) section.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | Yes                     |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | Yes                     | No                      |

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

## *mlsconstrain*

This is described in the
[**Constraint Statements - *mlsconstrain***](constraint_statements.md#mlsconstrain)
section.

## *mlsvalidatetrans*

This is described in the
[**Constraint Statements - *mlsvalidatetrans***](constraint_statements.md#mlsvalidatetrans)
section.

<!-- %CUTHERE% -->

---
**[[ PREV ]](constraint_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](sid_statement.md)**
