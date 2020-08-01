# Domain and Object Transitions

This section discusses the `type_transition` statement that is used to:

1.  Transition a process from one domain to another (a domain transition).
2.  Transition an object from one type to another (an object transition).

These transitions can also be achieved using the **libselinux** API
functions for SELinux-aware applications.


## Domain Transition

A domain transition is where a process in one domain starts a new
process in another domain under a different security context. There are
two ways a process can define a domain transition:

1.  Using a `type_transition` statement, where the ***exec**(2)* system call
    will automatically perform a domain transition for programs that are not
    themselves SELinux-aware. This is the most common method and would
    be in the form of the following statement:

```
type_transition unconfined_t secure_services_exec_t : process ext_gateway_t;
```

1.  SELinux-aware applications can specify the domain of the new process
    using the **libselinux** API call ***setexeccon**(3)*. To achieve
    this the SELinux-aware application must also have the setexec
    permission, for example:

```
allow crond_t self:process setexec;
```

However, before any domain transition can take place the policy must
specify that:

1.  The source *domain* has permission to *transition* into the target
    domain.
2.  The application binary file needs to be *executable* in the source
    domain.
3.  The application binary file needs an *entry point* into the target
    domain.

The following is a `type_transition` statement taken an example
loadable module message filter *ext_gateway.conf* that will be used to explain
the transition process:

```
type_transition | source_domain |      target_type     |  class | target_domain;
----------------▼---------------▼----------------------▼--------▼----------------
type_transition   unconfined_t   secure_services_exec_t:process   ext_gateway_t;
```

This `type_transition` statement states that when a *process* running in
the `unconfined_t` domain (the source domain) executes a file labeled
`secure_services_exec_t`, the *process* should be changed to
`ext_gateway_t` (the target domain) if allowed by the policy (i.e.
transition from the `unconfined_t` domain to the `ext_gateway_t` domain).

However as stated above, to be able to *transition* to the
`ext_gateway_t` domain, the following minimum permissions must be
granted in the policy using `allow` rules, where (note that the
bullet numbers correspond to the numbers shown in **Figure 7: Domain Transition**:

1.  The *domain* needs permission to *transition* into the
    `ext_gateway_t` (target) domain:

```
allow unconfined_t ext_gateway_t : process transition;
```

2.  The executable file needs to be *executable* in the `unconfined_t`
    (source) domain, and therefore also requires that the file is
    readable:

```
allow unconfined_t secure_services_exec_t : file { execute read getattr };
```

3.  The executable file needs an *entry point* into the
    `ext_gateway_t` (target) domain:

```
allow ext_gateway_t secure_services_exec_t : file entrypoint;
```

These are shown in **Figure 7: Domain Transition** where `unconfined_t` forks
a child process, that then exec's the new program into a new domain
called `ext_gateway_t`. Note that because the `type_transition` statement
is being used, the transition is automatically carried out by the
SELinux enabled kernel.

![](./images/7-domain-transition.png)

**Figure 7: Domain Transition** - *Where the secure_server is executed
within the `unconfined_t` domain and then transitioned to the `ext_gateway_t`
domain.*


### Type Enforcement Rules

When building the *ext_gateway.conf* and *int_gateway.conf* modules the
intention was to have both of these transition to their respective
domains via `type_transition` statements. The `ext_gateway_t` statement
would be:

```
type_transition unconfined_t secure_services_exec_t : process ext_gateway_t;
```

and the `int_gateway_t` statement would be:

```
type_transition unconfined_t secure_services_exec_t : process int_gateway_t;
```

However, when linking these two loadable modules into the policy, the
following error was given:

```
semodule -v -s modular-test -i int_gateway.pp -i ext_gateway.pp
Attempting to install module 'int_gateway.pp':
Ok: return value of 0.
Attempting to install module 'ext_gateway.pp':
Ok: return value of 0.
Committing changes:
libsepol.expand_terule_helper: conflicting TE rule for (unconfined_t,
secure_services_exec_t:process): old was ext_gateway_t, new is int_gateway_t
libsepol.expand_module: Error during expand
libsemanage.semanage_expand_sandbox: Expand module failed
semodule: Failed!
```

This happened because the type enforcement rules will only allow a
single 'default' type for a given source and target (see the
[**Type Statements**](type_statements.md#type-statements) section). In the
above case there were two `type_transition` statements with the same source
and target, but different default domains. The `ext_gateway.conf` module had
the following statements:

```
# Allow the client/server to transition for the gateways:

allow unconfined_t ext_gateway_t:process { transition };
allow unconfined_t secure_services_exec_t:file { read execute getattr };
allow ext_gateway_t secure_services_exec_t:file { entrypoint };
type_transition unconfined_t secure_services_exec_t:process ext_gateway_t;
```

And the *int_gateway.conf* module had the following statements:

```
# Allow the client/server to transition for the gateways:

allow unconfined_t int_gateway_t:process { transition };
allow unconfined_t secure_services_exec_t:file { read execute getattr };
allow int_gateway_t secure_services_exec_t:file { entrypoint };
type_transition unconfined_t secure_services_exec_t:process int_gateway_t;
```

While the allow rules are valid to enable the transitions to proceed,
the two `type_transition` statements had different 'default' types (or
target domains), that breaks the type enforcement rule.

It was decided to resolve this by:

1.  Keeping the `type_transition` rule for the 'default' type of
    `ext_gateway_t` and allow the secure server process to be exec'd
    from `unconfined_t` as shown in **Figure 7: Domain Transition**, by simply
    running the command from the prompt as follows:

```
# Run the external gateway 'secure server' application on port 9999 and
# let the policy transition the process to the ext_gateway_t domain:

secure_server 99999
```

1.  Use the SELinux ***runcon**(1)* command to ensure that the internal
    gateway runs in the correct domain by running runcon from the prompt
    as follows:

```
# Run the internal gateway 'secure server' application on port 1111 and
# use runcon to transition the process to the int_gateway_t domain:

runcon -t int_gateway_t -r message_filter_r secure_server 1111

# Note: The role is required as a role transition is defined in the policy.
```

The runcon command makes use of a number of **libselinux** API
functions to check the current context and set up the new context (for
example ***getfilecon**(3)* is used to get the executable files context
and ***setexeccon**(3)* is used to set the new process context). If all
contexts are correct, then the ***execvp**(2)* system call is executed
that exec's the secure_server application with the argument of '1111'
into the `int_gateway_t` domain with the `message_filter_r` role. The
runcon source can be found in the coreutils package.

Other ways to resolve this issue are:

1.  Use the runcon command for both gateways to transition to their
    respective domains. The `type_transition` statements are therefore
    not required.
2.  Use different names for the secure server executable files and
    ensure they have a different type (i.e. instead of
    `secure_service_exec_t` label the external gateway
    `ext_gateway_exec_t` and the internal gateway
    `int_gateway_exec_t`. This would involve making a copy of the
    application binary (which has already been done as part of the
    **module testing** by calling the server 'server' and labeling it
    `unconfined_t` and then making a copy called secure_server and
    labeling it `secure_services_exec_t`).
3.  Implement the policy using the Reference Policy utilising the
    template interface principles discussed in the
    [**template**](reference_policy.md#template-macro) section.

It was decided to use runcon as it demonstrates the command usage better
than reading the man pages.


## Object Transition

An object transition is where a new object requires a different label to
that of its parent. For example a file is being created that requires a
different label to that of its parent directory. This can be achieved
automatically using a `type_transition` statement as follows:

```
type_transition ext_gateway_t in_queue_t:file in_file_t;
```

The following details an object transition used in n example
*ext_gateway.conf* loadable module where by default, files would be labeled
`in_queue_t` when created by the gateway application as this is the label
attached to the parent directory as shown:

```
ls -Za /usr/message_queue/in_queue
drwxr-xr-x root root unconfined_u:object_r:in_queue_t .
drwxr-xr-x root root system_u:object_r:unconfined_t ..
```

However the requirement is that files in the `in_queue` directory must be
labeled `in_file_t`. To achieve this the files created must be relabeled
to `in_file_t` by using a `type_transition` rule as follows:

```
type_transition | source_domain |  target_type :    object
----------------▼---------------▼--------------▼-----------------
type_transition   ext_gateway_t    in_queue_t  : file in_file_t;
```

This `type_transition` statement states that when a *process* running in
the `ext_gateway_t` domain (the source domain) wants to create a
*file* object in the directory that is labeled `in_queue_t`, the file
should be relabeled `in_file_t` if allowed by the policy (i.e. label
the file `in_file_t`).

However as stated above to be able to create the file, the following
minimum permissions need to be granted in the policy using `allow`
rules, where:

1.  The source domain needs permission to *add file entries into the
    directory*:

```
allow ext_gateway_t in_queue_t : dir { write search add_name };
```

2.  The source domain needs permission to *create file entries*:

```
allow ext_gateway_t in_file_t : file { write create getattr };
```

3.  The policy can then ensure (via the SELinux kernel services) that
    files created in the `in_queue` are relabeled:

```
type_transition ext_gateway_t in_queue_t : file in_file_t;
```

An example output from a directory listing shows the resulting file
labels:

```
ls -Za /usr/message_queue/in_queue
drwxr-xr-x root root unconfined_u:object_r:in_queue_t .
drwxr-xr-x root root system_u:object_r:unconfined_t ..
-rw-r--r-- root root unconfined_u:object_r:in_file_t Message-1
-rw-r--r-- root root unconfined_u:object_r:in_file_t Message-2
```


<!-- %CUTHERE% -->

---
**[[ PREV ]](computing_access_decisions.md)** **[[ TOP ]](#)** **[[ NEXT ]](mls_mcs.md)**
