# Appendix E - Policy Validation Example

This example has been taken from
[**http://selinuxproject.org/page/PolicyValidate**](http://selinuxproject.org/page/PolicyValidate) just in case the site is removed some day.

***libsemanage(8)*** is the library responsible for building a kernel policy
from policy modules. It has many features but one that is rarely
mentioned is the policy validation hook. This example will show how to
make a basic validator and tell ***libsemanage*** to run it before
allowing any policy updates.

The sample validator uses ***sesearch**(1)* to search for a rule
between `user_t` and `shadow_t`. The purpose of this validator is
to never allow a policy update that allows `user_t` to access `shadow_t`.

To use the script below requires the **setools-console** package to be
installed.

Make a file in */usr/local/bin/validate* that contains the following (run
*chmod +x* or ***semodule**(8)* will fail):

```
#!/bin/bash

# Usage: validate <policy file>

# The following searches for a file rule with user_t as the source and
# shadow_t as the target.
# If the output of sesearch has "Found", meaning matching rules were found,
# then grep will return 0 otherwise it will return 1. This is actually the
# reverse of the logic we want, so we'll reverse it.

sesearch --allow -s user_t -t shadow_t -c file $1 | grep "Found" > /dev/null

if [ $? == 1 ]; then
        exit 0
fi

exit 1
```

Then add the validation script to */etc/selinux/semanage.conf*:

```
[verify kernel]
path = /usr/local/bin/validate
args = $@
[end]
```

Next try rebuilding the policy with no changes:

```
semodule -B
```

It should succeed, therefore build a module that would violate this rule:

```
module badmod 1.0;

require {
      type user_t, shadow_t;
      class file { read };
}

allow user_t shadow_t : file read;
```

Do the standard compilation steps:

```
checkmodule -o badmod.mod badmod.te -m -M

checkmodule:  loading policy configuration from badmod.te
checkmodule:  policy configuration loaded
checkmodule:  writing binary representation (version 17) to badmod.mod

semodule_package -m badmod.mod -o badmod.pp
```

And then attempt to insert it:

```
semodule -i badmod.pp
semodule: Failed!
```

Now run ***sesearch*** to ensure that there is no matching rule:

```
sesearch --allow -s user_t -t shadow_t -c file
```

Note that there are also a **\[verify module\]** and **\[verify linked\]**
options as described in the
[**Global Configuration Files** - *semanage.conf*](global_config_files.md#etcselinuxsemanage.conf)
file section.


<!-- %CUTHERE% -->

---
**[[ PREV ]](debug_policy_hints.md)** **[[ TOP ]](#)** 
