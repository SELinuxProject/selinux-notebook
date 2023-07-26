The SELinux Notebook Maintainer Process
===============================================================================
https://github.com/SELinuxProject/selinux-notebook

This document attempts to describe the processes that should be followed by the
various SELinux Notebook maintainers.  It is not intended as a hard requirement,
but rather as a guiding document intended to make it easier for multiple
co-maintainers to manage the SELinux Notebook project.

We recognize this document, like all other parts of the Notebook project, is
not perfect.  If changes need to be made, they should be made following the
guidelines described here.

### Reviewing and Merging Patches

In a perfect world each patch would be independently reviewed and ACK'd by each
maintainer, but we recognize that is not likely to be practical for each patch.
Under normal circumstances, each patch should be reviewed by at least two
maintainers before being merged into the repository; reviewing includes both
an 'Acked-by:' tag as well as the 'Signed-off-by:' tag used by the maintainer
that merged the patch into the main repository.  Maintainers should ACK patches
using a format similar to the Linux Kernel, for example:

```
Acked-by: John Smith <john.smith@email.org>
```

The maintainer who merged the patch into the repository should add their
sign-off after ensuring that it is correct to do so (see the documentation on
submitting patches); if it is not correct for the maintainer to add their
sign-off, it is likely the patch should not be merged.  The maintainer should
add their sign-off using the standard format at the end of the patch's
metadata, for example:

```
Signed-off-by: Jane Smith <jane.smith@email.org>
```

The maintainers are encouraged to communicate with each other for many reasons,
one of which is to let the others when one is going to be unreachable for an
extended period of time.  If a patch is being held due to a lack of ACKs and
the other maintainers are not responding after a reasonable period of time (for
example, a delay of over two weeks), as long as there are no outstanding NACKs
the patch can be merged with only a single review.

### Managing the GitHub Issue Tracker

We use the GitHub issue tracker to track bugs, feature requests, and sometimes
unanswered questions.  The conventions here are intended to help distinguish
between the different uses, and prioritize within those categories.

Feature requests MUST have a "RFE:" prefix added to the issue name and use the
"enhancement" label.  Bug reports MUST a "BUG:" prefix added to the issue name
and use the "bug" label.

Issues CAN be additionally labeled with the "pending/info", "pending/review",
and "pending/revision" labels to indicate that additional information is
needed, the issue/patch is pending review, and/or the patch requires changes.

### Handling Inappropriate Community Behavior

The SELinux project community is relatively small, and almost always respectful
and considerate.  However, it is the responsibility of the maintainers to deal
with inappropriate behavior if it should occur.

As mentioned above, the maintainers are encouraged to communicate with each
other, and this communication is very important in this case.  When
inappropriate behavior is identified in the project (e.g. mailing list, GitHub,
etc.) the maintainers should talk with each other as well as the responsible
individual to try and correct the behavior.  If the individual continues to act
inappropriately the maintainers can block the individual from the project using
whatever means are available.  This should only be done as a last resort, and
with the agreement of all the maintainers.  In cases where a quick response is
necessary, a maintainer can unilaterally block an individual, but the block
should be reviewed by all the other maintainers soon afterwards.
