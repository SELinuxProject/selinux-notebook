# Tiny CIL policy that is mutable at runtime

The purpose of this tiny SELinux policy is to demonstrate what is
least required to get started, and it can be used as a base for your
own security policy or just to experiment with. The policy is written
in Common Intermediate Language and is installed with semodule to
provide easy access to all aspects at runtime.

A single security context is provided that is associated with
everything in memory only and to really get started you are expected
to make an inventory of your filesystems and to enable labeling
support for your filesystems accordingly before you proceed.

Only eight security classes and two access vector permissions are
declared. AVC allow rules for these two access vector permissions are
associated with the single security context to give full access.
Unknown access vectors are allowed to enable you to pick and choose
which access vectors to leverage. You can get a list of unknown Linux
security classes and access vector permissions from `dmesg`, and any
user space object managers are likely to report unknown access vectors
using either "USER_AVC" or "USER_SELINUX_ERR" type audit records. You
are expected to declare any access vectors you require and then to
associate them accordingly with access vector rules to allow access.

The type-enforcement (TE), as well as identity-based (IBAC) and
role-based (RBAC) access control security models are enabled. Optional
security models such as multi-level security can be added with
relative easy.

Common Intermediate Language is a modern source based policy language
that together with a module store that can be accessed with `semodule`
at runtime provides optimal flexibility in your interactions with
SELinux. It is recommended that you use the `setools` policy analysis
suite to its full potential to get any information about the state of
your policy.

The cil-policy addresses some of the intricacies involved with getting
started without making assumptions about your environment and
requirements. You are enouraged to leverage CIL to its full potential
and to keep its documentation handy.

## Getting started

```
make install
cat > /etc/selinux/config <<EOF
SELINUX=enforcing
SELINUXTYPE=cil-policy
EOF
```

If you are switching to cil-policy from another policy then a system
reboot is not strictly required:

```
semodule -B
```

Your first step to actually leverage cil-policy will likely be to
enable labeling support for at least your non-volatile filesystems
and to apply labels according to the file context specifications
defined in the policy.

For example if you use `ext4` filesystems:

```
echo '(fsuse xattr "ext4" (sys.id sys.role sys.isid ((s0)(s0))))' > myfs.cil
semodule -i myfs.cil
fixfiles -F onboot && reboot
```

To modify the existing cil-policy:

```
semodule -E cil-policy
emacs cil-policy.cil
semodule -X 101 -i cil-policy.cil
```

Use your favorite text editor to write policy in [Common Intermediate Language](https://github.com/SELinuxProject/selinux/blob/master/secilc/docs/README.md),
manage it with `semodule`, and analyze it with `setools`.

## Important

If you are using Xserver or Xwayland then the following is required:

```
echo "(boolean xserver_object_manager false)" > disablexace.cil
semodule -i disablexace.cil
```
