# Type Enforcement

SELinux makes use of a specific style of type enforcement (TE) to enforce
mandatory access control. For SELinux it means that all
[**subjects**](subjects.md#subjects) and [**objects**](objects.md#objects)
have a `type` identifier associated to them that can then be used to enforce
rules laid down by policy.

The SELinux `type` identifier is a simple variable-length string that is
defined in the policy and then associated to a
[**security context**](security_context.md#security-context).
It is also used in the majority of
[**SELinux language statements and rules**](policy_languages.md#the-selinux-policy-languages)
used to build a policy that will, when loaded into the security
server, enforce policy via the object managers.

Because the `type` identifier (or just 'type') is associated to all
subjects and objects, it can sometimes be difficult to distinguish what
the type is actually associated with (it's not helped by the fact that
by convention, type identifiers end in `_t`). In the end it comes down
to understanding how they are allocated in the policy itself and how
they are used by SELinux services (although CIL policies with namespaces
do help in that a domain process 'type' could be declared as
`msg_filter.ext_gateway.process` with object types being any others
(such as `msg_filter.ext_gateway.exec`).

Basically if the type identifier is used to reference a subject it is
referring to a Linux process or collection of processes (a domain or
domain type). If the type identifier is used to reference an object then
it is specifying its object type (i.e. file type).

While SELinux refers to a subject as being an active process that is
associated to a domain type, the scope of an SELinux type enforcement
domain can vary widely. For example in the simple
[**Kernel policy**](./notebook-examples/selinux-policy/kernel/kern-nb-policy.txt)
in the notebook-examples, all the processes on the system run in the
`unconfined_t` domain, therefore every process is
'of type `unconfined_t`' (that means it can do whatever it likes within
the limits of the standard Linux DAC policy as all access is allowed by
SELinux).

It is only when additional policy statements are added to the simple
policy that areas start to be confined. For example, an external gateway
is run in its own isolated domain (`ext_gateway_t`) that cannot be
'interfered' with by any of the `unconfined_t` processes (except to run
or transition the gateway process into its own domain). This scenario is
similar to the 'targeted' policy delivered as standard in Red Hat Fedora
where the majority of user space processes run under the `unconfined_t`
domain.

The SELinux type is the third component of a 'security context' and by
convention SELinux types end in `_t`, however this is not enforced by
any SELinux service (i.e. it is only used to identify the type
component), although as explained above CIL with namespaces does make
identification of types easier.

<br>

### Constraints

It is possible to add constraints on users, roles, types and MLS ranges,
for example within a TE environment, the way that subjects are allowed
to access an object is via a TE [**`allow`**](avc_rules.md#allow), for example:

`allow unconfined_t ext_gateway_t : process transition;`

This states that a process running in the `unconfined_t` domain has
permission to transition a process to the `ext_gateway_t` domain.
However it could be that the policy writer wants to constrain this
further and state that this can only happen if the role of the source
domain is the same as the role of the target domain. To achieve this a
constraint can be imposed using a
[**`constrain`**](constraint_statements.md#constrain) statement:

`constrain process transition ( r1 == r2 );`

This states that a process transition can only occur if the source role
is the same as the target role, therefore a constraint is a condition
that must be satisfied in order for one or more permissions to be
granted (i.e. a constraint imposes additional restrictions on TE rules).
Note that the constraint is based on an object class (`process` in this
case) and one or more of its permissions.

The kernel policy language constraints are defined in the
[**Constraint Statements**](constraint_statements.md#constraint-statements)
section.

<br>

### Bounds

It is possible to add bounds to users, roles and types, however
currently only types are enforced by the kernel using the `typebounds`
rule as described in the
[**Apache-Plus Support - Bounds Overview**](apache_support.md#bounds-overview)
section.

User and role bounds may be declared using CIL, however they are validated at
compile time by the CIL compiler and NOT enforced by the SELinux kernel
services. The [**Bounds Rules**](bounds_rules.md#bounds-rules)
section defines the `typebounds` rule and also gives a summary of the
`userbounds` and `rolebounds` rules.


<br>

<!-- %CUTHERE% -->

---
**[[ PREV ]](rbac.md)** **[[ TOP ]](#)** **[[ NEXT ]](security_context.md)**
