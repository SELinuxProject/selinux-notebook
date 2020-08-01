# X-Windows SELinux Support

The SELinux X-Windows (XSELinux) implementation provides fine grained
access control over the majority of the X-server objects (known as
resources) using an X-Windows extension acting as the object manager
(OM). The extension name is **SELinux**.

The X-Windows object classes and permissions are listed in the
[**X Windows Object Classes**](object_classes_permissions.md#x-windows-object-classes)
section and the Reference Policy modules have been updated to enforce policy
using the XSELinux object manager.

On Fedora XSELinux is disabled in the targeted policy via the
*xserver_object_manager* boolean.

## Infrastructure Overview

It is important to note that the X-Windows OM operates on the low level
window objects of the X-server. A windows manager (such as Gnome or twm)
would then sit above this, however they (the windows manager or even the
lower level Xlib) would not be aware of the policy being enforced by
SELinux. Therefore there can be situations where X-Windows applications
get bitter & twisted at the denial of a service. This can result in
either opening the policy more than desired, or just letting the
application keep aborting, or modifying the application.

![](./images/23-x-server.png)

**Figure 23: X-Server and XSELinux Object Manager** - *Showing the supporting
services. The kernel space services are discussed in the
[**Linux Security Module and SELinux**](lsm_selinux.md#linux-security-module-and-selinux)
section.*

Using **Figure 23: X-Server and XSELinux Object Manager**, the major components
that form the overall XSELinux OM are (top left to right):

**The Policy** - The Reference Policy has been updated, however in
Fedora the OM is enabled for mls and disabled for targeted policies via
the *xserver-object-manager* boolean. Enabling this boolean also
initialises the XSELinux OM extension. Important note - The boolean
must be present in any policy and be set to *true*, otherwise the
object manager will be disabled as the code specifically checks for the
boolean.

***libselinux*** - This library provides the necessary interfaces
between the OM, the SELinux userspace services (e.g. reading
configuration information and providing the AVC), and kernel services
(e.g. security server for access decisions and policy update
notification).

***x_contexts*** File - This contains default context configuration
information that is required by the OM for labeling certain objects. The
OM reads its contents using the ***selabel_lookup**(3)* function.

**XSELinux Object Manager** - This is an X-extension for the X-server
process that mediates all access decisions between the the X-server (via
the XACE interface) and the SELinux security server (via *libselinux*).
The OM is initialised before any X-clients connect to the X-server.

The OM has also added XSELinux functions that are described in to allow
contexts to be retrieved and set by userspace SELinux-aware
applications.

**XACE Interface** - This is an 'X Access Control Extension' (XACE) that
can be used by other access control security extensions, not only
SELinux. Note that if other security extensions are linked at the same
time, then the X-function will only succeed if allowed by all the
security extensions in the chain.

This interface is defined in the
"[**X Access Control Extension Specification**](http://www.x.org/releases/X11R7.5/doc/security/XACE-Spec.pdf)".
The specification also defines the hooks available to OMs and
how they should be used. The provision of polyinstantiation services for
properties and selections is also discussed. The XACE interface is a
similar service to the LSM that supports the kernel OMs.

**X-server** - This is the core X-Windows server process that handles
all request and responses to/from X-clients using the X-protocol. The
XSELinux OM is intercepting these request/responses via XACE and
enforcing policy decisions.

**X-clients** - These connect to the X-server are are typically windows
managers such as Gnome, twm or KDE.

**Kernel-Space Services** - These are discussed in the
[**Linux Security Module and SELinux**](lsm_selinux.md#linux-security-module-and-selinux)
section.

## Polyinstantiation

The OM / XACE services support polyinstantiation of properties and
selections allowing these to be grouped into different membership areas
so that one group does not know of the exsistance of the others. To
implement polyinstantiation the *poly_* keyword is used in the
[***x_contexts***](policy_config_files.md#contextsx_contexts) for the required
selections and properties, there would then be a corresponding
[***type_member***](type_statements.md#type_member) in the policy to enforce
the separation by computing a new context with either
***security_compute_member**(3)* or ***avc_compute_member**(3)*.

Note that the current Reference Policy does not implement
polyinstantiation, instead the MLS policy uses
[***mlsconstrain***](constraint_statements.md#mlsconstrain) to limit the scope
of properties and selections.

## Configuration Information

This section covers:

-   How to enable/disable the OM X-extension.
-   How to determine the OM X-extension opcode.
-   How to configure the OM in a specific SELinux enforcement mode.
-   The *x-contexts* configuration file.

### Enable/Disable the OM from Policy Decisions

The Reference Policy has an *xserver_object_manager* boolean that
enables/disables the X-server policy module and also stops the object
manager extension from initialising when X-Windows is started. The
following command will enable the boolean, however it will be necessary
to reload X-Windows to initialise the extension (i.e. run the **init 3**
and then **init 5** commands):

```
setsebool -P xserver_object_manager true
```

If the boolean is set to *false*, the x-server log will indicate
that "SELinux: Disabled by boolean". Important note - If the boolean is
not present in a policy then the object manager will always be enabled
(therefore if not required then either do not include the object manager
in the X-server build or add the boolean to the policy and set it to false
or add a disabled entry to the **xorg.conf** file as described in the next
section.

### Configure OM Enforcement Mode

If the X-server object manager needs to be run in a specific SELinux
enforcement mode, then the option may be added to the *xorg.conf* file
(normally in */etc/X11/xorg.conf.d*). The option entries are as follows:

-   SELinux mode disabled
-   SELinux mode permissive
-   SELinux mode enforcing

Note that the entry must be exact otherwise it will be ignored. An
example entry is:

```
Section "Module"
	SubSection "extmod"
		Option "SELinux mode enforcing"
	EndSubSection
EndSection
```

If there is no entry, the object manager will follow the current
SELinux enforcement mode.

### Determine OM X-extension Opcode

The object manager is treated as an X-server extension and its major
opcode can be queried using Xlib *XQueryExtension* function as follows:

```
/* Get the SELinux Extension opcode */

if (!XQueryExtension (dpy, "SELinux", &opcode, &event, &error)) {
	perror ("XSELinux extension not available");
	exit (1);
	}
else
	printf("XQueryExtension for XSELinux Extension - Opcode: %d Events: %d Error: %d\n",
	       opcode, event, error);

/* Have XSELinux Object Manager */
```

### The *x_contexts* File

The *x_contexts* file contains default context information that is
required by the OM to initialise the service and then label objects as
they are created. The policy will also need to be aware of the context
information being used as it will use this to enforce policy or
transition new objects. A typical entry is as follows:

```
# object_type  object_name  context
selection      PRIMARY      system_u:object_r:clipboard_xselection_t:s0
```

or for polyinstantiation support:

```
# object_type    object_name  context
poly_selection   PRIMARY      system_u:object_r:clipboard_xselection_t:s0
```

The *object_name* can contain '\*' for 'any' or '?' for 'substitute'.

The OM uses the ***selabel**(3)* functions (such as ***selabel_lookup**(3)*)
that are a part of *libselinux* to fetch the relevant information from the
*x_contexts* file.

The valid *object_type* entries are *client*, *property*,
*poly_property*, *extension*, *selection*, *poly_selection* and *events*.

The *object_name* entries can be any valid X-server resource name
that is defined in the X-server source code and can typically be found
in the *protocol.txt* and *BuiltInAtoms* source files (in the *dix*
directory of the **xorg-server** source package), or user generated via
the Xlib libraries (e.g. *XInternAtom*).

**Notes:**

1.  The way the XSELinux extension code works (see
    *xselinux_label.c* - SELinuxAtomToSIDLookup()) is that non-poly
    entries are searched for first, if an entry is not found then it
    searches for a matching poly entry. The reason for this behavior is
    that when operating in a secure environment all objects would be
    polyinstantiated unless there are specific exemptions made for
    individual objects to make them non-polyinstantiated. There would
    then be a 'poly_selection' or 'poly_property' at the end of the section.
2.  For systems using the Reference Policy all X-clients connecting
    remotely will be allocated a security context from the *x_contexts*
    file of:

```
# object_type object_name context
client * system_u:object_r:remote_t:s0
```

A full description of the *x_contexts* file format is given in the
[***x_contexts***](policy_config_files.md#contextsx_contexts) section.

## SELinux Extension Functions

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxQueryVersion              | 0                | None       |

Returns the XSELinux version. Fedora returns 1.1.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxSetDeviceCreateContext    | 1                | Context + Len         |

Sets the context for creating a device object (*x_device*).

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetDeviceCreateContext    | 2                | None                  |

Retrieves the context set by *XSELinuxSetDeviceCreateContext*.

| Function Name                   | Minor Parameter | Opcode                   |
| ------------------------------- | --------------- | ------------------------ |
| XSELinuxSetDeviceContext        | 3               | DeviceID + Context + Len |

Sets the context for creating the specified DeviceID object.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetDeviceContext          | 4                | DeviceID              |

Retrieves the context set by *XSELinuxSetDeviceContext*.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxSetWindowCreateContext    | 5                | Context + Len         |

Set the context for creating a window object (*x_window*).

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetWindowCreateContext    | 6                | None                  |

Retrieves the context set by *XSELinuxSetWindowCreateContext*.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetWindowContext          | 7                | WindowID              |

Retrieves the specified WindowID context.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxSetPropertyCreateContext  | 8                | Context               |

Sets the context for creating a property object (*x_property*).

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetPropertyCreateContext  | 9                | None                  |

Retrieves the context set by *XSELinuxSetPropertyCreateContext*.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxSetPropertyUseContext     | 10               | Context + Len         |

Sets the context of the property object to be retrieved when polyinstantiation
is being used.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetPropertyUseContext     | 11               | None                  |

Retrieves the property object context set by *SELinuxSetPropertyUseContext*.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetPropertyContext        | 12               | WindowID + AtomID     |

Retrieves the context of the property atom object.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetPropertyDataContext    | 13               | WindowID + AtomID     |

Retrieves the context of the property atom data.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxListProperties            | 14               | WindowID              |

Lists the object and data contexts of properties associated with the selected
WindowID.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxSetSelectionCreateContext | 15               | Context + Len         |

Sets the context to be used for creating a selection object.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetSelectionCreateContext | 16               | None                  |

Retrieves the context set by *SELinuxSetSelectionCreateContext*.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxSetSelectionUseContext    | 17               | Context + Len         |

Sets the context of the selection object to be retrieved when polyinstantiation
is being used. See the *XSELinuxListSelections* function for an example.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetSelectionUseContext    | 18               | None                  |

Retrieves the selection object context set by *SELinuxSetSelectionUseContext*.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetSelectionContext       | 19               | AtomID                |

Retrieves the context of the specified selection atom object.

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetSelectionDataContext   | 20               | AtomID                |

Retrieves the context of the selection data from the current selection owner
(*x_application_data* object).

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxListSelections            | 21               | None                  |

Lists the selection atom object and data contexts associated with this display.
The main difference in the listings is that when (for example) the *PRIMARY*
selection atom is polyinstantiated, multiple entries can returned. One has the 
context of the atom itself, and one entry for each process (or x-client) that
has an active polyinstantiated entry, for example:

Atom: PRIMARY - label defined in the *x_contexts* file (this is also for
non-poly listing):

- Object Context: *system_u:object_r:primary_xselection_t*
- Data Context: *system_u:object_r:primary_xselection_t*

Atom: PRIMARY - Labels for client 1:

- Object Context: *system_u:object_r:x_select_paste1_t*
- Data Context: *system_u:object_r:x_select_paste1_t*

Atom: PRIMARY - Labels for client 2:

- Object Context: *system_u:object_r:x_select_paste2_t*
- Data Context: *system_u:object_r:x_select_paste2_t*

| Function Name                     | Minor Parameters | Opcode                |
| --------------------------------- | ---------------- | --------------------- |
| XSELinuxGetClientContext          | 22               | ResourceID            |

Retrieves the client context of the specified ResourceID.

**Table 12: The XSELinux Extension Functions** - *Supported by the object
manager as X-protocol extensions. Note that some functions will return
the default contexts, while others (2, 6, 9, 11, 16, 18) will not return
a value unless one has been set the the appropriate function (1, 5, 8,
10, 15, 17) by an SELinux-aware application.*

<!-- %CUTHERE% -->

---
**[[ PREV ]](vm_support.md)** **[[ TOP ]](#)** **[[ NEXT ]](postgresql.md)**
