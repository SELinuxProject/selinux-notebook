# Security Context

SELinux requires a security context to be associated with every process
(or subject) and object that are used by the security server to decide
whether access is allowed or not as defined by the policy.

The security context is also known as a 'security label' or just label
that can cause confusion as there are many types of label depending on
the context.

Within SELinux, a security context is represented as variable-length
strings that define the SELinux user (this is not the Linux user id. The
Linux user id is mapped to the SELinux user id by configuration files),
their role, a type identifier and an optional MCS / MLS security range or
level as follows:

```
user:role:type[:range]
```

**Where:**

<table>
<tbody>
<tr>
<td><code>user</code></td>
<td>The SELinux user identity. This can be associated to one or more roles that the SELinux user is allowed to use.</td>
</tr>
<tr>
<td><code>role</code></td>
<td>The SELinux role. This can be associated to one or more types the SELinux user is allowed to access.</td>
</tr>
<tr>
<td><code>type</code></td>
<td><p>When a type is associated with a process, it defines what processes (or domains) the SELinux user (the subject) can access.</p>
<p>When a type is associated with an object, it defines what access permissions the SELinux user has to that object.</p></td>
</tr>
<tr>
<td><code>range</code></td>
<td><p>This field can also be know as a <em>level</em> and is only present if the policy supports MCS or MLS. The entry can consist of:
<p>A single security level that contains a sensitivity level and zero or more categories (e.g. s0, s1:c0, s7:c10.c15).</p>
<p>A range that consists of two security levels (a low and high) separated by a hyphen (e.g. s0 - s15:c0.c1023).</p>
<p>These components are discussed in the <a href="mls_mcs.md#security-levels">Security Levels</a> section.</p></td>
</tr>
</tbody>
</table>

However note that:

1.  Access decisions regarding a subject make use of all the components
    of the **security context**.
2.  Access decisions regarding an object make use of the components as
    follows:
    1.  the user is either set to a special user called system_u or it
        is set to the SELinux user id of the creating process. It is
        possible to add constraints on users within policy based on
        their object class (an example of this is the Reference Policy
        UBAC (User Based Access Control) option.
    2.  the role is generally set to a special SELinux internal role of
        'object_r`, although policy version 26 with kernel 2.6.39 and
        above do support role transitions on any object class. It is
        then possible to add constraints on the role within policy
        based on their object class.

The [**Computing Security Contexts**](computing_security_contexts.md#computing-security-contexts)
section decribes how SELinux computes the security context components based
on a `source context`, `target context` and object `class`.

The examples below show security contexts for processes, directories and files
(note that the policy did not support MCS or MLS, therefore no `level` field):

**Example Process Security Context:**

```
# These are process security contexts taken from a ps -Z command
# (edited for clarity) that show four processes:

LABEL                                       PID  TTY   CMD
unconfined_u:unconfined_r:unconfined_t      2539 pts/0 bash
unconfined_u:message_filter_r:ext_gateway_t 3134 pts/0 secure_server
unconfined_u:message_filter_r:int_gateway_t 3138 pts/0 secure_server
unconfined_u:unconfined_r:unconfined_t      3146 pts/0 ps

# Note the bash and ps processes are running under the
# unconfined_t domain, however the secure_server has two instances
# running under two different domains (ext_gateway_t and
# int_gateway_t). Also note that they are using the
# message_filter_r role whereas bash and ps use unconfined_r.
#
# These results were obtained by running the system in permissive mode.
```

**Example Object Security Context:**

```
# These are the message queue directory object security contexts
# taken from an ls -Zd command (edited for clarity):
system_u:object_r:in_queue_t /usr/message_queue/in_queue
system_u:object_r:out_queue_t /usr/message_queue/out_queue

# Note that they are instantiated with system_u and object_r
```

```
# These are the message queue file object security contexts
# taken from an ls -Z command (edited for clarity):
/usr/message_queue/in_queue:
unconfined_u:object_r:in_file_t Message-1
unconfined_u:object_r:in_file_t Message-2
/usr/message_queue/out_queue:
unconfined_u:object_r:out_file_t Message-10
unconfined_u:object_r:out_file_t Message-11

# Note that they are instantiated with unconfined_u as that was
# the SELinux user id of the process that created the files
# (see the process example above). The role remained as object_r.
```


<!-- %CUTHERE% -->

---
**[[ PREV ]](type_enforcement.md)** **[[ TOP ]](#)** **[[ NEXT ]](subjects.md)**
