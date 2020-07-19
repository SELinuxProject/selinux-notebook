# -*- Mode: makefile; indent-tabs-mode: t -*-
# SPDX-License-Identifier: Unlicense

.PHONY: install

all: install

install:
	mkdir -p /etc/selinux/cil-policy/{contexts,logins,policy,contexts/files,contexts/users}
	touch /etc/selinux/cil-policy/contexts/customizable_types
	touch /etc/selinux/cil-policy/contexts/file_contexts.subs_dist
	echo -e """<!DOCTYPE busconfig PUBLIC \
\"-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN\" \
\n\"http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd\"> \
\n<busconfig> \
\n<selinux> \
\n</selinux> \
\n</busconfig>""" > /etc/selinux/cil-policy/contexts/dbus_contexts
	echo "sys.role:sys.isid sys.role:sys.isid" > /etc/selinux/cil-policy/contexts/default_contexts
	echo "sys.role:sys.isid" > /etc/selinux/cil-policy/contexts/default_type
	echo "sys.role:sys.isid" > /etc/selinux/cil-policy/contexts/failsafe_context
	echo -e """cdrom sys.id:sys.role:sys.isid \
\nfloppy sys.id:sys.role:sys.isid \
\ndisk sys.id:sys.role:sys.isid""" > /etc/selinux/cil-policy/contexts/files/media
	echo "privsep_preauth=sys.isid" > /etc/selinux/cil-policy/contexts/openssh_contexts
	echo "sys.id:sys.role:sys.isid" > /etc/selinux/cil-policy/contexts/removable_context
	echo "sys.isid" > /etc/selinux/cil-policy/contexts/securetty_types
	echo "sys.id:sys.role:sys.isid" > /etc/selinux/cil-policy/contexts/virtual_domain_context
	echo -e """sys.id:sys.role:sys.isid \
\nsys.id:sys.role:sys.isid""" > /etc/selinux/cil-policy/contexts/virtual_image_context
	semodule --priority=100 -N -s cil-policy -i cil-policy.cil
