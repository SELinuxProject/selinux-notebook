# Android Policy

The Android policies defined in these *Makefile* files will allow them to be
built for inspection without obtaining the full AOSP source and build
environment.

Note that the core policy is built in most cases as within Android each
device adds their specific policy modules.

The build process will produce two files:

- *policy.conf* that can be examined with a text editor.
- *sepolicy* that can be viewed using tools such as ***apol**(1)*.

The ***git**(1)* commands required to obtain the policies are defined in
each *Makefile*.

- *android-4/Makefile*
  - The initial Android basic policy.

- *brillo/Makefile*
  - The Brillo release was their first IoT release.

- *android-10/Makefile*
  - The Android 10 release split the policy into private and public segments
    and has started using some CIL modules (although for simplicity they are
    not built).

## Build policy with a Device

The *brillo-device/Makefile* has instructions to build the Brillo policy with
a suitable device using the
*https://android.googlesource.com/platform/external/sepolicy/+archive/refs/heads/brillo-m7-release.tar.gz*
device policy file.
