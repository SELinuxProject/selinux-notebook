# Appendix B - *libselinux* API Summary

These functions have been taken from the following header files of
*libselinux* version 3.0:
-   */usr/include/selinux/avc.h*
-   */usr/include/selinux/context.h*
-   */usr/include/selinux/get_context_list.h*
-   */usr/include/selinux/get_default_type.h*
-   */usr/include/selinux/label.h*
-   */usr/include/selinux/restorecon.h*
-   */usr/include/selinux/selinux.h*

The appropriate ***man**(3)* pages should consulted for detailed usage.

<table>
<tbody>
<tr style="background-color:#F2F2F2;">
<td><strong>Function Name</strong></td>
<td><strong>Description</strong></td>
<td><strong>Header File</strong></td>
</tr>
<tr>
<td>avc_add_callback</td>
<td>Register a callback for security events.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_audit</td>
<td>Audit the granting or denial of permissions in accordance with the policy. This function is typically called by <strong>avc_has_perm</strong>(3) after a permission check, but can also be called directly by callers who use <strong>avc_has_perm_noaudit</strong>(3) in order to separate the permission check from the auditing. For example, this separation is useful when the permission check must be performed under a lock, to allow the lock to be released before calling the auditing code.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_av_stats</td>
<td>Log AV table statistics. Logs a message with information about the size and distribution of the access vector table. The audit callback is used to print the message.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_cache_stats</td>
<td>Get cache access statistics. Fill the supplied structure with information about AVC activity since the last call to <strong>avc_init</strong>(3) or <strong>avc_reset</strong>(3).</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_cleanup</td>
<td><p>Remove unused SIDs and AVC entries.</p>
<p>Search the SID table for SID structures with zero reference counts, and remove them along with all AVC entries that reference them. This can be used to return memory to the system.</p></td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_compute_create</td>
<td>Compute SID for labeling a new object. Call the security server to obtain a context for labeling a new object. Look up the context in the SID table, making a new entry if not found.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_compute_member</td>
<td><p>Compute SID for polyinstantation.</p>
<p>Call the security server to obtain a context for labeling an object instance. Look up the context in the SID table, making a new entry if not found.</p></td>
<td>avc.h</td>
</tr>
<tr>
<td><p>avc_context_to_sid</p>
<p>avc_context_to_sid_raw</p></td>
<td>Get SID for context. Look up security context <em>ctx</em> in SID table, making a new entry if <em>ctx</em> is not found. Store a pointer to the SID structure into the memory referenced by <em>sid</em>, returning 0 on success or -1 on error with <em>errno</em> set.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_destroy</td>
<td><p>Free all AVC structures.</p>
<p>Destroy all AVC structures and free all allocated memory. User-supplied locking, memory, and audit callbacks will be retained, but security-event callbacks will not. All SID's will be invalidated. User must call <strong>avc_init</strong>(3) if further use of AVC is desired.</p></td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_entry_ref_init</td>
<td><p>Initialize an AVC entry reference.</p>
<p>Use this macro to initialize an avc entry reference structure before first use. These structures are passed to <strong>avc_has_perm</strong>(3), which stores cache entry references in them. They can increase performance on repeated queries.</p></td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_get_initial_sid</td>
<td><p>Get SID for an initial kernel security identifier.</p>
<p>Get the context for an initial kernel security identifier specified by name using <strong>security_get_initial_context</strong>(3) and then call <strong>avc_context_to_sid</strong>(3) to get the corresponding SID.</p></td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_has_perm</td>
<td><p>Check permissions and perform any appropriate auditing.</p>
<p>Check the AVC to determine whether the requested permissions are granted for the SID pair (ssid, tsid), interpreting the permissions based on tclass, and call the security server on a cache miss to obtain a new decision and add it to the cache. Update aeref to refer to an AVC entry with the resulting decisions. Audit the granting or denial of permissions in accordance with the policy. Return 0 if all requested permissions are granted, -1 with errno set to EACCES if any permissions are denied or to another value upon other errors.</p></td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_has_perm_noaudit</td>
<td>Check permissions but perform no auditing. Check the AVC to determine whether the requested permissions are granted for the SID pair (ssid, tsid), interpreting the permissions based on tclass, and call the security server on a cache miss to obtain a new decision and add it to the cache. Update aeref to refer to an AVC entry with the resulting decisions, and return a copy of the decisions in avd. Return 0 if all requested permissions are granted, -1 with errno set to EACCES if any permissions are denied, or to another value upon other errors. This function is typically called by <strong>avc_has_perm</strong>(3), but may also be called directly to separate permission checking from auditing, e.g. in cases where a lock must be held for the check but should be released for the auditing.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_init (deprecated)</td>
<td><p>Use <em>avc_open</em></p>
<p>Initialize the AVC. Initialize the access vector cache. Return 0 on success or -1 with errno set on failure. If msgprefix is NULL, use "uavc". If any callback structure references are NULL, use default methods for those callbacks (see the definition of the callback structures).</p></td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_netlink_acquire_fd</td>
<td>Create a netlink socket and connect to the kernel.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_netlink_check_nb</td>
<td>Wait for netlink messages from the kernel.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_netlink_close</td>
<td>Close the netlink socket.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_netlink_loop</td>
<td>Acquire netlink socket fd. Allows the application to manage messages from the netlink socket in its own main loop.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_netlink_open</td>
<td>Release netlink socket fd. Returns ownership of the netlink socket to the library.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_netlink_release_fd</td>
<td>Check netlink socket for new messages. Called by the application when using <em><strong>avc_netlink_acquire_fd</strong>(3)</em> to process kernel netlink events.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_open</td>
<td>Initialize the AVC. This function is identical to <strong>avc_init</strong>(3) except the message prefix is set to "avc" and any callbacks desired should be specified via <strong>selinux_set_callback</strong>(3).</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_reset</td>
<td>Flush the cache and reset statistics. Remove all entries from the cache and reset all access statistics (as returned by <strong>avc_cache_stats</strong>(3)) to zero. The SID mapping is not affected. Return 0 on success, -1 with errno set on error.</td>
<td>avc.h</td>
</tr>
<tr>
<td>avc_sid_stats</td>
<td>Log SID table statistics. Log a message with information about the size and distribution of the SID table. The audit callback is used to print the message.</td>
<td>avc.h</td>
</tr>
<tr>
<td><p>avc_sid_to_context</p>
<p>avc_sid_to_context_raw</p></td>
<td>Get copy of context corresponding to SID. Return a copy of the security context corresponding to the input sid in the memory referenced by ctx. The caller is expected to free the context with <strong>freecon</strong>(3). Return 0 on success, -1 on failure, with errno set to ENOMEM if insufficient memory was available to make the copy, or EINVAL if the input SID is invalid.</td>
<td>avc.h</td>
</tr>
<tr>
<td>checkPasswdAccess (deprecated)</td>
<td><p>Use <em><strong>selinux_check_passwd_access</strong>(3)</em> or preferably <em><strong>selinux_check_access</strong>(3)</em></p>
<p>Check a permission in the passwd class. Return 0 if granted or -1 otherwise.</p></td>
<td>selinux.h</td>
</tr>
<tr>
<td>context_free</td>
<td>Free the storage used by a context.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_new</td>
<td>Return a new context initialized to a context string.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_range_get</td>
<td>Get a pointer to the range.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_range_set</td>
<td>Set the range component. Returns nonzero if unsuccessful.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_role_get</td>
<td>Get a pointer to the role.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_role_set</td>
<td>Set the role component. Returns nonzero if unsuccessful.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_str</td>
<td>Return a pointer to the string value of context_t. Valid until the next call to context_str or context_free for the same context_t*.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_type_get</td>
<td>Get a pointer to the type.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_type_set</td>
<td>Set the type component. Returns nonzero if unsuccessful.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_user_get</td>
<td>Get a pointer to the user.</td>
<td>context.h</td>
</tr>
<tr>
<td>context_user_set</td>
<td>Set the user component. Returns nonzero if unsuccessful.</td>
<td>context.h</td>
</tr>
<tr>
<td><p>fgetfilecon</p>
<p>fgetfilecon_raw</p></td>
<td>Wrapper for the xattr API - Get file context, and set *con to refer to it. Caller must free via freecon.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>fini_selinuxmnt</td>
<td>Clear <em>selinuxmnt</em> variable and free allocated memory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>freecon</td>
<td>Free the memory allocated for a context by any of the get* calls.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>freeconary (deprecated)</td>
<td>Free the memory allocated for a context array by <strong>security_compute_user</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>fsetfilecon</p>
<p>fsetfilecon_raw</p></td>
<td>Wrapper for the xattr API - Set file context.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>get_default_context</td>
<td>Get the default security context for a user session for 'user' spawned by 'fromcon' and set *newcon to refer to it. The context will be one of those authorized by the policy, but the selection of a default is subject to user customizable preferences. If 'fromcon' is NULL, defaults to current context. Returns 0 on success or -1 otherwise. Caller must free via freecon. </td>
<td>get_context_list.h</td>
</tr>
<tr>
<td>get_default_context_with_level</td>
<td>Same as <strong>get_default_context</strong>(3), but use the provided MLS level rather than the default level for the user. </td>
<td>get_context_list.h</td>
</tr>
<tr>
<td>get_default_context_with_role</td>
<td>Same as <strong>get_default_context</strong>(3), but only return a context that has the specified role.</td>
<td>get_context_list.h</td>
</tr>
<tr>
<td>get_default_context_with_rolelevel</td>
<td>Same as <strong>get_default_context</strong>(3), but only return a context that has the specified role and level.</td>
<td>get_context_list.h</td>
</tr>
<tr>
<td>get_default_type</td>
<td>Get the default type (domain) for 'role' and set 'type' to refer to it. Caller must free via <strong>free</strong>(3). Return 0 on success or -1 otherwise. </td>
<td>get_default_type.h</td>
</tr>
<tr>
<td>get_ordered_context_list</td>
<td>Get an ordered list of authorized security contexts for a user session for 'user' spawned by 'fromcon' and set *conary to refer to the NULL-terminated array of contexts. Every entry in the list will be authorized by the policy, but the ordering is subject to user customizable preferences. Returns number of entries in *conary. If 'fromcon' is NULL, defaults to current context. Caller must free via <strong>freeconary</strong>(3).</td>
<td>get_context_list.h</td>
</tr>
<tr>
<td>get_ordered_context_list_with_level</td>
<td>Same as <strong>get_ordered_context_list</strong>(3), but use the provided MLS level rather than the default level for the user.</td>
<td>get_context_list.h</td>
</tr>
<tr>
<td><p>getcon</p>
<p>getcon_raw</p></td>
<td>Get current context, and set *con to refer to it. Caller must free via <strong>freecon</strong>(3). </td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>getexeccon</p>
<p>getexeccon_raw</p></td>
<td>Get exec context, and set *con to refer to it. Sets *con to NULL if no exec context has been set, i.e. using default. If non-NULL, caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>getfilecon</p>
<p>getfilecon_raw</p></td>
<td>Wrapper for the xattr API - Get file context, and set *con to refer to it. Caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>getfscreatecon</p>
<p>getfscreatecon_raw</p></td>
<td>Get fscreate context, and set *con to refer to it. Sets *con to NULL if no fs create context has been set, i.e. using default.If non-NULL, caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>getkeycreatecon</p>
<p>getkeycreatecon_raw</p></td>
<td>Get keycreate context, and set *con to refer to it. Sets *con to NULL if no key create context has been set, i.e. using default. If non-NULL, caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>getpeercon</p>
<p>getpeercon_raw</p></td>
<td>Wrapper for the socket API - Get context of peer socket, and set *con to refer to it. Caller must free via <em><strong>freecon</strong>(3)</em>.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>getpidcon</p>
<p>getpidcon_raw</p></td>
<td>Get context of process identified by pid, and set *con to refer to it. Caller must free via <em><strong>freecon</strong>(3)</em>.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>getprevcon</p>
<p>getprevcon_raw</p></td>
<td>Get previous context (prior to last exec), and set *con to refer to it. Caller must free via <em><strong>freecon</strong></em>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td>getseuser</td>
<td>Get the SELinux username and level to use for a given Linux username and service. These values may then be passed into the get_ordered_context_list* and get_default_context* functions to obtain a context for the user. Returns 0 on success or -1 otherwise. Caller must free the returned strings via <strong>free</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td>getseuserbyname</td>
<td>Get the SELinux username and level to use for a given Linux username. These values may then be passed into the get_ordered_context_list* and get_default_context* functions to obtain a context for the user. Returns 0 on success or -1 otherwise. Caller must free the returned strings via <strong>free</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>getsockcreatecon</p>
<p>getsockcreatecon_raw</p></td>
<td>Get sockcreate context, and set *con to refer to it. Sets *con to NULL if no socket create context has been set, i.e. using default. If non-NULL, caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td>init_selinuxmnt</td>
<td>There is a man page for this, however it is not a user accessible function (internal use only - although the <em>fini_selinuxmnt</em> is reachable).</td>
<td>-</td>
</tr>
<tr>
<td>is_context_customizable</td>
<td>Returns whether a file context is customizable, and should not be relabeled.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>is_selinux_enabled</td>
<td>Return 1 if running on a SELinux kernel, or 0 if not or -1 for error.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>is_selinux_mls_enabled</td>
<td>Return 1 if we are running on a SELinux MLS kernel, or 0 otherwise.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>lgetfilecon</p>
<p>lgetfilecon_raw</p></td>
<td>Wrapper for the xattr API - Get file context, and set *con to refer to it. Caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>lsetfilecon</p>
<p>lsetfilecon_raw</p></td>
<td>Wrapper for the xattr API- Set file context for symbolic link.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>manual_user_enter_context</td>
<td>Allow the user to manually enter a context as a fallback if a list of authorized contexts could not be obtained. Caller must free via <strong>freecon</strong>(3). Returns 0 on success or -1 otherwise. </td>
<td>get_context_list.h</td>
</tr>
<tr>
<td>matchmediacon</td>
<td>Match the specified media and against the media contexts configuration and set *con to refer to the resulting context. Caller must free con via freecon.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon (deprecated)</td>
<td>Match the specified pathname and mode against the file context sconfiguration and set *con to refer to the resulting context.'mode' can be 0 to disable mode matching. Caller must free via freecon. If <strong>matchpathcon_init</strong>(3) has not already been called, then this function will call it upon its first invocation with a NULL path.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon_checkmatches (deprecated)</td>
<td>Check to see whether any specifications had no matches and report them. The 'str' is used as a prefix for any warning messages.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon_filespec_add (deprecated)</td>
<td>Maintain an association between an inode and a specification index, and check whether a conflicting specification is already associated with the same inode (e.g. due to multiple hard links). If so, then use the latter of the two specifications based on their order in the file contexts configuration. Return the used specification index. </td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon_filespec_destroy (deprecated)</td>
<td>Destroy any inode associations that have been added, e.g. to restart for a new filesystem. </td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon_filespec_eval (deprecated)</td>
<td>Display statistics on the hash table usage for the associations.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon_fini (deprecated)</td>
<td>Free the memory allocated by matchpathcon_init.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon_index (deprecated)</td>
<td>Same as <strong>matchpathcon</strong>(3), but return a specification index for later use in a <strong>matchpathcon_filespec_add</strong>(3) call.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon_init (deprecated)</td>
<td>Load the file contexts configuration specified by 'path' into memory for use by subsequent matchpathcon calls. If 'path' is NULL, then load the active file contexts configuration, i.e. the path returned by <strong>selinux_file_context_path</strong>(3). Unless the MATCHPATHCON_BASEONLY flag has been set, this function also checks for a 'path'.homedirs file and a 'path'.local file and loads additional specifications from them if present.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>matchpathcon_init_prefix (deprecated)</td>
<td>Same as <strong>matchpathcon_init</strong>(3), but only load entries with regexes that have stems that are prefixes of 'prefix'.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>mode_to_security_class</td>
<td>Translate mode_t to a security class string name (e.g. <em>S_ISREG</em> = "<em>file</em>").</td>
<td>selinux.h</td>
</tr>
<tr>
<td>print_access_vector</td>
<td>Display an access vector in a string representation.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>query_user_context</td>
<td>Given a list of authorized security contexts for the user, query the user to select one and set *newcon to refer to it. Caller must free via <strong>freecon</strong>(3). Returns 0 on success or -1 otherwise. </td>
<td>get_context_list.h</td>
</tr>
<tr>
<td>realpath_not_final</td>
<td>Resolve all of the symlinks and relative portions of a pathname, but NOT the final component (same a <em><strong>realpath</strong>(3)</em> unless the final component is a symlink. Resolved path must be a path of size <em>PATH_MAX + 1</em>.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>rpm_execcon (deprecated)</td>
<td><strong>Use setexecfilecon and execve</strong> Execute a helper for rpm in an appropriate security context.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_av_perm_to_string</td>
<td>Convert access vector permissions to string names.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_av_string</td>
<td>Returns an access vector in a string representation. User must free the returned string via <strong>free</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_canonicalize_context</p>
<p>security_canonicalize_context_raw</p></td>
<td>Canonicalize a security context. Returns a pointer to the canonical (primary) form of a security context in <em>canoncon</em> that the kernel is using rather than what is provided by the userspace application in <em>con</em>. </td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_check_context</p>
<p>security_check_context_raw</p></td>
<td>Check the validity of a security context.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_class_to_string</td>
<td>Convert security class values to string names.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_commit_booleans</td>
<td>Commit the pending values for the booleans.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_compute_av</p>
<p>security_compute_av_raw</p></td>
<td><p>Compute an access decision. </p>
<p>Queries whether the policy permits the source context <em>scon</em> to access the target context <em>tcon</em> via class <em>tclass</em> with the <em>requested</em> access vector. The decision is returned in <em>avd</em>.</p></td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_compute_av_flags</p>
<p>security_compute_av_flags_raw</p></td>
<td><p>Compute an access decision and return the flags. </p>
<p>Queries whether the policy permits the source context <em>scon</em> to access the target context <em>tcon</em> via class <em>tclass</em> with the <em>requested</em> access vector. The decision is returned in <em>avd</em>. that has an additional <em><strong>flags</strong></em> entry. Currently the only flag defined is SELINUX_AVD_FLAGS_PERMISSIVE that indicates the decision was computed on a permissive domain (i.e. the <em><strong>permissive</strong></em> policy language statement has been used in policy or <em><strong>semanage</strong>(8)</em> has been used to set the domain in permissive mode). Note this does not indicate that SELinux is running in permissive mode, only the <em>scon</em> domain.</p></td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_compute_create</p>
<p>security_compute_create_raw</p></td>
<td>Compute a labeling decision and set *newcon to refer to it. Caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_compute_create_name</p>
<p>security_compute_create_name_raw</p></td>
<td><p>This is identical to<em> <strong>security_compute_create</strong>(3)</em> but also takes the name of the new object in creation as an argument.</p>
<p>When a <em>type_transition</em> rule on the given class and the <em>scon</em> / <em>tcon</em> pair has an object name extension, <em>newcon</em> will be returned according to the policy. Note that this interface is only supported on the kernels 2.6.40 or later. For older kernels the object name is ignored.</p></td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_compute_member</p>
<p>security_compute_member_raw</p></td>
<td>Compute a polyinstantiation member decision and set *newcon to refer to it. Caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_compute_relabel</p>
<p>security_compute_relabel_raw</p></td>
<td>Compute a relabeling decision and set *newcon to refer to it. Caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_compute_user (deprecated)</p>
<p>security_compute_user_raw (deprecated)</p></td>
<td>Compute the set of reachable user contexts and set *con to refer to the NULL-terminated array of contexts. Caller must free via <strong>freeconary</strong>(3). </td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_deny_unknown</td>
<td>Get the behavior for undefined classes / permissions.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_disable</td>
<td>Disable SELinux at runtime (must be done prior to initial policy load).</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_get_boolean_active</td>
<td>Get the active value for the boolean.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_get_boolean_names</td>
<td>Get the boolean names</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_get_boolean_pending</td>
<td>Get the pending value for the boolean.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_get_initial_context</p>
<p>security_get_initial_context_raw</p></td>
<td>Get the context of an initial kernel security identifier by name. Caller must free via <strong>freecon</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_getenforce</td>
<td>Get the enforce flag value.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_load_booleans (deprecated)</td>
<td>Load policy boolean settings. Path may be NULL, in which case the booleans are loaded from the active policy boolean configuration file.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_load_policy</td>
<td>Load a policy configuration.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_policyvers</td>
<td>Get the policy version number.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_set_boolean</td>
<td>Set the pending value for the boolean.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_set_boolean_list</td>
<td>Save a list of booleans in a single transaction.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>security_setenforce</td>
<td>Set the enforce flag value.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>security_validatetrans</p>
<p>security_validatetrans_raw</p></td>
<td>Validate a transition. This determines whether a transition from scon to newcon using tcon as the target for object class tclass is valid in the loaded policy. This checks against the mlsvalidatetrans and validatetrans constraints in the loaded policy. Returns 0 if allowed and -1 if an error occurred with errno set.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selabel_close</td>
<td>Destroy the specified handle, closing files, freeing allocated memory, etc. The handle may not be further used after it has been closed.</td>
<td>label.h</td>
</tr>
<tr>
<td>selabel_cmp</td>
<td><p>Compare two label configurations. Returns:</p>
<p><em>SELABEL_SUBSET</em> if <em>h1</em> is a subset of <em>h2</em></p>
<p><em>SELABEL_EQUAL</em> if <em>h1</em> is identical to <em>h2</em></p>
<p><em>SELABEL_SUPERSET</em> if <em>h1</em> is a superset of <em>h2</em></p>
<p><em>SELABEL_INCOMPARABLE</em> if <em>h1</em> and <em>h2</em> are incomparable</p></td>
<td>label.h</td>
</tr>
<tr>
<td>selabel_digest</td>
<td>Retrieve the SHA1 digest and the list of specfiles used to generate the digest. The <em>SELABEL_OPT_DIGEST</em> option must be set in <em><strong>selabel_open</strong>(3)</em> to initiate the digest generation.</td>
<td>label.h</td>
</tr>
<tr>
<td>selabel_get_digests_all_partial_matches</td>
<td>Returns true if the digest of all partial matched contexts is the same as the one saved by setxattr, otherwise returns false. The length of the SHA1 digest will always be returned. The caller must free any returned digests.</td>
<td>label.h</td>
</tr>
<tr>
<td>selabel_hash_all_partial_matches</td>
<td>Returns true if the digest of all partial matched contexts is the same as the one saved by setxattr, otherwise returns false.</td>
<td>label.h</td>
</tr>

<tr>
<td><p>selabel_lookup</p>
<p>selabel_lookup_raw</p></td>
<td>Perform a labeling lookup operation. Return 0 on success, -1 with errno set on failure. The <em>key</em> and <em>type</em> arguments are the inputs to the lookup operation; appropriate values are dictated by the backend in use. The result is returned in the memory pointed to by con and must be freed by freecon.</td>
<td>label.h</td>
</tr>
<tr>
<td><p>selabel_lookup_best_match</p>
<p>selabel_lookup_best_match_raw</p></td>
<td><p>Obtain a best match SELinux security context - Only supported on file backend. The order of precedence for best match is:</p>
<p>1. An exact match for the real path (key) or</p>
<p>2. An exact match for any of the links (aliases), or</p>
<p>3. The longest fixed prefix match.</p></td>
<td>label.h</td>
</tr>
<tr>
<td>selabel_open</td>
<td><p>Create a labeling handle.</p>
<p>Open a labeling backend for use. The available backend identifiers are:</p>
<p>SELABEL_CTX_FILE - file_contexts.</p>
<p>SELABEL_CTX_MEDIA - media contexts.</p>
<p>SELABEL_CTX_X - x_contexts.</p>
<p><em>SELABEL_CTX_DB</em> - SE-PostgreSQL contexts.</p>
<p>SELABEL_CTX_ANDROID_PROP – <em>property</em>_contexts.</p>
<p>S<em>ELABEL_CTX_ANDROID_SERVICE</em> – <em>service_contexts</em>.</p>
<p> Options may be provided via the opts parameter; available options are:</p>
<p>SELABEL_OPT_UNUSED - no-op option, useful for unused slots in an array of options.</p>
<p>SELABEL_OPT_VALIDATE - validate contexts before returning them (boolean value).</p>
<p>SELABEL_OPT_BASEONLY - don't use local customizations to backend data (boolean value).</p>
<p>SELABEL_OPT_PATH - specify an alternate path to use when loading backend data.</p>
<p>SELABEL_OPT_SUBSET - select a subset of the search space as an optimization (file backend).</p>
<p><em>SELABEL_OPT_DIGEST</em> – request an SHA1 digest of the specfiles.</p>
<p>Not all options may be supported by every backend. Return value is the created handle on success or NULL with errno set on failure.</p></td>
<td>label.h</td>
</tr>
<tr>
<td>selabel_partial_match</td>
<td>label.h</td>
</tr>
<tr>
<td>selabel_stats</td>
<td>Log a message with information about the number of queries performed, number of unused matching entries, or other operational statistics. Message is backend-specific, some backends may not output a message.</td>
<td>label.h</td>
</tr>
<tr>
<td>selinux_binary_policy_path</td>
<td>Return path to the binary policy file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_booleans_path (deprecated)</td>
<td>Return path to the booleans file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_boolean_sub</td>
<td>Reads the <em>/etc/selinux/TYPE/booleans.subs_dist</em> file looking for a record with <em>boolean_name</em>. If a record exists <em><strong>selinux_boolean_sub</strong>(3)</em> returns the translated name otherwise it returns the original name. The returned value needs to be freed. On failure NULL will be returned.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_booleans_subs_path</td>
<td>Returns the path to the <em>booleans.subs_dist</em> configuration file.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_check_access</td>
<td><p>Used to check if the source context has the access permission for the specified class on the target context. Note that the permission and class are reference strings.</p>
<p>The <em>aux</em> parameter may reference supplemental auditing information. </p>
<p>Auditing is handled as described in <em><strong>avc_audit</strong>(3)</em>.</p>
<p>See <em><strong>security_deny_unknown</strong>(3)</em> for how the <em>deny_unknown</em> flag can influence policy decisions.</p></td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_check_passwd_access (deprecated)</td>
<td><p><strong>Use selinux_check_access<strong> Check a permission in the passwd class. Return 0 if granted or -1 otherwise.</p>
<p>Replaced by <em><strong>selinux_check_access</strong>(3)</em></p></td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_check_securetty_context </td>
<td>Check if the tty_context is defined as a securetty. Return 0 if secure, &lt; 0 otherwise.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_colors_path</td>
<td>Return path to file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_contexts_path</td>
<td>Return path to contexts directory under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_current_policy_path</td>
<td>Return path to the current policy.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_customizable_types_path</td>
<td>Return path to customizable_types file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_default_context_path</td>
<td>Return path to default_context file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_default_type_path</td>
<td>Return path to <em>default_type</em> file.</td>
<td>get_default_type.h</td>
</tr>
<tr>
<td>selinux_failsafe_context_path</td>
<td>Return path to failsafe_context file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_file_context_cmp</td>
<td>Compare two file contexts, return 0 if equivalent.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_file_context_homedir_path</td>
<td>Return path to <em>file_context.homedir</em> file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_file_context_local_path</td>
<td>Return path to <em>file_context.local</em> file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_file_context_path</td>
<td>Return path to <em>file_context</em> file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_file_context_subs_path</td>
<td>Return path to <em>file_context.subs</em> file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_file_context_subs_dist_path</td>
<td>Return path to <em>file_context.subs_dist</em> file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_file_context_verify</td>
<td>Verify the context of the file 'path' against policy. Return 0 if correct.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_get_callback</td>
<td>Used to get a pointer to the callback function of the given <em>type</em>. Callback functions are set using <em><strong>selinux_set_callback</strong>(3)</em>.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_getenforcemode</td>
<td>Reads the /etc/selinux/config file and determines whether the machine should be started in enforcing (1), permissive (0) or disabled (-1) mode. </td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_getpolicytype</td>
<td>Reads the /<em>etc/selinux/config</em> file and determines what the default policy for the machine is. Calling application must free <em>policytype</em>.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_homedir_context_path</td>
<td>Return path to file under the policy root directory. Note that this file will only appear in older versions of policy at this location. On systems that are managed using <em><strong>semanage</strong>(8)</em> this is now in the policy store.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_init_load_policy</td>
<td><p>Perform the initial policy load.</p>
<p>This function determines the desired enforcing mode, sets the the *enforce argument accordingly for the caller to use, sets the SELinux kernel enforcing status to match it, and loads the policy. It also internally handles the initial selinuxfs mount required to perform these actions.</p>
<p>The function returns 0 if everything including the policy load succeeds. In this case, init is expected to re-exec itself in order to transition to the proper security context. Otherwise, the function returns -1, and init must check *enforce to determine how to proceed. If enforcing (*enforce &gt; 0), then init should halt the system. Otherwise, init may proceed normally without a re-exec.</p></td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_lsetfilecon_default</td>
<td>This function sets the file context to the system defaults. Returns 0 on success.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_lxc_contexts_path</td>
<td>Return the path to the <em>lxc_contexts</em> configuration file.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_media_context_path</td>
<td>Return path to file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_mkload_policy</td>
<td><p>Make a policy image and load it. </p>
<p>This function provides a higher level interface for loading policy than <strong>security_load_policy</strong>(3), internally determining the right policy version, locating and opening the policy file, mapping it into memory, manipulating it as needed for current boolean settings and/or local definitions, and then calling <strong>security_load_policy</strong>(3) to load it.</p>
<p>'preservebools' is a boolean flag indicating whether current policy boolean values should be preserved into the new policy (if 1) or reset to the saved policy settings (if 0). The former case is the default for policy reloads, while the latter case is an option for policy reloads but is primarily for the initial policy load.</p></td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_netfilter_context_path</td>
<td>Returns path to the netfilter_context file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_path</td>
<td>Returns path to the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_policy_root</td>
<td>Reads the /etc/selinux/config file and returns the top level directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_raw_context_to_color</td>
<td>Perform context translation between security contexts and display colors. Returns a space-separated list of ten ten hex RGB triples prefixed by hash marks, e.g. "#ff0000". Caller must free the resulting string via <strong>free</strong>(3). Returns -1 upon an error or 0 otherwise.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_raw_to_trans_context</td>
<td>Perform context translation between the human-readable format ("translated") and the internal system format ("raw"). Caller must free the resulting context via <strong>freecon</strong>(3). Returns -1 upon an error or 0 otherwise. If passed NULL, sets the returned context to NULL and returns 0.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_removable_context_path</td>
<td>Return path to <em>removable_context</em> file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_restorecon</td>
<td><p>Relabel files that automatically calls <em><strong>selinux_restorecon_default_handle</strong>(3)</em> and <em><strong>selinux_restorecon_set_sehandle</strong>(3)</em> first time through to set the <em><strong>selabel_open</strong>(3)</em> parameters to use the currently loaded policy <em>file_contexts</em> and request their computed digest.</p>
<p>Should other <em><strong>selabel_open</strong>(3)</em> parameters be required see <em><strong>selinux_restorecon_set_sehandle</strong>(3)</em>.</p></td>
<td>restorecon.h</td>
</tr>
<tr>
<td>selinux_restorecon_xattr</td>
<td><p>Read/remove <em>RESTORECON_LAST</em> xattr entries that automatically calls <em><strong>selinux_restorecon_default_handle</strong>(3)</em> and <em><strong>selinux_restorecon_set_sehandle</strong>(3)</em> first time through to set the <em><strong>selabel_open</strong>(3)</em> parameters to use the currently loaded policy <em>file_contexts</em> and request their computed digest.</p>
<p>Should other <em><strong>selabel_open</strong>(3)</em> parameters be required see <em><strong>selinux_restorecon_set_sehandle</strong>(3)</em>, however note that a <em>file_contexts</em> computed digest is required for <em><strong>selinux_restorecon_xattr</strong>(3)</em>.</p></td>
<td>restorecon.h</td>
</tr>
<tr>
<td>selinux_restorecon_default_handle</td>
<td>Sets default <em><strong>selabel_open</strong>(3)</em> parameters to use the currently loaded policy and <em>file_contexts</em>, also requests the digest.</td>
<td>restorecon.h</td>
</tr>
<tr>
<td>selinux_restorecon_set_alt_rootpath</td>
<td>Use alternate rootpath.</td>
<td>restorecon.h</td>
</tr>
<tr>
<td>selinux_restorecon_set_exclude_list</td>
<td>Add a list of directories that are to be excluded from relabeling.</td>
<td>restorecon.h</td>
</tr>
<tr>
<td>selinux_restorecon_set_sehandle</td>
<td>Set the global fc handle. Called by a process that has already called <em><strong>selabel_open</strong>(3)</em> with its required parameters, or if <em><strong>selinux_restorecon_default_handle</strong>(3)</em> has been called to set the default <em><strong>selabel_open</strong>(3)</em> parameters.</td>
<td>restorecon.h</td>
</tr>
<tr>
<td>selinux_securetty_types_path</td>
<td>Return path to the securetty_types file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_sepgsql_context_path</td>
<td>Return path to <em>sepgsql_context</em> file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_set_callback</td>
<td>Sets the callback according to the type: <em>SELINUX_CB_LOG</em>, <em>SELINUX_CB_AUDIT</em>, <em>SELINUX_CB_VALIDATE</em>, <em>SELINUX_CB_SETENFORCE</em>, <em>SELINUX_CB_POLICYLOAD</em></td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_set_mapping</td>
<td>Userspace class mapping support that establishes a mapping from a user-provided ordering of object classes and permissions to the numbers actually used by the loaded system policy.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_set_policy_root</td>
<td>Sets an alternate policy root directory path under which the compiled policy file and context configuration files exist.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_status_open</td>
<td>Open and map SELinux kernel status page.</td>
<td>avc.h</td>
</tr>
<tr>
<td>selinux_status_close</td>
<td>Unmap and close kernel status page.</td>
<td>avc.h</td>
</tr>
<tr>
<td>selinux_status_updated</td>
<td>Inform whether the kernel status has been updated.</td>
<td>avc.h</td>
</tr>
<tr>
<td>selinux_status_getenforce</td>
<td>Get the enforce flag value.</td>
<td>avc.h</td>
</tr>
<tr>
<td>selinux_status_policyload</td>
<td>Get the number of policy loads.</td>
<td>avc.h</td>
</tr>
<tr>
<td>selinux_status_deny_unknown</td>
<td>Get behaviour for undefined classes/permissions.</td>
<td>avc.h</td>
</tr>
<tr>
<td>selinux_systemd_contexts_path</td>
<td>Returns the path to the <em>systemd_contexts</em> configuration file.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_reset_config</td>
<td>Force a reset of the loaded configuration. <strong>WARNING</strong>: This is not thread safe. Be very sure that no other threads are calling into <em>libselinux</em> when this is called.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_trans_to_raw_context</td>
<td>Perform context translation between the human-readable format ("translated") and the internal system format ("raw"). Caller must free the resulting context via <strong>freecon</strong>(3). Returns -1 upon an error or 0 otherwise. If passed NULL, sets the returned context to NULL and returns 0.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_translations_path</td>
<td>Return path to setrans.conf file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_user_contexts_path</td>
<td>Return path to file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_users_path (deprecated)</td>
<td>Return path to file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_usersconf_path</td>
<td>Return path to file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_virtual_domain_context_path</td>
<td>Return path to file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_virtual_image_context_path</td>
<td>Return path to file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinux_x_context_path</td>
<td>Return path to x_context file under the policy root directory.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>selinuxfs_exists</td>
<td>Check if selinuxfs exists as a kernel filesystem.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>set_matchpathcon_canoncon (deprecated)</td>
<td>Same as <strong>set_matchpathcon_invalidcon</strong>(3), but also allows canonicalization of the context, by changing *context to refer to the canonical form. If not set, and invalidcon is also not set, then this defaults to calling <strong>security_canonicalize_context</strong>(3).</td>
<td>selinux.h</td>
</tr>
<tr>
<td>set_matchpathcon_flags (deprecated)</td>
<td><p>Set flags controlling operation of <strong>matchpathcon_init</strong>(3) or <strong>matchpathcon</strong>(3): </p>
<p>MATCHPATHCON_BASEONLY - Only process the base file_contexts file. </p>
<p>MATCHPATHCON_NOTRANS - Do not perform any context translation.</p>
<p>MATCHPATHCON_VALIDATE - Validate/canonicalize contexts at init time.</p></td>
<td>selinux.h</td>
</tr>
<tr>
<td>set_matchpathcon_invalidcon (deprecated)</td>
<td>Set the function used by <strong>matchpathcon_init</strong>(3) when checking the validity of a context in the file_contexts configuration. If not set, then this defaults to a test based on <strong>security_check_context</strong>(3). The function is also responsible for reporting any such error, and may include the 'path' and 'lineno' in such error messages.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>set_matchpathcon_printf (deprecated)</td>
<td>Set the function used by <strong>matchpathcon_init</strong>(3) when displaying errors about the file_contexts configuration. If not set, then this defaults to fprintf(stderr, fmt, ...).</td>
<td>selinux.h</td>
</tr>
<tr>
<td>set_selinuxmnt </td>
<td>Set the path to the selinuxfs mount point explicitly. Normally, this is determined automatically during libselinux initialization, but this is not always possible, e.g. for /sbin/init which performs the initial mount of selinuxfs.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>setcon</p>
<p>setcon_raw</p></td>
<td><p>Set the current security context to con.</p>
<p>Note that use of this function requires that the entire application be trusted to maintain any desired separation between the old and new security contexts, unlike exec-based transitions performed via <strong>setexeccon</strong>(3). When possible, decompose your application and use <strong>setexeccon</strong>(3)+<strong>execve</strong>(3) instead. Note that the application may lose access to its open descriptors as a result of a <strong>setcon</strong>(3) unless policy allows it to use descriptors opened by the old context. </p></td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>setexeccon</p>
<p>setexeccon_raw</p></td>
<td>Set exec security context for the next <strong>execve</strong>(3). Call with NULL if you want to reset to the default.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>setexecfilecon</td>
<td>Set an appropriate security context based on the filename of a helper program, falling back to a new context with the specified type.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>setfilecon</p>
<p>setfilecon_raw</p></td>
<td>Wrapper for the xattr API - Set file context.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>setfscreatecon</p>
<p>setfscreatecon_raw</p></td>
<td>Set the fscreate security context for subsequent file creations. Call with NULL if you want to reset to the default.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>setkeycreatecon</p>
<p>setkeycreatecon_raw</p></td>
<td>Set the keycreate security context for subsequent key creations. Call with NULL if you want to reset to the default.</td>
<td>selinux.h</td>
</tr>
<tr>
<td><p>setsockcreatecon</p>
<p>setsockcreatecon_raw</p></td>
<td>Set the sockcreate security context for subsequent socket creations. Call with NULL if you want to reset to the default.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>sidget (deprecated)</td>
<td>From 2.0.86 this is a no-op.</td>
<td>avc.h</td>
</tr>
<tr>
<td>sidput (deprecated)</td>
<td>From 2.0.86 this is a no-op.</td>
<td>avc.h</td>
</tr>
<tr>
<td>string_to_av_perm</td>
<td>Convert string names to access vector permissions.</td>
<td>selinux.h</td>
</tr>
<tr>
<td>string_to_security_class</td>
<td>Convert string names to security class values.</td>
<td>selinux.h</td>
</tr>
</tbody>
</table>

<!-- %CUTHERE% -->

---
**[[ PREV ]](object_classes_permissions.md)** **[[ TOP ]](#)** **[[ NEXT ]](selinux_cmds.md)**
