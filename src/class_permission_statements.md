# Object Class and Permission Statements

- [*class* (1)](#class-1)
  - [Associating Permissions to a Class](#associating-permissions-to-a-class)
- [*common*](#common)
- [*class* (2)](#class-2)

For those who write or manager SELinux policy, there is no need to
define new objects and their associated permissions as these would be
done by those who actually design and/or write object managers.

A list of object classes used by the **Reference Policy** can be found
in the *./policy/flask/security\_classes* file.

There are two variants of the *class* statement for writing policy:

1. There is the *class* statement that declares the actual class
   identifier or name.
2. There is a further refinement of the *class* statement that
   associates permissions to the class as discussed in the
   [**Associating Permissions to a Class**](#associating-permissions-to-a-class)
   section.

## *class* (1)

Object classes are declared within a policy with the following statement
definition:

```
class class_id
```

**Where:**

*class*

The *class* keyword.

*class_id*

The *class* identifier.

**The statement is valid in:**

Policy Type

| Monolithic Policy       | Base Policy             | Module Policy           |
| ----------------------- | ----------------------- | ----------------------- |
| Yes                     | Yes                     | No                      |

Conditional Policy Statements

| *if* Statement          | *optional* Statement    | *require* Statement     |
| ----------------------- | ----------------------- | ----------------------- |
| No                      | No                      | Yes                     |

**Example:**

```
# Define the PostgreSQL db_tuple object class
#
class db_tuple
```

### Associating Permissions to a Class

Permissions can be defined within policy in two ways:

1. Define a set of common permissions that can then be inherited by one
   or more object classes using further *class* statements.
2. Define *class* specific permissions. This is where permissions are
   declared for a specific object class only (i.e. the permission is
   not inherited by any other object class).

A list of classes and their permissions used by the **Reference Policy**
can be found in the *./policy/flask/access_vectors* file.

## *common*

Declare a *common* identifier and associate one or more *common* permissions.

The statement definition is:

```
common common_id { perm_set }
```

**Where:**

*common*

The *common* keyword.

*common_id*

The *common* identifier.

*perm_set*

One or more permission identifiers in a space separated list enclosed within
braces \'\{\}\'.

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
# Define the common PostgreSQL permissions

common database { create drop getattr setattr relabelfrom relabelto }
```

## *class* (2)

Inherit and / or associate permissions to a perviously declared *class*
identifier.

**The statement definition is:**

```
class class_id [ inherits common_set ] [ { perm_set } ]
```

**Where:**

*class*

The *class* keyword.

*class_id*

The previously declared *class* identifier.

*inherits*

The optional *inherits* keyword that allows a set of common permissions to be
inherited.

*common_set*

A previously declared *common* identifier.

*perm_set*

One or more optional permission identifiers in a space separated list enclosed
within braces \'\{\}\'.</td>

Note: There must be at least one *common_set* or one *perm_set* defined within
the statement.

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
# The following example shows the db_tuple object class being
# allocated two permissions:

class db_tuple { relabelfrom relabelto }
```

```
# The following example shows the db_blob object class inheriting
# permissions from the database set of common permissions (as described
# in the Associating Permissions to a Class section):

class db_blob inherits database
```

```
# The following example (from the access_vector file) shows the
# db_blob object class inheriting permissions from the database
# set of common permissions and adding a further four permissions:

class db_blob inherits database { read write import export }
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](xperm_rules.md)** **[[ TOP ]](#)** **[[ NEXT ]](conditional_statements.md)**
