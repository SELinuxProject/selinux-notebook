# Sample Kernel Policy

This section will build/install sample kernel policy files:

1) Build a non MLS policy: `make build_policy`
2) Install the non MLS policy in /etc/selinux/nb-kernel: `make install_policy`
3) Build an MLS policy: `make build_mls_policy`
4) Install the MLS policy in /etc/selinux/nb-mls-kernel: `make install_mls_policy`


To run these policy:
    edit the */etc/selinux/config* file entries:
        SELINUXTYPE=<policy_name>
        SELINUX=permissive.

   touch /.autorelabel
   reboot the system

The *Makefile* and *tools/build-sepolicy* build script should be
read to find out how the policy is built and installed.
