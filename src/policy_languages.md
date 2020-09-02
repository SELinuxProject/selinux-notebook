# The SELinux Policy Languages

There are two methods of writing 'raw' policy statements and rules:

1. The [**Kernel Policy Language**](kernel_policy_language.md#kernel-policy-language)
   section is intended as a reference of the kernel policy language statements
   and rules with supporting examples taken from the Reference Policy sources.
   Also all of the language updates to Policy DB version 32 should have been
   captured. For a more detailed explanation of the policy language the
   [**SELinux by Example**](https://www.worldcat.org/title/selinux-by-example-using-security-enhanced-linux/oclc/85872880)
   book is recommended.
2. The Common Intermediate Language (CIL) project defines a new policy
   definition language that has an overview of its motivation and design
   at: <https://github.com/SELinuxProject/cil/wiki>, however some of the
   language statement definitions are out of date. The
   [**CIL Policy Language**](cil_overview.md#cil-overview) section gives
   an overview.

However more likely, policy is written using the
[**The Reference Policy**](reference_policy.md#the-reference-policy)
as the base with kernel policy statements and rules added as required, for
example:

```
#################################
#
# Policy for testing stat operations
#

attribute test_stat_domain;                   ### Kernel policy statement ###

# Types for test file.
type test_stat_file_t;                        ### Kernel policy statement ###
files_type(test_stat_file_t)                  ### Reference Policy macro  ###

# Domain for process that can get attributes on the test file.
type test_stat_t;
domain_type(test_stat_t)
unconfined_runs_test(test_stat_t)
typeattribute test_stat_t test_stat_domain;
typeattribute test_stat_t testdomain;
allow test_stat_t test_stat_file_t:file getattr;   ### Kernel policy rule ###

# Domain for process that cannot set attributes on the test file.
type test_nostat_t;
domain_type(test_nostat_t)
unconfined_runs_test(test_nostat_t)
typeattribute test_nostat_t test_stat_domain;
typeattribute test_nostat_t testdomain;

# TODO: what is a replacement for this in refpolicy???
# Allow all of these domains to be entered from sysadm domain
require {                                         ### Modular Policy rule ###
	type ls_exec_t;
}
domain_transition_pattern(sysadm_t, ls_exec_t, test_stat_domain)
domain_entry_file(test_stat_domain, ls_exec_t)
```

<!-- %CUTHERE% -->

---
**[[ PREV ]](policy_config_files.md)** **[[ TOP ]](#)** **[[ NEXT ]](cil_overview.md)**
