# Constraint Statements

- [*constrain*](#constrain)
- [*validatetrans*](#validatetrans)
- [*mlsconstrain*](#mlsconstrain)
- [*mlsvalidatetrans*](#mlsvalidatetrans)

## *constrain*

The *constrain* statement allows further restriction on permissions for
the specified object classes by using boolean expressions covering:
source and target types, roles and users as described in the examples.

**The statement definition is:**

```
constrain class perm_set expression | expr ...;
```

**Where:**

*constrain*

The *constrain* keyword.

*class*

One or more object classes. Multiple entries consist of a space separated list
enclosed in braces \'\{\}\'.

*perm_set*

One or more permissions. Multiple entries consist of a space separated list
enclosed in braces \'\{\}\'.

*expression*

There must be one constraint *expression* or one or more *expr*'s. An
*expression* consists of '*operand operator operand*' as follows:

- *( u1 op u2 )*
- *( r1 role_op r2 )*
- *( t1 op t2 )*
- *( u1 op names )*
- *( u2 op names )*
- *( r1 op names )*
- *( r2 op names )*
- *( t1 op names )*
- *( t2 op names )*
- Where:
  - *u1*, *r1*, *t1* = Source *user*, *role*, *type*
  - *u2*, *r2*, *t2* = Target *user*, *role*, *type*
- And:
  - *op : == | !=*
  - *role_op : == | != | eq | dom | domby | incomp*
  - *names : name | { name_list }*
  - *name_list : name | name_list name*

*expr*

Zero or more *expr*'s, the valid operators and syntax are:

- *( not expression )*
- *( expression and expression )*
- *( expression or expression )*

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

These examples have been taken from the **Reference Policy** source
*./policy/constraints* file.

```
# This constrain statement is the "SELinux process identity
# change constraint" taken from the Reference Policy source and
# contains multiple expressions.
#
# The overall constraint is on the process object class with the
# transition permission, and is stating that a domain transition
# is being constrained by the rules listed (u1 == u2 etc.),
# however only the first two expressions are explained.
#
# The first expression u1 == u2 states that the source (u1) and
# target (u2) user identifiers must be equal for a process
# transition to be allowed.
#
# However note that there are a number of or operators that can
# override this first constraint.
#
# The second expression:
#    ( t1 == can_change_process_identity and t2 == process_user_target )
# states that if the source type (t1) is equal to any type
# associated to the can_change_process_identity attribute, and
# the target type (t2) is equal to any type associated to the
# process_user_target attribute, then a process transition is allowed.
# What this expression means in the 'standard' build Reference
# Policy is that if the source domain is either cron_t,
# firstboot_t, local_login_t, su_login_t, sshd_t or xdm_t (as
# the can_change_process_identity attribute has these types
# associated to it) and the target domain is sysadm_t (as that
# is the only type associated to the can_change_process_identity
# attribute), then a domain transition is allowed.
#
# SELinux process identity change constraint:
constrain process transition (
	u1 == u2
	or
	( t1 == can_change_process_identity and t2 == process_user_target )
	or
	( t1 == cron_source_domain and ( t2 == cron_job_domain or u2 == system_u ))
	or
	( t1 == can_system_change and u2 == system_u )
	or
	( t1 == process_uncond_exempt ) );
```

```
# This constrain statement is the "SELinux file related object
# identity change constraint" taken from the Reference Policy
# source and contains two expressions.
#
# The overall constraint is on the listed file related object
# classes (dir, file etc.), covering the create, relabelto, and
# relabelfrom permissions. It is stating that when any of the
# object class listed are being created or relabeled, then they
# are subject to the constraint rules listed (u1 == u2 etc.).
#
# The first expression u1 == u2 states that the source (u1) and
# target (u2) user identifiers (within the security context)
# must be equal when creating or relabeling any of the file
# related objects listed.
#
# The second expression:
#    or t1 == can_change_object_identity
#
# states or if the source type (t1) is equal to any type
# associated to the can_change_object_identity attribute, then
# any of the object class listed can be created or relabeled.
#
# What this expression means in the 'standard' build
# Reference Policy is that if the source domain (t1) matches a
# type entry in the can_change_object_identity attribute, then
# any of the object class listed can be created or relabeled.
#
# SELinux file related object identity change constraint:

constrain { dir file lnk_file sock_file fifo_file chr_file blk_file } { create relabelto relabelfrom }
	(u1 == u2 or t1 == can_change_object_identity);
```

## *validatetrans*

The *validatetrans* statement is used to control the ability to change the
objects security context.

The first context *u1:r1:t1* is the context before the transition, the
second context *u2:r2:t2* is the context after the transition, and the
third *u3:r3:t3* is the context of the process performing the transition.

Note there are no *validatetrans* statements specified within the
**Reference Policy** source.

**The statement definition is:**

```
validatetrans class  expression | expr ...;
```

**Where:**

*validatetrans*

The *validatetrans* keyword.

*class*

One or more object classes. Multiple entries consist of a space separated list
enclosed in braces \'\{\}\'.

*expression*

There must be one constraint *expression* or one or more *expr*'s. An
*expression* consists of '*operand operator operand*' as follows:

- *( u1 op u2 )*
- *( r1 role_op r2 )*
- *( t1 op t2 )*
- *( u1 op names )*
- *( u2 op names )*
- *( u3 op names )*
- *( r1 op names )*
- *( r2 op names )*
- *( r3 op names )*
- *( t1 op names )*
- *( t2 op names )*
- *( t3 op names )*
- Where:
  - *u1*, *r1*, *t1* = Source *user*, *role*, *type*
  - *u2*, *r2*, *t2* = Target *user*, *role*, *type*
  - *u3*, *r3*, *t3* = Process *user*, *role*, *type*
- And:
  - *op : == | !=*
  - *role_op : == | != | eq | dom | domby | incomp*
  - *names : name | { name_list }*
  - *name_list : name | name_list name*

*expr*

Zero or more *expr*'s, the valid operators and syntax are:

- *( not expression )*
- *( expression and expression )*
- *( expression or expression )*

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
validatetrans { file } ( t1 == unconfined_t );
```

## *mlsconstrain*

The *mlsconstrain* statement allows further restriction on permissions for
the specified object classes by using boolean expressions covering:
source and target types, roles, users and security levels as described
in the examples.

**The statement definition is:**

```
mlsconstrain class perm_set expression | expr ...;
```

**Where:**

*mlsconstrain*

The *mlsconstrain* keyword.

*class*

One or more object classes. Multiple entries consist of a space separated
list enclosed in braces \'\{\}\'.

*perm_set*

One or more permissions. Multiple entries consist of a space separated
list enclosed in braces \'\{\}\'.

*expression*

There must be one constraint *expression* or one or more *expr*'s. An
*expression* consists of '*operand operator operand*' as follows:

- *( u1 op u2 )*
- *( r1 role_mls_op r2 )*
- *( t1 op t2 )*
- *( l1 role_mls_op l2 )*
- *( l1 role_mls_op h2 )*
- *( h1 role_mls_op l2 )*
- *( h1 role_mls_op h2 )*
- *( l1 role_mls_op h1 )*
- *( l2 role_mls_op h2 )*
- *( u1 op names )*
- *( u2 op names )*
- *( r1 op names )*
- *( r2 op names )*
- *( t1 op names )*
- *( t2 op names )*
- Where:
  - *u1*, *r1*, *t1*, *l1*, *h1* = Source *user*, *role*, *type*, *low*, *high*
  - *u2*, *r2*, *t2*, *l2*, *h2* = Target *user*, *role*, *type*, *low*, *high*
- And:
  - *op : == | !=*
  - *role_mls_op : == | != | eq | dom | domby | incomp*
  - *names : name | { name_list }*
  - *name_list : name | name_list name*

*expr*

Zero or more *expr*'s, the valid operators and syntax are:

- *( not expression )*
- *( expression and expression )*
- *( expression or expression )*

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

This example has been taken from the **Reference Policy** source
*./policy/mls* constraints file. These are built into the policy at build
time and add constraints to many of the object classes.

```
# The MLS Reference Policy mlsconstrain statement for searching
# directories that comprises of multiple expressions. Only the
# first two expressions are explained.
#
# Expression 1 ( l1 dom l2 ) reads as follows:
#   The dir object class search permission is allowed if the source low
#   security level is dominated by the targets low security level.
# OR
# Expression 2 (( t1 == mlsfilereadtoclr ) and ( h1 dom l2 ))
# reads as follows:
#   If the source type is equal to a type associated to the
#   mlsfilereadtoclr attribute and the source high security
#   level is dominated by the targets low security level,
#   then search permission is allowed on the dir object class.

mlsconstrain dir search
	(( l1 dom l2 ) or
	(( t1 == mlsfilereadtoclr ) and ( h1 dom l2 )) or
	( t1 == mlsfileread ) or
	( t2 == mlstrustedobject ));
```

## *mlsvalidatetrans*

The *mlsvalidatetrans* is the MLS equivalent of the *validatetrans*
statement where it is used to control the ability to change the objects
security context.

The first context *u1:r1:t1:l1-h1* is the context before the transition, the
second context *u2:r2:t2:l2-h2* is the context after the transition, and the
third *u3:r3:t3:*\[*range*\] is the context of the process performing the
transition.

**The statement definition is:**

```
mlsvalidatetrans class expression | expr ...;
```

**Where:**

*mlsvalidatetrans*

The *mlsvalidatetrans* keyword.

*class*

One or more object classes. Multiple entries consist of a space separated list
enclosed in braces \'\{\}\'.

*expression*

There must be one constraint *expression* or one or more *expr*'s. An
*expression* consists of '*operand operator operand*' as follows:

- *( u1 op u2 )*
- *( r1 role_mls_op r2 )*
- *( t1 op t2 )*
- *( l1 role_mls_op l2 )*
- *( l1 role_mls_op h2 )*
- *( h1 role_mls_op l2 )*
- *( h1 role_mls_op h2 )*
- *( l1 role_mls_op h1 )*
- *( l2 role_mls_op h2 )*
- *( u1 op names )*
- *( u2 op names )*
- *( u3 op names )*
- *( r1 op names )*
- *( r2 op names )*
- *( r3 op names )*
- *( t1 op names )*
- *( t2 op names )*
- *( t3 op names )*
- Where:
  - *u1*, *r1*, *t1*, *l1*, *h1* = Source *user*, *role*, *type*, *low*, *high*
  - *u2*, *r2*, *t2*, *l2*, *h2* = Target *user*, *role*, *type*, *low*, *high*
  - *u3*, *r3*, *t3*, \[*range*\] = Process *user*, *role*, *type*, \[*range*\]
- And:
  - *op : == | !=*
  - *role_mls_op : == | != | eq | dom | domby | incomp*
  - *names : name | { name_list }*
  - *name_list : name | name_list name*

*expr*

Zero or more *expr*'s, the valid operators and syntax are:

- *( not expression )*
- *( expression and expression )*
- *( expression or expression )*

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

This example has been taken from the **Reference Policy** source
*./policy/mls* file.

```
# The MLS Reference Policy mlsvalidatetrans statement for
# managing the file upgrade/downgrade rules that comprises of
# multiple expressions. Only the first two expressions are explained.
#
# Expression 1: ( l1 eq l2 ) reads as follows:
#   For a file related object to change security context, its
#   current (old) low security level must be equal to the new
#   objects low security level.
#
# The second part of the expression:
#   or (( t3 == mlsfileupgrade ) and ( l1 domby l2 )) reads as follows:
#     or the process type must equal a type associated to the
#     mlsfileupgrade attribute and its current (old) low security
#     level must be dominated by the new objects low security level.
#
mlsvalidatetrans { dir file lnk_file chr_file blk_file sock_file fifo_file }
	((( l1 eq l2 ) or
	(( t3 == mlsfileupgrade ) and ( l1 domby l2 )) or
	(( t3 == mlsfiledowngrade ) and ( l1 dom l2 )) or
	(( t3 == mlsfiledowngrade ) and ( l1 incomp l2 ))) and (( h1 eq h2 ) or
	(( t3 == mlsfileupgrade ) and ( h1 domby h2 )) or
	(( t3 == mlsfiledowngrade ) and ( h1 dom h2 )) or
	(( t3 == mlsfiledowngrade ) and ( h1 incomp h2 ))));
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](conditional_statements.md)** **[[ TOP ]](#)** **[[ NEXT ]](mls_statements.md)**
