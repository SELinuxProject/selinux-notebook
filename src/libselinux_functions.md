# Appendix B - *libselinux* API Summary

These functions have been taken from the following header files of
*libselinux* version 3.0:

- */usr/include/selinux/avc.h*
- */usr/include/selinux/context.h*
- */usr/include/selinux/get_context_list.h*
- */usr/include/selinux/get_default_type.h*
- */usr/include/selinux/label.h*
- */usr/include/selinux/restorecon.h*
- */usr/include/selinux/selinux.h*

The appropriate ***man**(3)* pages should consulted for detailed usage.

Some useful notes:

1. Use ***free**(3)* instead of ***freecon**(3)* for context strings as they
   are now defined as *char\**. Note this does not apply to ***context_free**(3)*.
2. There must be more ???

*avc_add_callback* - *avc.h*

Register a callback for security events.

*avc_audit* - *avc.h*

Audit the granting or denial of permissions in accordance with the policy.
This function is typically called by ***avc_has_perm**(3)* after a permission
check, but can also be called directly by callers who use
***avc_has_perm_noaudit**(3)* in order to separate the permission check from
the auditing. For example, this separation is useful when the permission
check must be performed under a lock, to allow the lock to be released before
calling the auditing code.

*avc_av_stats* - *avc.h*

Log AV table statistics. Logs a message with information about the size and
distribution of the access vector table. The audit callback is used to print
the message.

*avc_cache_stats* - *avc.h*

Get cache access statistics. Fill the supplied structure with information
about AVC activity since the last call to ***avc_init**(3)*
or ***avc_reset**(3)*.

*avc_cleanup* - *avc.h*

Remove unused SIDs and AVC entries. Search the SID table for SID structures
with zero reference counts, and remove them along with all AVC entries that
reference them. This can be used to return memory to the system.

*avc_compute_create* - *avc.h*

Compute SID for labeling a new object. Call the security server to obtain
a context for labeling a new object. Look up the context in the SID table,
making a new entry if not found.

*avc_compute_member* - *avc.h*

Compute SID for polyinstantation. Call the security server to obtain a
context for labeling an object instance. Look up the context in the SID table,
making a new entry if not found.

*avc_context_to_sid*, *avc_context_to_sid_raw* - *avc.h*

Get SID for context. Look up security context *ctx* in SID table, making a new
entry if *ctx* is not found. Store a pointer to the SID structure into the
memory referenced by *sid*, returning 0 on success or -1 on error with
*errno* set.

*avc_destroy* - *avc.h*

Free all AVC structures. Destroy all AVC structures and free all allocated
memory. User-supplied locking, memory, and audit callbacks will be retained,
but security-event callbacks will not. All SID's will be invalidated.
User must call ***avc_init**(3)* if further use of AVC is desired.

*avc_entry_ref_init* - *avc.h*

Initialize an AVC entry reference. Use this macro to initialize an *avc* entry
reference structure before first use. These structures are passed to
***avc_has_perm**(3)*, which stores cache entry references in them.
They can increase performance on repeated queries.

*avc_get_initial_sid* - *avc.h*

Get SID for an initial kernel security identifier. Get the context for an
initial kernel security identifier specified by name using
***security_get_initial_context**(3)* and then call
***avc_context_to_sid**(3)* to get the corresponding SID.

*avc_has_perm* - *avc.h*

Check permissions and perform any appropriate auditing. Check the AVC to
determine whether the requested permissions are granted for the SID pair
(*ssid*, *tsid*), interpreting the permissions based on tclass, and call the
security server on a cache miss to obtain a new decision and add it to the
cache. Update *aeref* to refer to an AVC entry with the resulting decisions.
Audit the granting or denial of permissions in accordance with the policy.
Return 0 if all requested permissions are granted, -1 with errno set to EACCES
if any permissions are denied or to another value upon other errors.

*avc_has_perm_noaudit* - *avc.h*

Check permissions but perform no auditing. Check the AVC to determine whether
the requested permissions are granted for the SID pair (*ssid*, *tsid*),
interpreting the permissions based on tclass, and call the security server
on a cache miss to obtain a new decision and add it to the cache. Update aeref
to refer to an AVC entry with the resulting decisions, and return a copy of
the decisions in *avd*. Return 0 if all requested permissions are granted, -1
with errno set to EACCES if any permissions are denied, or to another value
upon other errors. This function is typically called by ***avc_has_perm**(3)*,
but may also be called directly to separate permission checking from auditing,
e.g. in cases where a lock must be held for the check but should be released
for the auditing.

*avc_init* (deprecated)

Use *avc_open*. Initialize the AVC. Initialize the access vector cache.
Return 0 on success or -1 with errno set on failure. If *msgprefix* is NULL,
use *uavc*. If any callback structure references are NULL, use default methods
for those callbacks (see the definition of the callback structures).

*avc_netlink_acquire_fd* - *avc.h*

Create a netlink socket and connect to the kernel.

*avc_netlink_check_nb* - *avc.h*

Wait for netlink messages from the kernel.

*avc_netlink_close* - *avc.h*

Close the netlink socket.

*avc_netlink_loop* - *avc.h*

Acquire netlink socket fd. Allows the application to manage messages from
the netlink socket in its own main loop.

*avc_netlink_open* - *avc.h*

Release netlink socket fd. Returns ownership of the netlink socket to the
ibrary.

*avc_netlink_release_fd* - *avc.h*

Check netlink socket for new messages. Called by the application when using
***avc_netlink_acquire_fd**(3)* to process kernel netlink events.

*avc_open* - *avc.h*

Initialize the AVC. This function is identical to ***avc_init**(3)* except the
message prefix is set to *avc* and any callbacks desired should be specified
via ***selinux_set_callback**(3)*.

*avc_reset* - *avc.h*

Flush the cache and reset statistics. Remove all entries from the cache and
reset all access statistics (as returned by ***avc_cache_stats**(3)*) to zero.
The SID mapping is not affected. Return 0 on success, -1 with errno set on error.

*avc_sid_stats* - *avc.h*

Log SID table statistics. Log a message with information about the size and
distribution of the SID table. The audit callback is used to print the message.

avc_sid_to_context*, *avc_sid_to_context_raw* - *avc.h*

Get copy of context corresponding to SID. Return a copy of the security context
corresponding to the input sid in the memory referenced by *ctx*. The caller is
expected to free the context with ***freecon**(3)*. Return 0 on success, -1
on failure, with errno set to ENOMEM if insufficient memory was available to
make the copy, or EINVAL if the input SID is invalid.

*checkPasswdAccess* (deprecated) - *selinux.h*

Use ***selinux_check_passwd_access**(3)* or preferably
***selinux_check_access**(3)*. Check a permission in the passwd class.
Return 0 if granted or -1 otherwise.

*context_free* - *context.h*

Free the storage used by a context structure.

*context_new* - *context.h*

Return a new context initialized to a context string.

*context_range_get* - *context.h*

Get a pointer to the range.

*context_range_set* - *context.h*

Set the range component. Returns nonzero if unsuccessful.

*context_role_get* - *context.h*

Get a pointer to the role.

*context_role_set* - *context.h*

Set the role component. Returns nonzero if unsuccessful.

*context_str* - *context.h*

Return a pointer to the string value of *context_t*. Valid until the next call
to ***context_str**(3)* or ***context_free**(3)* for the same *context_t*.

*context_type_get* - *context.h*

Get a pointer to the type.

*context_type_set* - *context.h*

Set the type component. Returns nonzero if unsuccessful.

*context_user_get* - *context.h*

Get a pointer to the user.

*context_user_set* - *context.h*

Set the user component. Returns nonzero if unsuccessful.

*fgetfilecon*, *fgetfilecon_raw* - *selinux.h*

Wrapper for the ***xattr**(7)* API - Get file context, and set *\*con* to
refer to it. Caller must free via ***freecon**(3)*.

*fini_selinuxmnt* - *selinux.h*

Clear *selinuxmnt* variable and free allocated memory.

*freecon* - *selinux.h*

Free the memory allocated for a context by any of the *get\** calls.

*freeconary* - *selinux.h*

Free the memory allocated for a context array by
***get_ordered_context_list**(3)*.

*fsetfilecon*, *fsetfilecon_raw* - *selinux.h*

Wrapper for the ***xattr**(7)* API - Set file context.

*get_default_context* - *get_context_list.h*

Get the default security context for a user session for *user* spawned by
*fromcon* and set *\*newcon* to refer to it. The context will be one of those
authorized by the policy, but the selection of a default is subject to user
customizable preferences. If *fromcon* is NULL, defaults to current context.
Returns 0 on success or -1 otherwise. Caller must free via ***freecon**(3)*.

*get_default_context_with_level* - *get_context_list.h*

Same as ***get_default_context**(3)*, but use the provided MLS level rather
than the default level for the user.

*get_default_context_with_role* - *get_context_list.h*

Same as ***get_default_context**(3)*, but only return a context that
has the specified role.

*get_default_context_with_rolelevel* - *get_context_list.h*

Same as ***get_default_context**(3)*, but only return a context that has
the specified role and level.

*get_default_type* - *get_default_type.h*

Get the default type (domain) for *role* and set *type* to refer to it.
Caller must free via ***free**(3)*.
Return 0 on success or -1 otherwise.

*get_ordered_context_list* - *get_context_list.h*

Get an ordered list of authorized security contexts for a user session for
*user* spawned by *fromcon* and set *\*conary* to refer to the NULL-terminated
array of contexts. Every entry in the list will be authorized by the policy,
but the ordering is subject to user customizable preferences.
Returns number of entries in *\*conary*. If *fromcon* is NULL, defaults
to current context. Caller must free via ***freeconary**(3)*.

*get_ordered_context_list_with_level* - *get_context_list.h*

Same as ***get_ordered_context_list**(3)*, but use the provided MLS level
rather than the default level for the user.

*getcon*, *getcon_raw* - *selinux.h*

Get current context, and set *\*con* to refer to it. Caller must free via
***freecon**(3)*.

*getexeccon*, *getexeccon_raw* - *selinux.h*

Get exec context, and set *\*con* to refer to it. Sets *\*con* to NULL if no
exec context has been set, i.e. using default. If non-NULL, caller must
free via ***freecon**(3)*.

*getfilecon*, *getfilecon_raw* - *selinux.h*

Wrapper for the ***xattr**(7)* API - Get file context, and set *\*con* to refer
to it. Caller must free via ***freecon**(3)*.

*getfscreatecon*, *getfscreatecon_raw* - *selinux.h*

Get fscreate context, and set *\*con* to refer to it. Sets *\*con* to NULL if
no fs create context has been set, i.e. using default.If non-NULL, caller must
free via ***freecon**(3)*.

*getkeycreatecon* *getkeycreatecon_raw* - *selinux.h*

Get keycreate context, and set *\*con* to refer to it. Sets *\*con* to NULL
if no key create context has been set, i.e. using default. If non-NULL, caller
must free via ***freecon**(3)*.

*getpeercon*, *getpeercon_raw* - *selinux.h*

Wrapper for the socket API - Get context of peer socket, and set *\*con* to
refer to it. Caller must free via ***freecon**(3)*.

*getpidcon*, *getpidcon_raw* - *selinux.h*

Get context of process identified by pid, and set *\*con* to refer to it.
Caller must free via ***freecon**(3)*.

*getprevcon*, *getprevcon_raw* - *selinux.h*

Get previous context (prior to last exec), and set *\*con* to refer to it.
Caller must free via ***freecon**(3)*.

*getseuser* - *selinux.h*

Get the SELinux username and level to use for a given Linux username and
service. These values may then be passed into the
***get_ordered_context_list**(3)* and ***get_default_context**(3)* functions
to obtain a context for the user.
Returns 0 on success or -1 otherwise.
Caller must free the returned strings via ***free**(3)*.

*getseuserbyname* - *selinux.h*

Get the SELinux username and level to use for a given Linux username.
These values may then be passed into the ***get_ordered_context_list**(3)*
and ***get_default_context**(3)* functions to obtain a context for the user.
Returns 0 on success or -1 otherwise.
Caller must free the returned strings via ***free**(3)*.

*getsockcreatecon*, *getsockcreatecon_raw* - *selinux.h*

Get sockcreate context, and set *\*con* to refer to it. Sets *\*con* to NULL
if no socket create context has been set, i.e. using default.
If non-NULL, caller must free via ***freecon**(3)*.

*init_selinuxmnt* - *selinux.h*

There is a man page for this, however it is not a user accessible function
(internal use only - although the ***fini_selinuxmnt**(3)* is reachable).

*is_context_customizable* - *selinux.h*

Returns whether a file context is customizable, and should not be relabeled.

*is_selinux_enabled* - *selinux.h*

Return 1 if running on a SELinux kernel, or 0 if not or -1 for error.

*is_selinux_mls_enabled* - *selinux.h*

Return 1 if we are running on a SELinux MLS kernel, or 0 otherwise.

*lgetfilecon*, *lgetfilecon_raw* - *selinux.h*

Wrapper for the ***xattr**(7)* API - Get file context, and set *\*con* to
refer to it. Caller must free via ***freecon**(3)*.

*lsetfilecon*, *lsetfilecon_raw* - *selinux.h*

Wrapper for the xattr API- Set file context for symbolic link.

*manual_user_enter_context* - *get_context_list.h*

Allow the user to manually enter a context as a fallback if a list of
authorized contexts could not be obtained. Caller must free via
***freecon**(3)*. Returns 0 on success or -1 otherwise.

*matchmediacon* - *selinux.h*

Match the specified media and against the media contexts configuration and
set *\*con* to refer to the resulting context.
Caller must free con via ***freecon**(3)*.

*matchpathcon* (deprecated) - *selinux.h*

Match the specified *pathname* and *mode* against the file context configuration
and set *\*con* to refer to the resulting context. *mode* can be 0 to disable
mode matching. Caller must free via freecon. If ***matchpathcon_init**(3)*
has not already been called, then this function will call it upon its first
invocation with a NULL path.

*matchpathcon_checkmatches* (deprecated) - *selinux.h*

Check to see whether any specifications had no matches and report them.
The *str* is used as a prefix for any warning messages.

*matchpathcon_filespec_add* (deprecated) - *selinux.h*

Maintain an association between an inode and a specification index, and check
whether a conflicting specification is already associated with the same inode
(e.g. due to multiple hard links). If so, then use the latter of the two
specifications based on their order in the file contexts configuration.
Return the used specification index.

*matchpathcon_filespec_destroy* (deprecated) - *selinux.h*

Destroy any inode associations that have been added, e.g. to restart for a
new filesystem.

*matchpathcon_filespec_eval* (deprecated) - *selinux.h*

Display statistics on the hash table usage for the associations.

*matchpathcon_fini* (deprecated) - *selinux.h*

Free the memory allocated by ***matchpathcon_init**(3)*.

*matchpathcon_index* (deprecated) - *selinux.h*

Same as ***matchpathcon**(3)*, but return a specification index for later use
in a ***matchpathcon_filespec_add**(3)* call.


*matchpathcon_init* (deprecated) - *selinux.h*

Load the file contexts configuration specified by *path* into memory for use
by subsequent *matchpathcon* calls. If *path* is NULL, then load the active file
contexts configuration, i.e. the path returned by
***selinux_file_context_path**(3)*. Unless the *MATCHPATHCON_BASEONLY* flag
has been set, this function also checks for a *path.homedirs* file and a
*path.local* file and loads additional specifications from them if present.

*matchpathcon_init_prefix* (deprecated) - *selinux.h*

Same as ***matchpathcon_init**(3)*, but only load entries with regexes that
have stems that are prefixes of *prefix*.

*mode_to_security_class* - *selinux.h*

Translate mode_t to a security class string name (e.g. *S_ISREG* = *file*).

*print_access_vector* - *selinux.h*

Display an access vector in a string representation.

*query_user_context*- *get_context_list.h*

Given a list of authorized security contexts for the user, query the user to
select one and set *\*newcon* to refer to it. Caller must free via
***freecon**(3)*. Returns 0 on success or -1 otherwise.

*realpath_not_final* - *selinux.h*

Resolve all of the symlinks and relative portions of a *pathname*, but NOT the
final component (same a ***realpath**(3)* unless the final component is a symlink.
Resolved path must be a path of size *PATH_MAX + 1*.

*rpm_execcon* (deprecated) - *selinux.h*

Use ***setexecfilecon**(3)* and ***execve**(2)*. Execute a helper for rpm in
an appropriate security context.

*security_av_perm_to_string* - *selinux.h*

Convert access vector permissions to string names.

*security_av_string* - *selinux.h*

Returns an access vector in a string representation. User must free the
returned string via ***free**(3)*.

*security_canonicalize_context*, *security_canonicalize_context_raw* - *selinux.h*

Canonicalize a security context. Returns a pointer to the canonical (primary)
form of a security context in *canoncon* that the kernel is using rather than
what is provided by the userspace application in *con*.

*security_check_context*, *security_check_context_raw* - *selinux.h*

Check the validity of a security context.

*security_class_to_string* - *selinux.h*

Convert security class values to string names.

*security_commit_booleans* - *selinux.h*

Commit the pending values for the booleans.

*security_compute_av*, *security_compute_av_raw* - *selinux.h*

Compute an access decision. Queries whether the policy permits the source
context *scon* to access the target context *tcon* via class *tclass* with
the *requested* access vector. The decision is returned in *avd*.

*security_compute_av_flags*, *security_compute_av_flags_raw* - *selinux.h*

Compute an access decision and return the flags.
Queries whether the policy permits the source context *scon* to access the
target context *tcon* via class *tclass* with the *requested* access vector.
The decision is returned in *avd*. that has an additional *flags* entry.
Currently the only *flag* defined is *SELINUX_AVD_FLAGS_PERMISSIVE* that
indicates the decision was computed on a permissive domain (i.e. the
*permissive* policy language statement has been used in policy or
***semanage**(8)* has been used to set the domain in permissive mode).
Note this does not indicate that SELinux is running in permissive mode,
only the *scon* domain.

*security_compute_create*, *security_compute_create_raw* - *selinux.h*

Compute a labeling decision and set *newcon to refer to it.
Caller must free via ***freecon**(3)*.

*security_compute_create_name*, *security_compute_create_name_raw* - *selinux.h*

This is identical to* ***security_compute_create**(3)* but also takes the name
of the new object in creation as an argument.
When a *type_transition* rule on the given class and the *scon* / *tcon* pair
has an object name extension, *newcon* will be returned according to the policy.
Note that this interface is only supported on the kernels 2.6.40 or later.
For older kernels the object name is ignored.

*security_compute_member*, *security_compute_member_raw* - *selinux.h*

Compute a polyinstantiation member decision and set *newcon to refer to it.
Caller must free via ***freecon**(3)*.

*security_compute_relabel*, *security_compute_relabel_raw* - *selinux.h*

Compute a relabeling decision and set *\*newcon* to refer to it.
Caller must free via ***freecon**(3)*.

*security_compute_user*, security_compute_user_raw* (deprecated) - *selinux.h*

Compute the set of reachable user contexts and set *\*con* to refer to the
NULL-terminated array of contexts. Caller must free via ***freeconary**(3)*.

*security_deny_unknown* - *selinux.h*

Get the behavior for undefined classes / permissions.

*security_disable* - *selinux.h*

Disable SELinux at runtime (must be done prior to initial policy load).

*security_get_boolean_active* - *selinux.h*

Get the active value for the boolean.

*security_get_boolean_names* - *selinux.h*

Get the boolean names

*security_get_boolean_pending* - *selinux.h*

Get the pending value for the boolean.

*security_get_initial_context*, *security_get_initial_context_raw* - *selinux.h*

Get the context of an initial kernel security identifier by name.
Caller must free via ***freecon**(3)*.

*security_getenforce* - *selinux.h*

Get the enforce flag value.

*security_load_booleans* (deprecated) - *selinux.h*

Load policy boolean settings. Path may be NULL, in which case the booleans
are loaded from the active policy boolean configuration file.

*security_load_policy* - *selinux.h*

Load a policy configuration.

*security_policyvers* - *selinux.h*

Get the policy version number.

*security_set_boolean* - *selinux.h*

Set the pending value for the boolean.

*security_set_boolean_list* - *selinux.h*

Save a list of booleans in a single transaction.

*security_setenforce* - *selinux.h*

Set the enforce flag value.

*security_validatetrans*, *security_validatetrans_raw* - *selinux.h*

Validate a transition. This determines whether a transition from *scon*
to *newcon* using *tcon* as the target for object class *tclass* is valid in
the loaded policy. This checks against the *mlsvalidatetrans* and
*validatetrans* constraints in the loaded policy.
Returns 0 if allowed and -1 if an error occurred with errno set.

*selabel_close* - *label.h*

Destroy the specified handle, closing files, freeing allocated memory, etc.
The handle may not be further used after it has been closed.

*selabel_cmp* - *label.h*

Compare two label configurations. Returns:

- *SELABEL_SUBSET* - if *h1* is a subset of *h2*
- *SELABEL_EQUAL* - if *h1* is identical to *h2*
- *SELABEL_SUPERSET* - if *h1* is a superset of *h2*
- *SELABEL_INCOMPARABLE* - if *h1* and *h2* are incomparable

*selabel_digest* - *label.h*

Retrieve the SHA1 digest and the list of specfiles used to generate the digest.
The *SELABEL_OPT_DIGEST* option must be set in ***selabel_open**(3)* to
initiate the digest generation.

*selabel_get_digests_all_partial_matches* - *label.h*

Returns true if the digest of all partial matched contexts is the same as the
one saved by ***setxattr**(2)*, otherwise returns false. The length of the
SHA1 digest will always be returned. The caller must free any returned digests.

*selabel_hash_all_partial_matches* - *label.h*

Returns true if the digest of all partial matched contexts is the same as the
one saved by ***setxattr**(2)*, otherwise returns false.

*selabel_lookup*, *selabel_lookup_raw* - *label.h*

Perform a labeling lookup operation. Return 0 on success, -1 with *errno*
set on failure. The *key* and *type* arguments are the inputs to the lookup
operation; appropriate values are dictated by the backend in use.
The result is returned in the memory pointed to by *con* and must be freed by
***freecon**(3)*.

*selabel_lookup_best_match*, *selabel_lookup_best_match_raw* - *label.h*

Obtain a best match SELinux security context - Only supported on file backend.
The order of precedence for best match is:

- An exact match for the real path (key) or
- An exact match for any of the links (aliases), or
- The longest fixed prefix match.

*selabel_open* - *label.h*

Create a labeling handle. Open a labeling backend for use.
The available backend identifiers are:

- *SELABEL_CTX_FILE* - *file_contexts*.
- *SELABEL_CTX_MEDIA* - media contexts.
- *SELABEL_CTX_X* - *x_contexts*.
- *SELABEL_CTX_DB* - SE-PostgreSQL contexts.
- *SELABEL_CTX_ANDROID_PROP* – *property_contexts*.
- *SELABEL_CTX_ANDROID_SERVICE* – *service_contexts*.

Options may be provided via the *opts* parameter; available options are:

- *SELABEL_OPT_UNUSED* - no-op option, useful for unused slots in an array of
  options.
- *SELABEL_OPT_VALIDATE* - validate contexts before returning them
  (boolean value).
- *SELABEL_OPT_BASEONLY* - don't use local customizations to backend data
  (boolean value).
- *SELABEL_OPT_PATH* - specify an alternate path to use when loading backend
  data.
- *SELABEL_OPT_SUBSET* - select a subset of the search space as an
  optimization (file backend).
- *SELABEL_OPT_DIGEST* – request an SHA1 digest of the specfiles.

Not all options may be supported by every backend.
Return value is the created handle on success or NULL with errno set on failure.

*selabel_partial_match* - *label.h*

Performs a partial match operation, returning TRUE or FALSE.
The *key* parameter is a file *path* to check for a direct or partial match.
Returns TRUE if a direct or partial match is found, FALSE if not.

*selabel_stats* - *label.h*

Log a message with information about the number of queries performed, number
of unused matching entries, or other operational statistics.
Message is backend-specific, some backends may not output a message.

*selinux_binary_policy_path* - *selinux.h*

Return path to the binary policy file under the policy root directory.

*selinux_booleans_path* (deprecated) - *selinux.h*

Return path to the booleans file under the policy root directory.

*selinux_boolean_sub* - *selinux.h*

Reads the */etc/selinux/TYPE/booleans.subs_dist* file looking for a record
with *boolean_name*. If a record exists ***selinux_boolean_sub**(3)* returns
the translated name otherwise it returns the original name.
The returned value needs to be freed. On failure NULL will be returned.

*selinux_booleans_subs_path* - *selinux.h*

Returns the path to the *booleans.subs_dist* configuration file.

*selinux_check_access* - *selinux.h*

Used to check if the source context has the access permission for the specified
class on the target context. Note that the permission and class are reference
strings. The *aux* parameter may reference supplemental auditing information.
Auditing is handled as described in ***avc_audit**(3)*.
See ***security_deny_unknown**(3)* for how the *deny_unknown* flag can
influence policy decisions.

*selinux_check_passwd_access* (deprecated) - *selinux.h*

Use ***selinux_check_access**(3)*. Check a permission in the passwd class.
Return 0 if granted or -1 otherwise.

*selinux_check_securetty_context* - *selinux.h*

Check if the tty_context is defined as a securetty. Return 0 if secure,
\< 0 otherwise.

*selinux_colors_path* - *selinux.h*

Return path to file under the policy root directory.

*selinux_contexts_path* - *selinux.h*

Return path to contexts directory under the policy root directory.

*selinux_current_policy_path* - *selinux.h*

Return path to the current policy.

*selinux_customizable_types_path* - *selinux.h*

Return path to customizable_types file under the policy root directory.

*selinux_default_context_path* - *selinux.h*

Return path to default_context file under the policy root directory.

*selinux_default_type_path* - *get_default_type.h*

Return path to *default_type* file.

*selinux_failsafe_context_path* - *selinux.h*

Return path to failsafe_context file under the policy root directory.

*selinux_file_context_cmp* - *selinux.h*

Compare two file contexts, return 0 if equivalent.

*selinux_file_context_homedir_path* - *selinux.h*

Return path to *file_context.homedir* file under the policy root directory.

*selinux_file_context_local_path* - *selinux.h*

Return path to *file_context.local* file under the policy root directory.

*selinux_file_context_path* - *selinux.h*

Return path to *file_context* file under the policy root directory.

*selinux_file_context_subs_path* - *selinux.h*

Return path to *file_context.subs* file under the policy root directory.

*selinux_file_context_subs_dist_path* - *selinux.h*

Return path to *file_context.subs_dist* file under the policy root directory.

*selinux_file_context_verify* - *selinux.h*

Verify the context of the file *path* against policy. Return 0 if correct.

*selinux_get_callback* - *selinux.h*

Used to get a pointer to the callback function of the given *type*.
Callback functions are set using ***selinux_set_callback**(3)*.

*selinux_getenforcemode* - *selinux.h*

Reads the /etc/selinux/config file and determines whether the machine should
be started in enforcing (1), permissive (0) or disabled (-1) mode.

*selinux_getpolicytype* - *selinux.h*

Reads the /*etc/selinux/config* file and determines what the default policy
for the machine is. Calling application must free *policytype*.

*selinux_homedir_context_path* - *selinux.h*

Return path to file under the policy root directory. Note that this file will
only appear in older versions of policy at this location. On systems that are
managed using ***semanage**(8)* this is now in the policy store.

*selinux_init_load_policy* - *selinux.h*

Perform the initial policy load.
This function determines the desired enforcing mode, sets the *enforce*
argument accordingly for the caller to use, sets the SELinux kernel enforcing
status to match it, and loads the policy. It also internally handles the
initial *selinuxfs* mount required to perform these actions.
The function returns 0 if everything including the policy load succeeds.
In this case, init is expected to re-exec itself in order to transition to the
proper security context. Otherwise, the function returns -1, and init must
check *enforce* to determine how to proceed. If enforcing (*enforce* \> 0),
then init should halt the system. Otherwise, init may proceed normally without
a re-exec.

*selinux_lsetfilecon_default* - *selinux.h*

This function sets the file context to the system defaults.
Returns 0 on success.

*selinux_lxc_contexts_path* - *selinux.h*

Return the path to the *lxc_contexts* configuration file.

*selinux_media_context_path* - *selinux.h*

Return path to file under the policy root directory.

*selinux_mkload_policy* - *selinux.h*

Make a policy image and load it.
This function provides a higher level interface for loading policy than
***security_load_policy**(3)*, internally determining the right policy version,
locating and opening the policy file, mapping it into memory, manipulating
it as needed for current boolean settings and/or local definitions, and then
calling ***security_load_policy**(3)* to load it.
*preservebools* is a boolean flag indicating whether current policy boolean
values should be preserved into the new policy (if 1) or reset to the saved
policy settings (if 0). The former case is the default for policy reloads,
while the latter case is an option for policy reloads but is primarily for the
initial policy load.

*selinux_netfilter_context_path* - *selinux.h*

Returns path to the netfilter_context file under the policy root directory.

*selinux_path* - *selinux.h*

Returns path to the policy root directory.

*selinux_policy_root* - *selinux.h*

Reads the /etc/selinux/config file and returns the top level directory.

*selinux_raw_context_to_color* - *selinux.h*

Perform context translation between security contexts and display colors.
Returns a space-separated list of ten ten hex RGB triples prefixed by
hash marks, e.g. *#ff0000*. Caller must free the resulting string
via ***free**(3)*. Returns -1 upon an error or 0 otherwise.

*selinux_raw_to_trans_context* - *selinux.h*

Perform context translation between the human-readable format (*translated*)
and the internal system format (*raw*). Caller must free the resulting context
via ***freecon**(3)*. Returns -1 upon an error or 0 otherwise.
If passed NULL, sets the returned context to NULL and returns 0.

*selinux_removable_context_path* - *selinux.h*

Return path to *removable_context* file under the policy root directory.

*selinux_restorecon* - *restorecon.h*

Relabel files that automatically calls ***selinux_restorecon_default_handle**(3)* and ***selinux_restorecon_set_sehandle**(3)* first time through to set the ***selabel_open**(3)* parameters to use the currently loaded policy *file_contexts* and request their computed digest.
Should other ***selabel_open**(3)* parameters be required see ***selinux_restorecon_set_sehandle**(3)*.

*selinux_restorecon_xattr* - *restorecon.h*

Read/remove *RESTORECON_LAST* xattr entries that automatically calls ***selinux_restorecon_default_handle**(3)* and ***selinux_restorecon_set_sehandle**(3)* first time through to set the ***selabel_open**(3)* parameters to use the currently loaded policy *file_contexts* and request their computed digest.
Should other ***selabel_open**(3)* parameters be required see ***selinux_restorecon_set_sehandle**(3)*, however note that a *file_contexts* computed digest is required for ***selinux_restorecon_xattr**(3)*.

*selinux_restorecon_default_handle* - *restorecon.h*

Sets default ***selabel_open**(3)* parameters to use the currently loaded policy and *file_contexts*, also requests the digest.

*selinux_restorecon_set_alt_rootpath* - *restorecon.h*

Use alternate rootpath.

*selinux_restorecon_set_exclude_list* - *restorecon.h*

Add a list of directories that are to be excluded from relabeling.

*selinux_restorecon_set_sehandle* - *restorecon.h*

Set the global fc handle. Called by a process that has already called ***selabel_open**(3)* with its required parameters, or if ***selinux_restorecon_default_handle**(3)* has been called to set the default ***selabel_open**(3)* parameters.

*selinux_securetty_types_path* - *selinux.h*

Return path to the securetty_types file under the policy root directory.

*selinux_sepgsql_context_path* - *selinux.h*

*Return path to *sepgsql_context* file under the policy root directory.

*selinux_set_callback* - *selinux.h*

Sets the callback according to the type: *SELINUX_CB_LOG*, *SELINUX_CB_AUDIT*, *SELINUX_CB_VALIDATE*, *SELINUX_CB_SETENFORCE*, *SELINUX_CB_POLICYLOAD*

*selinux_set_mapping* - *selinux.h*

Userspace class mapping support that establishes a mapping from a user-provided ordering of object classes and permissions to the numbers actually used by the loaded system policy.

*selinux_set_policy_root* - *selinux.h*

Sets an alternate policy root directory path under which the compiled policy file and context configuration files exist.

*selinux_status_open* - *avc.h*

Open and map SELinux kernel status page.

*selinux_status_close* - *avc.h*

Unmap and close kernel status page.

*selinux_status_updated* - *avc.h*

Inform whether the kernel status has been updated.

*selinux_status_getenforce* - *avc.h*

Get the enforce flag value.

*selinux_status_policyload* - *avc.h*

Get the number of policy loads.

*selinux_status_deny_unknown* - *avc.h*

Get behaviour for undefined classes/permissions.

*selinux_systemd_contexts_path* - *selinux.h*

Returns the path to the *systemd_contexts* configuration file.

*selinux_reset_config* - *selinux.h*

Force a reset of the loaded configuration. **WARNING**: This is not thread safe.
Be very sure that no other threads are calling into *libselinux* when this
is called.

*selinux_trans_to_raw_context* - *selinux.h*

Perform context translation between the human-readable format (*translated*)
and the internal system format (*raw*). Caller must free the resulting context
via ***freecon**(3)*. Returns -1 upon an error or 0 otherwise.
If passed NULL, sets the returned context to NULL and returns 0.

*selinux_translations_path* - *selinux.h*

Return path to setrans.conf file under the policy root directory.

*selinux_user_contexts_path* - *selinux.h*

Return path to file under the policy root directory.

*selinux_users_path* (deprecated) - *selinux.h*

Return path to file under the policy root directory.

*selinux_usersconf_path* - *selinux.h*

Return path to file under the policy root directory.

*selinux_virtual_domain_context_path* - *selinux.h*

Return path to file under the policy root directory.

*selinux_virtual_image_context_path* - *selinux.h*

Return path to file under the policy root directory.

*selinux_x_context_path* - *selinux.h*

Return path to x_context file under the policy root directory.

*selinuxfs_exists* - *selinux.h*

Check if selinuxfs exists as a kernel filesystem.

*set_matchpathcon_canoncon* (deprecated) - *selinux.h*

Same as ***set_matchpathcon_invalidcon**(3)*, but also allows canonicalization
of the context, by changing *context* to refer to the canonical form.
If not set, and *invalidcon* is also not set, then this defaults to calling
***security_canonicalize_context**(3)*.

*set_matchpathcon_flags* (deprecated) - *selinux.h*

Set flags controlling operation of ***matchpathcon_init**(3)* or
***matchpathcon**(3)*:

- *MATCHPATHCON_BASEONLY* - Only process the base file_contexts file.
- *MATCHPATHCON_NOTRANS* - Do not perform any context translation.
- *MATCHPATHCON_VALIDATE* - Validate/canonicalize contexts at init time.

*set_matchpathcon_invalidcon* (deprecated) - *selinux.h*

Set the function used by ***matchpathcon_init**(3)* when checking the validity
of a context in the *file_contexts* configuration. If not set, then this
defaults to a test based on ***security_check_context**(3)*. The function is
also responsible for reporting any such error, and may include the *path* and
*lineno* in such error messages.

*set_matchpathcon_printf* (deprecated) - *selinux.h*

Set the function used by ***matchpathcon_init**(3)* when displaying errors
about the *file_contexts* configuration. If not set, then this defaults
to *fprintf(stderr, fmt, ...)*.

*set_selinuxmnt* - *selinux.h*

Set the path to the selinuxfs mount point explicitly. Normally, this is
determined automatically during libselinux initialization, but this is not
always possible, e.g. for /sbin/init which performs the initial mount of
*selinuxfs*.

*setcon*, *setcon_raw* - *selinux.h*

Set the current security context to con.
Note that use of this function requires that the entire application be trusted
to maintain any desired separation between the old and new security contexts,
unlike exec-based transitions performed via ***setexeccon**(3)*.
When possible, decompose your application and use ***setexeccon**(3)* +
***execve**(3)* instead. Note that the application may lose access to its
open descriptors as a result of a ***setcon**(3)* unless policy allows it to
use descriptors opened by the old context.

*setexeccon*, *setexeccon_raw* - *selinux.h*

Set exec security context for the next ***execve**(3)*.
Call with NULL if you want to reset to the default.

*setexecfilecon* - *selinux.h*

Set an appropriate security context based on the filename of a helper program,
falling back to a new context with the specified type.

*setfilecon*, *setfilecon_raw* - *selinux.h*

Wrapper for the xattr API - Set file context.

*setfscreatecon*, *setfscreatecon_raw* - *selinux.h*

Set the fscreate security context for subsequent file creations.
Call with NULL if you want to reset to the default.

*setkeycreatecon*, *setkeycreatecon_raw* - *selinux.h*

Set the keycreate security context for subsequent key creations.
Call with NULL if you want to reset to the default.

*setsockcreatecon*, *setsockcreatecon_raw* - *selinux.h*

Set the sockcreate security context for subsequent socket creations.
Call with NULL if you want to reset to the default.

*sidget* (deprecated) - *avc.h*

From 2.0.86 this is a no-op.

*sidput* (deprecated) - *avc.h*

From 2.0.86 this is a no-op.

*string_to_av_perm* - *selinux.h*

Convert string names to access vector permissions.

*string_to_security_class* - *selinux.h*

Convert string names to security class values.

<!-- %CUTHERE% -->

---
**[[ PREV ]](object_classes_permissions.md)** **[[ TOP ]](#)** **[[ NEXT ]](selinux_cmds.md)**
